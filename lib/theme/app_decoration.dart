import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlack => BoxDecoration(color: appTheme.black900);
  static BoxDecoration get fillGray => BoxDecoration(color: appTheme.gray100);
  static BoxDecoration get fillGray10001 =>
      BoxDecoration(color: appTheme.gray10001);
  static BoxDecoration get fillGray200 =>
      BoxDecoration(color: appTheme.gray200);
  static BoxDecoration get fillRed => BoxDecoration(color: appTheme.red5002);
  static BoxDecoration get fillWhiteA =>
      BoxDecoration(color: appTheme.whiteA700);
  static BoxDecoration get fillWhiteA700 =>
      BoxDecoration(color: appTheme.whiteA700.withOpacity(0.53));
  static BoxDecoration get fillYellow =>
      BoxDecoration(color: appTheme.yellow100);
  // Gradient decorations
  static BoxDecoration get gradientOrangeToOrange => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(0.5, 0.14),
      end: Alignment(0.5, 1),
      colors: [appTheme.orange20000, appTheme.orange20001],
    ),
  );
  // Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black90001.withOpacity(0.05),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 50),
      ),
    ],
  );
  static BoxDecoration get outlineBlack90001 => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black90001.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 50),
      ),
    ],
  );
  static BoxDecoration get outlineBlack900011 => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black90001.withOpacity(0.05),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 50),
      ),
    ],
  );
  static BoxDecoration get outlineBlack900012 => BoxDecoration(
    color: appTheme.whiteA700,
    boxShadow: [
      BoxShadow(
        color: appTheme.black90001.withOpacity(0.1),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 50),
      ),
    ],
  );
  static BoxDecoration get outlineBlack900013 => BoxDecoration(
    color: appTheme.indigo50,
    boxShadow: [
      BoxShadow(
        color: appTheme.black90001.withOpacity(0.05),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 50),
      ),
    ],
  );
  static BoxDecoration get outlineDeepPurpleA => BoxDecoration(
    color: appTheme.whiteA700,
    border: Border(top: BorderSide(color: appTheme.deepPurpleA200, width: 1.h)),
  );
}

class BorderRadiusStyle {
  // Custom borders
  static BorderRadius get customBorderBL10 =>
      BorderRadius.vertical(bottom: Radius.circular(10.h));
  static BorderRadius get customBorderTL10 =>
      BorderRadius.vertical(top: Radius.circular(10.h));
  static BorderRadius get customBorderTL58 => BorderRadius.only(
    topLeft: Radius.circular(58.h),
    topRight: Radius.circular(18.h),
    bottomLeft: Radius.circular(30.h),
    bottomRight: Radius.circular(30.h),
  );
  // Rounded borders
  static BorderRadius get roundedBorder10 => BorderRadius.circular(10.h);
  static BorderRadius get roundedBorder14 => BorderRadius.circular(14.h);
  static BorderRadius get roundedBorder20 => BorderRadius.circular(20.h);
  static BorderRadius get roundedBorder5 => BorderRadius.circular(5.h);
}
