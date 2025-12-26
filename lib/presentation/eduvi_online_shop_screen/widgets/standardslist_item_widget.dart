import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../models/standardslist_item_model.dart';

// ignore_for_file: must_be_immutable
class StandardslistItemWidget extends StatelessWidget {
  StandardslistItemWidget(this.standardslistItemModelObj, {Key? key})
      : super(key: key);

  StandardslistItemModel standardslistItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 28.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadiusStyle.roundedBorder14,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageView(
            imagePath: standardslistItemModelObj.standardOne!,
            height: 50.h,
            width: 52.h,
          ),
          SizedBox(height: 18.h),
          Text(
            standardslistItemModelObj.standardone1!,
            style: theme.textTheme.headlineSmall,
          ),
          SizedBox(height: 18.h),
          Text(
            standardslistItemModelObj.standard1isa!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.88),
          ),
          SizedBox(height: 18.h),
          _buildStandardOneDetailsButton(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildStandardOneDetailsButton(BuildContext context) {
    return CustomOutlinedButton(
      height: 44.h,
      text: "lbl_class_details".tr,
      margin: EdgeInsets.symmetric(horizontal: 46.h),
    );
  }
}
