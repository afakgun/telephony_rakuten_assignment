import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/presentation/home/controller/home_controller.dart';
import 'package:telephony_rakuten_assignment/utils/textfield_utils.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

class YoutubeCard extends StatelessWidget {
  const YoutubeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('youtube_card_title'.tr, style: TextStyleUtils.blackColorBoldText(15)),
                  const SizedBox(height: 4),
                  Text('youtube_card_desc'.tr, style: TextStyleUtils.blackColorRegularText(13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFieldUtils.cardTextField(
                          controller: controller.youtubeUrlController,
                          hintText: 'Youtube URL',
                          keyboardType: TextInputType.url,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 80,
                        child: TextFieldUtils.cardTextField(
                          controller: controller.youtubeVolumeController,
                          hintText: 'MB',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Align(
              child: GestureDetector(
                onTap: () {
                  controller.startYoutubeStreaming(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
