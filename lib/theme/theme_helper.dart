import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.

// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors(),
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme,
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.gray100,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(color: colorScheme.primary, width: 1.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.h),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(width: 1),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray90001.withValues(alpha: 0.15),
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.gray700,
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.gray90001,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: appTheme.black90001,
          fontSize: 30.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 28.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: appTheme.gray90001,
          fontSize: 25.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: appTheme.black90001,
          fontSize: 22.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: appTheme.gray700,
          fontSize: 16.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0XFFD97356),
    secondaryContainer: Color(0XFF828282),
    onPrimary: Color(0XFF232323),
    onPrimaryContainer: Color(0XFFFFBE9D),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Amber
  Color get amber200 => Color(0XFFFFDF7F);
  Color get amber400 => Color(0XFFF0C419);
  Color get amber500 => Color(0XFFFFC107);
  // Black
  Color get black900 => Color(0XFF170600);
  Color get black90001 => Color(0XFF000000);
  // Blue
  Color get blue300 => Color(0XFF699DEE);
  Color get blue50 => Color(0XFFE9F3FE);
  Color get blue500 => Color(0XFF1D9CFD);
  Color get blueA100 => Color(0XFF73A1FB);
  // BlueGray
  Color get blueGray100 => Color(0XFFD6CED7);
  Color get blueGray10001 => Color(0XFFD7D7D7);
  Color get blueGray50 => Color(0XFFECECF1);
  Color get blueGray5001 => Color(0XFFEBF2F9);
  Color get blueGray600 => Color(0XFF516373);
  Color get blueGray700 => Color(0XFF455A64);
  Color get blueGray800 => Color(0XFF3E4D59);
  Color get blueGray80001 => Color(0XFF3E4756);
  Color get blueGray900 => Color(0XFF283250);
  Color get blueGray90001 => Color(0XFF3D302A);
  Color get blueGray90002 => Color(0XFF2D2442);
  Color get blueGray90003 => Color(0XFF263238);
  // Cyan
  Color get cyan50 => Color(0XFFE5FFF2);
  Color get cyanA100 => Color(0XFF80EEFF);
  Color get cyanA400 => Color(0XFF0FDBFF);
  // DeepOrange
  Color get deepOrange100 => Color(0XFFF9BCAA);
  Color get deepOrange10001 => Color(0XFFFFCFBE);
  Color get deepOrange300 => Color(0XFFEB996E);
  Color get deepOrange30001 => Color(0XFFFE8E68);
  Color get deepOrange400 => Color(0XFFFF6652);
  Color get deepOrange40001 => Color(0XFFE58638);
  Color get deepOrange500 => Color(0XFFFF6529);
  Color get deepOrange800 => Color(0XFFDB380E);
  Color get deepOrange80001 => Color(0XFFC95C12);
  Color get deepOrangeA100 => Color(0XFFFCA56B);
  Color get deepOrangeA10001 => Color(0XFFFFB27D);
  Color get deepOrangeA700 => Color(0XFFE53B07);
  // DeepPurple
  Color get deepPurple400 => Color(0XFF8334DB);
  Color get deepPurple50 => Color(0XFFECDBFF);
  Color get deepPurpleA200 => Color(0XFF9C4DF4);
  Color get deepPurpleA20001 => Color(0XFF8434DC);
  // Gray
  Color get gray100 => Color(0XFFF7F7F7);
  Color get gray10001 => Color(0XFFF7F5FA);
  Color get gray10002 => Color(0XFFF5F5F5);
  Color get gray10003 => Color(0XFFEFF6FE);
  Color get gray200 => Color(0XFFECECEC);
  Color get gray20001 => Color(0XFFEBEBEB);
  Color get gray300 => Color(0XFFDEDDE4);
  Color get gray30001 => Color(0XFFE0E0E0);
  Color get gray400 => Color(0XFFDBC4BD);
  Color get gray40001 => Color(0XFFC1ADA4);
  Color get gray50 => Color(0XFFF8F2FF);
  Color get gray500 => Color(0XFF9B8580);
  Color get gray50001 => Color(0XFFA1A1A1);
  Color get gray5001 => Color(0XFFF8FFFB);
  Color get gray5002 => Color(0XFFF9F9F9);
  Color get gray5003 => Color(0XFFFAFAFA);
  Color get gray600 => Color(0XFF818181);
  Color get gray700 => Color(0XFF5D5A6F);
  Color get gray70001 => Color(0XFF636363);
  Color get gray70002 => Color(0XFF5A4F72);
  Color get gray800 => Color(0XFF594C4A);
  Color get gray80001 => Color(0XFF434343);
  Color get gray80002 => Color(0XFF433735);
  Color get gray80003 => Color(0XFF424242);
  Color get gray900 => Color(0XFF0B033C);
  Color get gray90001 => Color(0XFF0A033C);
  // Green
  Color get green200 => Color(0XFFA8D29F);
  Color get green300 => Color(0XFF82B378);
  Color get green700 => Color(0XFF1B9E28);
  // Indigo
  Color get indigo400 => Color(0XFF4A75CB);
  Color get indigo50 => Color(0XFFEBEAF4);
  Color get indigo800 => Color(0XFF1C468A);
  Color get indigo900 => Color(0XFF163560);
  // LightBlue
  Color get lightBlue100 => Color(0XFFC2F7FF);
  Color get lightBlueA200 => Color(0XFF3AB4FB);
  // Lime
  Color get lime900 => Color(0XFF874C2E);
  // Orange
  Color get orange200 => Color(0XFFFFB973);
  Color get orange20000 => Color(0X00EABC7A);
  Color get orange20001 => Color(0XFFE6B879);
  Color get orange20002 => Color(0XFFEEBC74);
  Color get orange300 => Color(0XFFFFB54A);
  Color get orange600 => Color(0XFFF9880D);
  Color get orangeA200 => Color(0XFFEE9849);
  // Pink
  Color get pink200 => Color(0XFFEFA5B6);
  // Red
  Color get red100 => Color(0XFFEED9CE);
  Color get red300 => Color(0XFFBC744A);
  Color get red400 => Color(0XFFCC6144);
  Color get red50 => Color(0XFFFFF0EC);
  Color get red500 => Color(0XFFFF3333);
  Color get red5001 => Color(0XFFFFF3F2);
  Color get red5002 => Color(0XFFFFEEE9);
  Color get red600 => Color(0XFFE54935);
  Color get red60001 => Color(0XFFE04D3A);
  Color get red60002 => Color(0XFFE93E30);
  Color get redA100 => Color(0XFFFF7579);
  Color get redA200 => Color(0XFFFE4A60);
  Color get redA700 => Color(0XFFC60000);
  // Teal
  Color get teal50 => Color(0XFFD9E4EF);
  Color get tealA400 => Color(0XFF07E5CA);
  Color get tealA700 => Color(0XFF00B59B);
  // White
  Color get whiteA700 => Color(0XFFFFFFFF);
  // Yellow
  Color get yellow100 => Color(0XFFFFF2CE);
  Color get yellow700 => Color(0XFFFFB826);
}
