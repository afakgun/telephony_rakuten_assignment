import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

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
              '${(maxMb - usedMb).clamp(0, maxMb)} ${'mb_left'.tr}',
              style: TextStyleUtils.blackColorMediumText(14),
            ),
          ),
        ],
      ),
    );
  }
}
