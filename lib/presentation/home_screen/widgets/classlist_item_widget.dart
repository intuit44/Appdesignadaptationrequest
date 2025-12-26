import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../models/classlist_item_model.dart';

// ignore_for_file: must_be_immutable
class ClasslistItemWidget extends StatelessWidget {
  ClasslistItemWidget(this.classlistItemModelObj, {Key? key}) : super(key: key);

  ClasslistItemModel classlistItemModelObj;

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
            imagePath: classlistItemModelObj.standardOne!,
            height: 50.h,
            width: 52.h,
          ),
          SizedBox(height: 18.h),
          Text(
            classlistItemModelObj.standardone1!,
            style: CustomTextStyles.headlineSmallBlack90001,
          ),
          SizedBox(height: 18.h),
          Text(
            classlistItemModelObj.standard1isa!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.88),
          ),
          SizedBox(height: 18.h),
          _buildClassDetailsButton(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildClassDetailsButton(BuildContext context) {
    return CustomOutlinedButton(
      height: 44.h,
      text: "lbl_class_details".tr,
      margin: EdgeInsets.symmetric(horizontal: 46.h),
    );
  }
}
