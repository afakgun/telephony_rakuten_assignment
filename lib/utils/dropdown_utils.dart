import 'package:flutter/material.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';

class DropdownUtils {
  static Widget cardDropdown<T>({
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    Color backgroundColor = Colors.white,
    Color borderColor = AppColors.primary,
    Color iconColor = AppColors.primary,
    double borderRadius = 12,
    double verticalPadding = 14,
    double horizontalPadding = 16,
    EdgeInsetsGeometry? margin,
    bool enabled = true,
    Widget? hint,
    Widget? icon,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        isExpanded: true,
        icon: icon ?? Icon(Icons.arrow_drop_down, color: iconColor),
        hint: hint,
        dropdownColor: backgroundColor,
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
