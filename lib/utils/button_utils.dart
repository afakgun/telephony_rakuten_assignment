import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

class ButtonUtils {
  static Widget cardButton({
    String? text,
    required VoidCallback? onTap,
    Color backgroundColor = Colors.white,
    Color textColor = AppColors.primary,
    double borderRadius = 12,
    double verticalPadding = 14,
    double fontSize = 16,
    EdgeInsetsGeometry? margin,
    FontWeight fontWeight = FontWeight.bold,
    Widget? child,
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.5,
        child: Container(
          width: double.infinity,
          margin: margin,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: backgroundColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: child ??
                Text(
                  text ?? '',
                  style: TextStyleUtils.generalGilroyBoldText(fontSize, textColor),
                ),
          ),
        ),
      ),
    );
  }
}
