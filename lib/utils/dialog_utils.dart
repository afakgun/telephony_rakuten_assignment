import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:telephony_rakuten_assignment/const/app_colors.dart';
import 'package:telephony_rakuten_assignment/utils/textstyle_utils.dart';

class AppDialogUtils {
  static showOnlyContentDialog({
    String? iconData,
    String? title,
    required String message,
    required String buttonLeftText,
    required String buttonRightText,
    required Function()? buttonLeftAction,
    required Function()? buttonRightAction,
    bool iconVisible = true,
    Color? iconBackgroundColor,
    Color? iconColor,
    bool? isDismissable,
    bool showCloseIcon = false,
  }) {
    return Get.dialog(
      barrierColor: Colors.black.withAlpha((255 * 0.3).toInt()),
      Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: Get.width * .85,
            minWidth: Get.width * .8,
            maxHeight: Get.height * 0.7,
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconVisible)
                  Container(
                    padding: EdgeInsets.all(15),
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor?.withOpacity(0.1) ?? AppColors.primary),
                    child: iconData != null
                        ? SvgPicture.asset(iconData)
                        : Icon(
                            Icons.notifications_outlined,
                            color: iconColor ?? Colors.white,
                            size: 30,
                          ),
                  ),
                if (title != null && title.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: TextStyleUtils.blackTextColorSemiBoldText(16),
                      child: Text(title),
                    ),
                  ),
                if (message.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: TextStyleUtils.lightGreyColorRegularText(14),
                      child: Text(message),
                    ),
                  ),
                if (buttonLeftAction != null || buttonRightAction != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (buttonLeftAction != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: buttonLeftAction,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(color: AppColors.primary, width: 1.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              buttonLeftText,
                              style: TextStyleUtils.generalGilroyMediumText(14, AppColors.primary),
                            ),
                          ),
                        ),
                      if (buttonLeftAction != null && buttonRightAction != null) SizedBox(width: 15),
                      if (buttonRightAction != null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: buttonRightAction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 12),
                              elevation: 2,
                            ),
                            child: Text(
                              buttonRightText,
                              style: TextStyleUtils.whiteColorMediumText(14),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      useSafeArea: true,
      barrierDismissible: isDismissable ?? true,
    );
  }

  static void showSuccessDialog(String message) {
    print("Success: $message");
  }
}
