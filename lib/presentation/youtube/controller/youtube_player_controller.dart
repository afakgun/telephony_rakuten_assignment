import 'dart:async';

import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/core/services/shared_preferences_service.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/model/youtube_kpi_model.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/service/youtube_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:traffic_stats/traffic_stats.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';

class YoutubePlayerGetxController extends GetxController {
  late YoutubePlayerController youtubeController;
  late Stream<NetworkSpeedData> speedStream;
  final Rx<NetworkSpeedData> currentSpeed = NetworkSpeedData(downloadSpeed: 0, uploadSpeed: 0).obs;

  RxInt usedData = 0.obs;
  bool isDialogShown = false;
  final RxnInt maxVolumeMb = RxnInt();
  final RxnString url = RxnString();
  final NetworkSpeedService networkSpeedService = NetworkSpeedService();
  final RxList<int> downloadSpeedList = <int>[].obs;
  final RxList<double> speedSamples = <double>[].obs; // Mbps
  final RxList<double> kbSpeeds = <double>[].obs; // KB/s
  final RxInt usedVolumeMb = 0.obs;
  final RxString videoUrl = ''.obs;
  final RxString closeReason = ''.obs;
  final RxInt usedMb = 0.obs;
  bool volumeLimitReached = false;

  double get averageSpeed {
    if (speedSamples.isEmpty) return 0;
    return speedSamples.reduce((a, b) => a + b) / speedSamples.length;
  }

  void addSpeedSample(double speedMbps) {
    speedSamples.add(speedMbps);
    kbSpeeds.add(speedMbps * 1024 / 8); // Mbps -> KB/s
  }

  void setUsedVolume(int mb) {
    usedVolumeMb.value = mb;
  }

  void setVideoUrl(String url) {
    videoUrl.value = url;
  }

  void setCloseReason(String reason) {
    closeReason.value = reason;
  }

  Future<void> closeScreen(String reason) async {
    setCloseReason(reason);
    await sendKpisToFirebase();
  }

  Future<void> sendKpisToFirebase() async {
    final uid = SharedPreferencesService.getString('user_uid');
    if (uid == null) {
      return;
    }
    final kpi = YoutubeKpiModel(
      averageSpeed: averageSpeed,
      volumeMb: usedVolumeMb.value,
      videoUrl: videoUrl.value,
      closeReason: closeReason.value,
      kbSpeeds: kbSpeeds.toList(),
      uid: uid,
      timestamp: DateTime.now(),
    );
    await YoutubeService.sendKpiToFirebase(kpi);
  }

  @override
  void onInit() {
    final args = Get.arguments ?? {};
    setVideoUrl(args['url'] ?? '');
    setUsedVolume(args['volumeMb'] ?? 0);
    super.onInit();

    url.value = Get.arguments['url'];
    maxVolumeMb.value = Get.arguments['volumeMb'];
    final videoUrl = url.value;
    if (videoUrl == null || maxVolumeMb.value == null) {
      AppDialogUtils.showOnlyContentDialog(
        title: 'error'.tr,
        message: 'invalid_url_or_limit'.tr,
        buttonLeftText: '',
        buttonLeftAction: null,
        buttonRightText: 'Tamam',
        buttonRightAction: () => Get.back(),
        isDismissable: false,
      );
      return;
    }
    youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    networkSpeedService.init();
    speedStream = networkSpeedService.speedStream;
    currentSpeed.value = NetworkSpeedData(downloadSpeed: 0, uploadSpeed: 0);

    speedStream.listen((speedData) {
      currentSpeed.value = speedData;
      addSpeedSample((speedData.downloadSpeed * 8) / 1024); // KB/s -> Mbps
      usedData.value += speedData.downloadSpeed;
      downloadSpeedList.add(speedData.downloadSpeed);
      if (downloadSpeedList.length > 30) {
        downloadSpeedList.removeAt(0);
      }
      final maxVol = maxVolumeMb.value ?? 0;
      // 1 MB = 1024 KB
      if ((usedData.value ~/ 1024) >= maxVol && !volumeLimitReached) {
        volumeLimitReached = true;
        youtubeController.pause();
        _showLimitDialog();
      }
    });
  }

  void _showLimitDialog() {
    AppDialogUtils.showOnlyContentDialog(
      title: 'data_limit_exceeded'.tr,
      message: 'data_limit_exceeded_desc'.trParams({'maxVolumeMb': maxVolumeMb.value.toString()}),
      buttonLeftText: '',
      buttonLeftAction: null,
      buttonRightText: 'Tamam',
      buttonRightAction: () {
        Get.back();
        Get.back();
        closeScreen('data_limit_exceeded');
      },
      isDismissable: false,
    );
  }

  @override
  void onClose() {
    youtubeController.dispose();
    networkSpeedService.dispose();
    if (!volumeLimitReached) {
      closeScreen('user_exit');
    }

    super.onClose();
  }
}
