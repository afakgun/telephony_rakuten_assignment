import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:telephony/telephony.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';
import 'package:telephony_rakuten_assignment/core/services/firebase_service.dart';

class HomeController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  RxnString userName = RxnString(null);
  RxnString userPhone = RxnString(null);
  final userCountryCode = RxnString(null);
  List<SignalStrength> strenghts = [];

  final youtubeUrlController = TextEditingController();
  final youtubeVolumeController = TextEditingController();

  RxList<int> signalStrength = RxList();

  final Telephony telephony = Telephony.instance;

  Timer? _callTimer;
  int _remainingSeconds = 0;
  bool _isCallActive = false;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  Future<void> sendSms(String phoneNumber, String message) async {
    try {
      bool permissionsGranted = await telephony.requestPhoneAndSmsPermissions ?? false;
      if (!permissionsGranted) {
        print('SMS izni verilmedi');
        return;
      }

      final SmsSendStatusListener listener = (SendStatus status) {
        print('SMS gönderim durumu: $status');
      };
      await telephony.sendSms(
        to: phoneNumber,
        message: message,
        statusListener: listener,
      );
    } catch (e) {
      print('SMS gönderilemedi: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
    _getSignalStrength();
    _initNotifications();
  }

  _getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = prefs.getString('user_uid');
    //get user info from firestore
    final user = await FirebaseFirestore.instance.collection('users').doc(userUid).get();
    userName.value = user['firstName'] + ' ' + user['lastName'];
    userPhone.value = user['phoneNumber'];
    userCountryCode.value = user['country_code'];
  }

  Future<void> _initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  Future<void> startCallTimer(int durationMinutes, String receiverNumber) async {
    await Future.delayed(Duration(seconds: 3));
    _remainingSeconds = durationMinutes * 60;
    _isCallActive = true;
    _callTimer?.cancel();
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      print(_remainingSeconds);
      print(timer.tick);
      final callState = await _getCallState();
      if (callState == CallState.OFFHOOK || callState == CallState.RINGING) {
        _getSignalStrength().then((value) {
          signalStrength.add(value[0].index);
        });
      } else {
        await _onCallEnded(
          receiverNumber: receiverNumber,
          durationInMinutes: durationMinutes,
          callDurationInMinutes: timer.tick,
          qualityStrengthList: signalStrength.toList(),
        );
        timer.cancel();
      }
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
      } else {
        if (callState == CallState.OFFHOOK || callState == CallState.RINGING) {
          await _showLocalNotification();
        }
      }
    });
  }

  Future<void> _onCallEnded({
    required String receiverNumber,
    required int durationInMinutes,
    required int callDurationInMinutes,
    required List<int> qualityStrengthList,
  }) async {
    _isCallActive = false;

    // Log call data to Firebase
    await _firebaseService.logCallData(
      callDurationInMinutes: callDurationInMinutes,
      receiverNumber: receiverNumber,
      durationInMinutes: durationInMinutes,
      qualityStrengthList: qualityStrengthList.map((e) => e.toString()).toList(), // Convert int list to String list
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

  Future<void> startYoutubeStreaming() async {
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
    Get.toNamed('/youtube', arguments: {'url': url, 'maxVolumeMb': volumeMb});
  }
}
