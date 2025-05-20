import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:traffic_stats/traffic_stats.dart';
import 'package:flutter/material.dart';
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

  @override
  void onInit() {
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
      print('Download Speed: ${speedData.downloadSpeed} KB/s');
      print('Upload Speed: ${speedData.uploadSpeed} KB/s');
      currentSpeed.value = speedData;
      usedData.value += speedData.downloadSpeed + speedData.uploadSpeed;
      downloadSpeedList.add(speedData.downloadSpeed);
      if (downloadSpeedList.length > 30) {
        downloadSpeedList.removeAt(0);
      }
      final maxVol = maxVolumeMb.value ?? 0;
      if ((usedData.value ~/ 1024) >= maxVol && !isDialogShown) {
        youtubeController.pause();
        isDialogShown = true;
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
      },
      isDismissable: false,
    );
  }

  @override
  void onClose() {
    youtubeController.dispose();
    networkSpeedService.dispose();
    super.onClose();
  }
}
