import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'youtube_player_controller.dart';
import '../../const/app_colors.dart';
import '../../utils/textstyle_utils.dart';

class YoutubePlayerView extends StatelessWidget {
  final String url;
  final int maxVolumeMb;
  const YoutubePlayerView({Key? key, required this.url, required this.maxVolumeMb}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<YoutubePlayerGetxController>(
      init: YoutubePlayerGetxController(url: url, maxVolumeMb: maxVolumeMb),
      builder: (controller) {
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
                AnimatedDataBar(
                  usedMb: controller.usedData ~/ 1024,
                  maxMb: controller.maxVolumeMb,
                ),
                const SizedBox(height: 16),
                Text(
                  'Anlık Download: ${controller.currentSpeed.downloadSpeed} KB/s',
                  style: TextStyleUtils.blackColorRegularText(16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Animasyonlu veri kullanımı barı widget'ı
class AnimatedDataBar extends StatelessWidget {
  final int usedMb;
  final int maxMb;
  const AnimatedDataBar({required this.usedMb, required this.maxMb, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (maxMb == 0) ? 0.0 : (1.0 - (usedMb / maxMb).clamp(0.0, 1.0));
    return Container(
      width: double.infinity,
      height: 28,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.greyBar,
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: percent * MediaQuery.of(context).size.width,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.green,
            ),
          ),
          Center(
            child: Text(
              '${(maxMb - usedMb).clamp(0, maxMb)} MB kalan',
              style: TextStyleUtils.blackColorMediumText(14),
            ),
          ),
        ],
      ),
    );
  }
}
