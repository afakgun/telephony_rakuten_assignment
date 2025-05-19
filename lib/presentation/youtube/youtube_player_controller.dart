import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:traffic_stats/traffic_stats.dart';
import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/utils/dialog_utils.dart';

class YoutubePlayerGetxController extends GetxController {
  late YoutubePlayerController youtubeController;
  late Stream<NetworkSpeedData> speedStream;
  late NetworkSpeedData currentSpeed;
  int usedData = 0;
  bool isDialogShown = false;
  final int maxVolumeMb;
  final String url;
  final NetworkSpeedService networkSpeedService = NetworkSpeedService();

  YoutubePlayerGetxController({required this.url, required this.maxVolumeMb});

  @override
  void onInit() {
    super.onInit();
    youtubeController = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    networkSpeedService.init();
    speedStream = networkSpeedService.speedStream;
    currentSpeed = NetworkSpeedData(downloadSpeed: 0, uploadSpeed: 0);

    speedStream.listen((speedData) {
      currentSpeed = speedData;
      usedData += speedData.downloadSpeed + speedData.uploadSpeed;
      update();
      if ((usedData ~/ 1024) >= maxVolumeMb && !isDialogShown) {
        youtubeController.pause();
        isDialogShown = true;
        _showLimitDialog();
      }
    });
  }

  void _showLimitDialog() {
    AppDialogUtils.showOnlyContentDialog(
      title: 'Veri Limiti Aşıldı',
      message: 'Belirlediğiniz $maxVolumeMb MB veri limiti aşıldı. Video durduruldu.',
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
