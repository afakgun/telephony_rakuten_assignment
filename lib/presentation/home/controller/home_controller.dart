import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:telephony/telephony.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';
import 'package:telephony_rakuten_assignment/presentation/home/model/last_call_model.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';
import 'package:telephony_rakuten_assignment/presentation/home/service/home_service.dart';
import 'package:telephony_rakuten_assignment/utils/loading_utils.dart';
import 'package:telephony_rakuten_assignment/routes/app_pages.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/model/youtube_kpi_model.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/service/youtube_service.dart';
import 'package:telephony_rakuten_assignment/presentation/home/model/sms_kpi_model.dart';

class HomeController extends GetxController {
  final HomeService _homeService = HomeService();

  RxnString userName = RxnString(null);
  RxnString userPhone = RxnString(null);
  final userCountryCode = RxnString(null);
  List<SignalStrength> strenghts = [];

  final youtubeUrlController = TextEditingController();
  final youtubeVolumeController = TextEditingController();

  final Telephony telephony = Telephony.instance;
  RxList<int> signalStrength = RxList();
  Rxn<LastCallModel> lastCallModel = Rxn<LastCallModel>(null);
  Rxn<YoutubeKpiModel> youtubeKpiModel = Rxn<YoutubeKpiModel>(null);
  Rxn<SmsKpiModel> smsKpiModel = Rxn<SmsKpiModel>(null);

  Timer? _callTimer;
  int _remainingSeconds = 0;
  bool _isCallActive = false;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future<void> sendSms(String phoneNumber, String message, BuildContext context) async {
    try {
      final uid = SharedPreferencesService.getString('user_uid');
      LoadingUtils.startLoading(context);
      await Future.delayed(Duration(seconds: 3));
      bool permissionsGranted = await telephony.requestSmsPermissions ?? false;
      if (!permissionsGranted) {
        print('SMS izni verilmedi');
        return;
      }

      listener(SendStatus status) {
        print(status);
        if (status == SendStatus.SENT || status == SendStatus.DELIVERED) {
          if (uid != null) {
            _homeService.sendSms(phoneNumber, message, true, uid);
          }
        }
      }

      await telephony.sendSms(
        to: phoneNumber,
        message: message,
        statusListener: listener,
      );
    } catch (e) {
      print('SMS gönderilemedi: $e');
      final uid = SharedPreferencesService.getString('user_uid');
      if (uid != null) {
        _homeService.sendSms(phoneNumber, message, false, uid);
      }
    } finally {
      LoadingUtils.stopLoading();
    }
  }

  @override
  void onInit() {
    super.onInit();
    _checkAndroidVersion();
    _getUserInfo();
    _getSignalStrength();
    _initNotifications();
    _requestNotificationPermissionIfNeeded();
  }

  @override
  onReady() {
    super.onReady();
    _getLastCallData();
    _getLastYoutubeKpi();
    _getLastSmsKpi();
  }

  Future<void> _getLastYoutubeKpi() async {
    final userUid = await SharedPreferencesService.getString('user_uid');
    if (userUid == null) return;
    final kpi = await YoutubeService.getLastKpiByUid(userUid);
    youtubeKpiModel.value = kpi;
  }

  _getLastSmsKpi() async {
    final userUid =  SharedPreferencesService.getString('user_uid');
    if (userUid == null) return;
    final kpi = await _homeService.getLastSmsKpiByUid(userUid);
    if (kpi != null) {
      smsKpiModel.value = SmsKpiModel.fromJson(kpi as Map<String, dynamic>);
      print(kpi);
    } else {
      smsKpiModel.value = null;
    }
  }

