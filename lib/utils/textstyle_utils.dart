import 'package:flutter/material.dart';
import '../const/font_family_const.dart';
import '../../const/app_colors.dart';

class TextStyleUtils {
  static TextStyle blackColorLightText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle generalColorPoppinsLightText(double fontSize, Color color, {bool isItalic = false}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontSize, color: color, fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);
  }

  static TextStyle blackColorMediumText(double fontsize, {double? height}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, height: height ?? 1.2, color: AppColors.textDark);
  }

  static TextStyle blackColorMediumItalicText(double fontsize, {double? height}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, height: height ?? 1.2, fontStyle: FontStyle.italic, color: AppColors.textDark);
  }

  static TextStyle disableGreyColorMediumItalicText(
    double fontsize,
  ) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, fontStyle: FontStyle.italic, color: AppColors.greyBar);
  }

  static TextStyle blackColorRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle blackColorUnderlineMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.textDark, decoration: TextDecoration.underline, decorationThickness: 2);
  }

  static TextStyle blackTextColorSemiBoldText(double fontsize, {double? height}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, height: height ?? 1, fontSize: fontsize, wordSpacing: 2, color: AppColors.textDark);
  }

  static TextStyle whiteTextColorSemiBoldText(double fontsize, {double? height}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, height: height ?? 1, fontSize: fontsize, wordSpacing: 2, color: AppColors.textLight);
  }

  static TextStyle lightGreyTextColorSemiBoldText(double fontsize, {double? height}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, height: height ?? 1, fontSize: fontsize, wordSpacing: 2, color: AppColors.greyBar);
  }

  static TextStyle blackColorBoldText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyBold, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle whiteColorMediumText(double fontsize, {double? height}) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, height: height ?? 1.2, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle whiteColorLightText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle whiteColorRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle whiteColorBoldText(double fontsize, List<Shadow>? shadow) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyBold, fontSize: fontsize, color: AppColors.textLight, shadows: shadow);
  }

  static TextStyle lightGreyColorRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: const Color.fromARGB(255, 185, 185, 185));
  }

  static TextStyle redColorMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.error);
  }

  static TextStyle redColorBoldText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyBold,
      fontSize: fontsize,
      color: AppColors.error,
    );
  }

  static TextStyle redColorRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.error);
  }

  static TextStyle redColorUnderlineMediumText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyMedium,
      fontSize: fontsize,
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      decorationThickness: 1,
    );
  }

  static TextStyle hintTextColorMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.greyBar);
  }

  static TextStyle lightGreyColorMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.greyBar);
  }

  static TextStyle darkGreyColorSemiboldText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle darkGreyColorRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle darkGreyBoldColorText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyBold,
      fontSize: fontsize,
      color: AppColors.textDark,
    );
  }

  static TextStyle darkGreyMediumColorText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyMedium,
      fontSize: fontsize,
      color: AppColors.textDark,
    );
  }

  static TextStyle pinkColorRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.warning);
  }

  static TextStyle generalArboriaThinColorText(double fontsize, Color? color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: AppColors.textDark, decorationThickness: 1, letterSpacing: 0.7);
  }

  static TextStyle generalArboriaRegularColorText(double fontsize, Color? color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: color ?? AppColors.textDark, decorationThickness: 1, letterSpacing: 0.7);
  }

  static TextStyle generalArboriaMediumColorText(double fontsize, Color? color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: color ?? Colors.black);
  }

  static TextStyle generalArboriaRegularText(double fontsize, Color? color) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyRegular,
      fontSize: fontsize,
      color: color,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle generalArboriaLightColorText(double fontsize, Color? color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: color ?? AppColors.textDark, decorationThickness: 1, letterSpacing: 0.7);
  }

  static TextStyle generalUnderlineArboriaLightColorText(double fontsize, Color? color) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyLight,
      fontSize: fontsize,
      color: color ?? AppColors.textDark,
      decorationThickness: 1,
      letterSpacing: 0.7,
      decoration: TextDecoration.underline,
      decorationColor: color,
    );
  }

  static TextStyle darkGreyArboriaBookText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyRegular,
      fontWeight: FontWeight.w500,
      fontSize: fontsize,
      color: AppColors.textDark,
    );
  }

  static TextStyle blackArboriaBookText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyRegular,
      fontSize: fontsize,
      color: AppColors.textDark,
    );
  }

  static TextStyle redArboriaBookText(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyRegular,
      fontSize: fontsize,
      color: AppColors.error,
    );
  }

  static TextStyle whiteArboriaBookMedium(double fontsize) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyMedium,
      fontSize: fontsize,
      color: AppColors.textLight,
    );
  }

  static TextStyle generalColorArboriaBookMedium(double fontsize, Color color) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyMedium,
      fontSize: fontsize,
      color: color,
    );
  }

  static TextStyle generalColorArboriaBookBold(double fontsize, Color color) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroyBold,
      fontSize: fontsize,
      color: color,
    );
  }

  static TextStyle negativeRedColorMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.error);
  }

  static TextStyle positiveGreenColorMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.green);
  }

  static TextStyle generalPoppinsMediumText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: color);
  }

  static TextStyle generalPoppinsLightText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: color);
  }

  static TextStyle generalPoppinsRegularText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: color);
  }

  static TextStyle generalPoppinsSemiBoldText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, fontSize: fontsize, color: color);
  }

  static TextStyle generalPoppinsUnderLineSemiBoldText(double fontsize, Color color) {
    return TextStyle(
      fontFamily: FontFamilyConst.gilroySemiBold,
      fontSize: fontsize,
      color: color,
      decoration: TextDecoration.underline,
      decorationColor: color,
      decorationThickness: 1,
    );
  }

  static TextStyle generalPoppinsBoldText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyBold, fontSize: fontsize, color: color);
  }

  static TextStyle whiteUrbanistSemiboldText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle whiteUrbanistRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle whiteUrbanistBoldText(double fontsize, bool underLine, {bool? haveShadow}) {
    return TextStyle(
        fontFamily: FontFamilyConst.gilroyBold,
        fontSize: fontsize,
        decoration: underLine ? TextDecoration.underline : null,
        shadows: haveShadow != null
            ? <Shadow>[
                const Shadow(
                  offset: Offset(1.0, 2.0),
                  blurRadius: 2.0,
                  color: Color.fromARGB(255, 86, 85, 85),
                ),
                const Shadow(
                  offset: Offset(1.0, 1.0),
                  blurRadius: 2.0,
                  color: Color.fromARGB(255, 71, 71, 71),
                ),
              ]
            : null,
        color: AppColors.textLight);
  }

  static TextStyle whiteUrbanistLightText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle whiteUrbanistMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.textLight);
  }

  static TextStyle lightGreyUrbanistMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.greyBar);
  }

  static TextStyle blackUrbanistSemiboldText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle blackUrbanistRegularText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle blackUrbanistBoldText(double fontsize, bool underLine) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyBold, fontSize: fontsize, decoration: underLine ? TextDecoration.underline : null, color: AppColors.textDark);
  }

  static TextStyle blackUrbanistLightText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyLight, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle blackUrbanistMediumText(double fontsize) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: AppColors.textDark);
  }

  static TextStyle generalGilroyMediumText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyMedium, fontSize: fontsize, color: color);
  }

  static TextStyle generalGilroyRegularText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyRegular, fontSize: fontsize, color: color);
  }

  static TextStyle generalGilroySemiBoldText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroySemiBold, fontSize: fontsize, color: color);
  }

  static TextStyle generalGilroyBoldText(double fontsize, Color color) {
    return TextStyle(fontFamily: FontFamilyConst.gilroyBold, fontSize: fontsize, color: color);
  }
}
