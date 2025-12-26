import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillBlack => ElevatedButton.styleFrom(
        backgroundColor: appTheme.black90001,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.h)),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillWhiteA => ElevatedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.h)),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  static ButtonStyle get fillWhiteATL8 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.h)),
        elevation: 0,
        padding: EdgeInsets.zero,
      );
  // Outline button style
  static ButtonStyle get outlineGray => OutlinedButton.styleFrom(
        backgroundColor: appTheme.whiteA700,
        side: BorderSide(color: appTheme.gray300, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.h)),
        padding: EdgeInsets.zero,
      );
  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
        elevation: WidgetStateProperty.all<double>(0),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        side: WidgetStateProperty.all<BorderSide>(
          BorderSide(color: Colors.transparent),
        ),
      );
}
