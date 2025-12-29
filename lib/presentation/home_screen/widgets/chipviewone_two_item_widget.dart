import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/chipviewone_two_item_model.dart';

// ignore_for_file: must_be_immutable
class ChipviewoneTwoItemWidget extends StatelessWidget {
  ChipviewoneTwoItemWidget(
    this.chipviewoneTwoItemModelObj, {
    super.key,
    this.onSelectedChipView,
  });

  ChipviewoneTwoItemModel chipviewoneTwoItemModelObj;

  Function(bool)? onSelectedChipView;

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.only(top: 12.h, right: 18.h, bottom: 12.h),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        chipviewoneTwoItemModelObj.oneTwo!,
        style: TextStyle(
          color: appTheme.black90001,
          fontSize: 14.fSize,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
      avatar: CustomImageView(
        imagePath: ImageConstant.imgFloatingicon,
        height: 24.h,
        width: 24.h,
        margin: EdgeInsets.only(right: 10.h),
      ),
      selected: (chipviewoneTwoItemModelObj.isSelected ?? false),
      backgroundColor: appTheme.whiteA700,
      selectedColor: theme.colorScheme.primary,
      side: BorderSide.none,
      shape:
          (chipviewoneTwoItemModelObj.isSelected ?? false)
              ? RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(5.h),
              )
              : RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(5.h),
              ),
      onSelected: (value) {
        onSelectedChipView?.call(value);
      },
    );
  }
}
