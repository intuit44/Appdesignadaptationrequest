import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(fontFamily: 'Inter');
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargeWhiteA700 => theme.textTheme.bodyLarge!
      .copyWith(color: appTheme.whiteA700.withOpacity(0.7));
  // Headline text style
  static TextStyle get headlineLargeBold => theme.textTheme.headlineLarge!
      .copyWith(fontSize: 32.fSize, fontWeight: FontWeight.w700);
  static TextStyle get headlineLargeGray90001 =>
      theme.textTheme.headlineLarge!.copyWith(color: appTheme.gray90001);
  static TextStyle get headlineLargeGray90001_1 =>
      theme.textTheme.headlineLarge!.copyWith(color: appTheme.gray90001);
  static TextStyle get headlineMediumBlack90001 =>
      theme.textTheme.headlineMedium!.copyWith(color: appTheme.black90001);
  static TextStyle get headlineMediumGray90001 =>
      theme.textTheme.headlineMedium!.copyWith(color: appTheme.gray90001);
  static TextStyle get headlineSmall24 =>
      theme.textTheme.headlineSmall!.copyWith(fontSize: 24.fSize);
  static TextStyle get headlineSmallBlack90001 =>
      theme.textTheme.headlineSmall!.copyWith(color: appTheme.black90001);
  static TextStyle get headlineSmallBlack9000124 => theme
      .textTheme
      .headlineSmall!
      .copyWith(color: appTheme.black90001, fontSize: 24.fSize);
  static TextStyle get headlineSmallMedium => theme.textTheme.headlineSmall!
      .copyWith(fontSize: 24.fSize, fontWeight: FontWeight.w500);
  // Title text style
  static TextStyle get titleLarge20 =>
      theme.textTheme.titleLarge!.copyWith(fontSize: 20.fSize);
  static TextStyle get titleLargeGray90001 => theme.textTheme.titleLarge!
      .copyWith(color: appTheme.gray90001, fontSize: 20.fSize);
  static TextStyle get titleLargeGray9000120 => theme.textTheme.titleLarge!
      .copyWith(color: appTheme.gray90001, fontSize: 20.fSize);
  static TextStyle get titleLargePrimary => theme.textTheme.titleLarge!
      .copyWith(color: theme.colorScheme.primary, fontSize: 20.fSize);
  static TextStyle get titleMediumBlack90001 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.black90001);
  static TextStyle get titleMediumBlack90001SemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.black90001,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumBlack90001SemiBold_1 => theme
      .textTheme
      .titleMedium!
      .copyWith(color: appTheme.black90001, fontWeight: FontWeight.w600);
  static TextStyle get titleMediumBlack90001_1 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.black90001);
  static TextStyle get titleMediumBlack90001_2 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.black90001);
  static TextStyle get titleMediumBluegray80001 => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.blueGray80001, fontSize: 18.fSize);
  static TextStyle get titleMediumDeeporange400 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.deepOrange400);
  static TextStyle get titleMediumDeeppurpleA200 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.deepPurpleA200);
  static TextStyle get titleMediumGray700 => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.gray700.withOpacity(0.6));
  static TextStyle get titleMediumGray90001 => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.gray90001, fontWeight: FontWeight.w600);
  static TextStyle get titleMediumGray90001SemiBold => theme
      .textTheme
      .titleMedium!
      .copyWith(color: appTheme.gray90001, fontWeight: FontWeight.w600);
  static TextStyle get titleMediumGray90001_1 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.gray90001);
  static TextStyle get titleMediumGray90001_2 => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.gray90001.withOpacity(0.4));
  static TextStyle get titleMediumGray90001_3 => theme.textTheme.titleMedium!
      .copyWith(color: appTheme.gray90001.withOpacity(0.4));
  static TextStyle get titleMediumPrimary =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get titleMediumPrimarySemiBold => theme
      .textTheme
      .titleMedium!
      .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600);
  static TextStyle get titleMediumPrimarySemiBold18 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumPrimarySemiBold_1 => theme
      .textTheme
      .titleMedium!
      .copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600);
  static TextStyle get titleMediumPrimary_1 =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get titleMediumPrimary_2 =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.primary);
  static TextStyle get titleMediumSemiBold =>
      theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600);
  static TextStyle get titleMediumWhiteA700 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.whiteA700);
  static TextStyle get titleSmallBlack90001 => theme.textTheme.titleSmall!
      .copyWith(color: appTheme.black90001, fontWeight: FontWeight.w600);
  static TextStyle get titleSmallBlack90001_1 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.black90001);
  static TextStyle get titleSmallDeeporange400 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.deepOrange400);
  static TextStyle get titleSmallDeeporange400_1 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.deepOrange400);
  static TextStyle get titleSmallGray700 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray700);
  static TextStyle get titleSmallGray700_1 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray700);
  static TextStyle get titleSmallGray900 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray900);
  static TextStyle get titleSmallGray90001 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray90001);
  static TextStyle get titleSmallPrimary =>
      theme.textTheme.titleSmall!.copyWith(color: theme.colorScheme.primary);
}
