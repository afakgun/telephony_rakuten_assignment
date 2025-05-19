import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io'; // Import dart:io for Platform

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart'; // Import device_info_plus

import 'package:telephony/telephony.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';
import 'package:telephony_rakuten_assignment/presentation/home/last_call_model.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';
import 'package:telephony_rakuten_assignment/presentation/home/home_service.dart';
import 'package:telephony_rakuten_assignment/core/localization/app_translations.dart';
import 'package:telephony_rakuten_assignment/utils/loading_utils.dart'; // Import localization

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

  Timer? _callTimer;
  int _remainingSeconds = 0;
  bool _isCallActive = false;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future<void> sendSms(String phoneNumber, String message, BuildContext context) async {
    try {
      final uid = SharedPreferencesService.getString('user_uid');
      LoadingUtils.startLoading(context);
      await Future.delayed(Duration(seconds: 3));
      bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions ?? false;
      if (!permissionsGranted) {
        print('SMS izni verilmedi');
        return;
      }

      listener(SendStatus status) {
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
    _checkAndroidVersion(); // Check Android version on init
    _getUserInfo();
    _getSignalStrength();
    _initNotifications();
  }

  @override
  onReady() {
    super.onReady();
    _getLastCallData();
  }

  _checkAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 29) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'Uyarı', // Or use localization: 'warning'.tr
          message: 'android_version_warning'.tr, // Localized warning message
          buttonLeftText: '',
          buttonLeftAction: null,
          buttonRightText: 'Tamam', // Or use localization: 'ok'.tr
          buttonRightAction: () => Get.back(),
          isDismissable: false, // Prevent dismissing by tapping outside
        );
      }
    }
  }

  _getUserInfo() async {
    final userUid = SharedPreferencesService.getString('user_uid');
    //get user info from firestore
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

  Future<void> startCallTimer(int durationMinutes, String receiverNumber, BuildContext context) async {
    try {
      LoadingUtils.startLoading(context);
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

    // Log call data to Firebase
    await _homeService.logCallData(
      callDurationInSeconds: callDurationInSeconds,
      receiverNumber: receiverNumber,
      selectedDurationInMinutes: selectedDurationInMinutes,
      qualityStrengthList: qualityStrengthList.map((e) => e).toList(), // Convert int list to String list
    );
  }

  Future<void> _showLocalNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'call_channel',
      'Call Notifications',
      channelDescription: 'Arama süresi dolduğunda bildirim gönderir',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin?.show(
      0,
      'Süre Doldu',
      'Belirlediğiniz arama süresi sona erdi. Hâlâ görüşmedesiniz.',
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
    CallState state = await telephony.callState;
    print(state);
    return state;
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

      // Convert Firestore Timestamp to milliseconds since epoch
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

  Future<void> startYoutubeStreaming(BuildContext context) async {
    try {
      LoadingUtils.startLoading(context);
      final url = youtubeUrlController.text.trim();
      final volumeMb = int.tryParse(youtubeVolumeController.text.trim()) ?? 0;
      if (url.isEmpty || volumeMb <= 0) return;

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.any((element) => element == ConnectivityResult.wifi)) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'Uyarı',
          message: 'Youtube videosu sadece hücresel veri ile açılabilir. Lütfen wifi bağlantınızı kapatın.',
          buttonLeftText: '',
          buttonLeftAction: null,
          buttonRightText: 'Tamam',
          buttonRightAction: () => Get.back(),
        );
        return;
      }
      if (connectivityResult.any((element) => element == ConnectivityResult.none)) {
        AppDialogUtils.showOnlyContentDialog(
          title: 'Bağlantı Yok',
          message: 'İnternet bağlantısı bulunamadı.',
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