  _checkAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 29) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'warning'.tr,
          message: 'android_version_warning'.tr,
          buttonLeftText: '',
          buttonLeftAction: null,
          buttonRightText: 'Tamam',
          buttonRightAction: () => Get.back(),
          isDismissable: false,
        );
      }
    }
  }

  _getUserInfo() async {
    final userUid = SharedPreferencesService.getString('user_uid');
    final user = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    userName.value = user['firstName'] + ' ' + user['lastName'];
    userPhone.value = user['phoneNumber'];
    userCountryCode.value = user['countryCode'];
  }

  Future<void> _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  Future<void> _requestNotificationPermissionIfNeeded() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> startCallTimer(int durationMinutes, String receiverNumber, BuildContext context) async {
    try {
      LoadingUtils.startLoading(context);
      bool permissionsGranted = await telephony.requestPhonePermissions ?? false;
      if (!permissionsGranted) {
        print('SMS izni verilmedi');
        return;
      }
      await Future.delayed(Duration(seconds: 3));
      _remainingSeconds = durationMinutes * 60;
      _isCallActive = true;
      RxList<int> signalStrength = RxList();
      _callTimer?.cancel();
      _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        final callState = await _getCallState();
        if (callState == CallState.OFFHOOK || callState == CallState.RINGING) {
          _getSignalStrength().then((value) {
            signalStrength.add(value[0].index);
          });
        } else {
          if (_isCallActive) {
            await _onCallEnded(
              receiverNumber: receiverNumber,
              selectedDurationInMinutes: durationMinutes,
              callDurationInSeconds: timer.tick,
              qualityStrengthList: signalStrength.toList(),
            );
          }
          _getLastCallData();

          timer.cancel();
        }
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          if (callState == CallState.OFFHOOK || callState == CallState.RINGING) {
            endCall();
            await _showLocalNotification();
          }
        }
      });
    } finally {
      LoadingUtils.stopLoading();
    }
  }

  Future<void> _onCallEnded({
    required String receiverNumber,
    required int selectedDurationInMinutes,
    required int callDurationInSeconds,
    required List<int> qualityStrengthList,
  }) async {
    _isCallActive = false;

    await _homeService.logCallData(
      callDurationInSeconds: callDurationInSeconds,
      receiverNumber: receiverNumber,
      selectedDurationInMinutes: selectedDurationInMinutes,
      qualityStrengthList: qualityStrengthList.map((e) => e).toList(),
    );
  }

  Future<void> _showLocalNotification() async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'call_channel',
      'Call Notifications',
      channelDescription: 'call_notification_desc'.tr,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin?.show(
      0,
      'call_time_up'.tr,
      'call_time_up_desc'.tr,
      platformChannelSpecifics,
      payload: 'call_timeout',
    );
  }

  void stopCallTimer() {
    _callTimer?.cancel();
    _isCallActive = false;
  }

  Future<bool> endCall() async {
    try {
      const platform = MethodChannel('com.telephony.rakutenassignment/end_call');
      final result = await platform.invokeMethod<bool>('endCall');
      print("is call ended: " + result.toString());
      return result ?? false;
    } catch (e) {
      print("Error ending call: $e");
      return false;
    }
  }

  Future<List<SignalStrength>> _getSignalStrength() async {
    strenghts = await telephony.signalStrengths;
    return strenghts;
  }

  _getCellularDataState() async {
    DataState state = await telephony.cellularDataState;
    print(state);
  }

  Future<CallState> _getCallState() async {
    try {
      var state = await telephony.callState;
      print(state);
      return state;
    } catch (e) {
      print("Call state error: $e");
      return CallState.IDLE;
    }
  }

  _getDataActivity() async {
    DataActivity activity = await telephony.dataActivity;

    print(activity);
  }

  _getNetworkOperatorName() async {
    String? name = await telephony.networkOperatorName;
    print(name);
  }

  _getNetworkType() async {
    NetworkType type = await telephony.dataNetworkType;
    print(type);
  }

  _getPhoneType() async {
    PhoneType type = await telephony.phoneType;
    print(type);
  }

  _getSimState() async {
    SimState state = await telephony.simState;
    print(state);
  }

  _getSimOperatorName() async {
    String? name = await telephony.simOperatorName;
    print(name);
  }

  _isSmsCapable() async {
    bool? isSmsCapable = await telephony.isSmsCapable;
    print(isSmsCapable);
  }

  _getNetworkOperator() async {
    String? operator = await telephony.networkOperator;
    print(operator);
  }

  _getSimOperator() async {
    String? simOperator = await telephony.simOperator;
    print(simOperator);
  }

  _isNetworkRoaming() async {
    bool? isRoaming = await telephony.isNetworkRoaming;
    print(isRoaming);
  }

  _getSignalStrengths() async {
    List<SignalStrength> strengths = await telephony.signalStrengths;
    print(strengths);
  }

  _getServiceState() async {
    ServiceState state = await telephony.serviceState;
    print(state);
  }

  _getLastCallData() async {
    try {
      final userUid = (await SharedPreferences.getInstance()).getString('user_uid');
      if (userUid == null) return;
      final rawData = await _homeService.getLastCallDataOfUser(userUid);
      print(rawData);
      if (rawData == null) return;

      final data = rawData as Map<String, dynamic>;

      if (data['timestamp'] is Timestamp) {
        data['timestamp'] = (data['timestamp'] as Timestamp).millisecondsSinceEpoch;
      }

      final encodedData = json.encode(data);
      LastCallModel model = LastCallModel.fromJson(json.decode(encodedData));
      lastCallModel.value = model;
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await SharedPreferencesService.remove('user_uid');
    Get.offAllNamed(Routes.WELCOME);
  }

  Future<void> startYoutubeStreaming(BuildContext context) async {
    try {
      LoadingUtils.startLoading(context);
      final url = youtubeUrlController.text.trim();
      final volumeMb = int.tryParse(youtubeVolumeController.text.trim()) ?? 0;
      if (url.isEmpty || volumeMb <= 0) return;

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.any((element) => element == ConnectivityResult.wifi)) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'warning'.tr,
          message: 'youtube_cellular_only'.tr,
          buttonLeftText: '',
          buttonLeftAction: null,
          buttonRightText: 'Tamam',
          buttonRightAction: () => Get.back(),
        );
        return;
      }
      if (connectivityResult.any((element) => element == ConnectivityResult.none)) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'no_connection'.tr,
          message: 'no_internet'.tr,
          buttonLeftText: '',
          buttonLeftAction: null,
          buttonRightText: 'Tamam',
          buttonRightAction: () => Get.back(),
        );
        return;
      }
      Get.toNamed('/youtube', arguments: {
        'url': url,
        'volumeMb': volumeMb,
      });
    } finally {
      LoadingUtils.stopLoading();
    }
  }
}
