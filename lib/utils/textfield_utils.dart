import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

class TextFieldUtils {
  static Widget cardTextField({
    TextEditingController? controller,
    String? hintText,
    Color backgroundColor = Colors.white,
    Color textColor = AppColors.primary,
    Color borderColor = AppColors.primary,
    double borderRadius = 12,
    double verticalPadding = 14,
    double horizontalPadding = 16,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    bool enabled = true,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyleUtils.generalGilroyRegularText(fontSize, textColor),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ),
          hintText: hintText,
          hintStyle: TextStyleUtils.generalGilroyRegularText(fontSize, textColor.withOpacity(0.5)),
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
