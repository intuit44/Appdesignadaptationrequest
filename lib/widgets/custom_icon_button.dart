import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineGray => BoxDecoration(
    color: appTheme.whiteA700,
    borderRadius: BorderRadius.circular(10.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.gray90001.withValues(alpha: 0.15),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 25),
      ),
    ],
  );
  static BoxDecoration get outlineGrayTL5 => BoxDecoration(
    color: appTheme.whiteA700,
    borderRadius: BorderRadius.circular(5.h),
    boxShadow: [
      BoxShadow(
        color: appTheme.gray90001.withValues(alpha: 0.15),
        spreadRadius: 2.h,
        blurRadius: 2.h,
        offset: Offset(0, 25),
      ),
    ],
  );
  static BoxDecoration get fillWhiteA => BoxDecoration(
    color: appTheme.whiteA700,
    borderRadius: BorderRadius.circular(6.h),
  );
  static BoxDecoration get fillRed => BoxDecoration(
    color: appTheme.red50,
    borderRadius: BorderRadius.circular(5.h),
  );
  static BoxDecoration get fillPrimaryTL20 => BoxDecoration(
    color: theme.colorScheme.primary,
    borderRadius: BorderRadius.circular(20.h),
  );
  static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child,
  }) : super(key: key);

  final Alignment? alignment;

  final double? height;

  final double? width;

  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final VoidCallback? onTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
          alignment: alignment ?? Alignment.center,
          child: iconButtonWidget,
        )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
    height: height ?? 0,
    width: width ?? 0,
    child: DecoratedBox(
      decoration:
          decoration ??
          BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(6.h),
          ),
      child: IconButton(
        padding: padding ?? EdgeInsets.zero,
        onPressed: onTap,
        icon: child ?? Container(),
      ),
    ),
  );
}
