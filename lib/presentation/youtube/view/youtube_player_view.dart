import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/widgets/youtube_animated_bar_widget.dart';
import 'package:telephony_rakuten_assignment/presentation/youtube/widgets/youtube_data_chart_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controller/youtube_player_controller.dart';
import '../../../const/app_colors.dart';
import '../../../utils/textstyle_utils.dart';
import 'package:fl_chart/fl_chart.dart';

class YoutubePlayerView extends GetView<YoutubePlayerGetxController> {
  const YoutubePlayerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller.youtubeController,
        showVideoProgressIndicator: true,
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Youtube Video',
            style: TextStyleUtils.blackColorBoldText(20),
          ),
        ),
        body: Column(
          children: [
            player,
            const SizedBox(height: 16),
            Obx(() => AnimatedDataBar(
                  usedMb: controller.usedData.value ~/ 1024,
                  maxMb: (controller.maxVolumeMb.value is int) ? controller.maxVolumeMb.value as int : int.tryParse(controller.maxVolumeMb.value?.toString() ?? '0') ?? 0,
                )),
            const SizedBox(height: 16),
            Obx(() => Text(
                  'Anlık Download: ${controller.currentSpeed.value.downloadSpeed} KB/s',
                  style: TextStyleUtils.blackColorRegularText(16),
                )),
            const SizedBox(height: 16),
            Obx(() => YoutubeDataChartWidget(controller: controller)),
          ],
        ),
      ),
    );
  }
}
