import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/mentorslist_item_model.dart';

// ignore_for_file: must_be_immutable
class MentorslistItemWidget extends StatelessWidget {
  MentorslistItemWidget(this.mentorslistItemModelObj, {Key? key})
    : super(key: key);

  MentorslistItemModel mentorslistItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: mentorslistItemModelObj.founderMentor!,
            height: 290.h,
            width: 290.h,
            radius: BorderRadius.circular(10.h),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mentorslistItemModelObj.kristinwatson!,
                  style: CustomTextStyles.titleMediumGray90001_1,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowDownGray90001,
                  height: 24.h,
                  width: 26.h,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            mentorslistItemModelObj.foundermentor1!,
            style: CustomTextStyles.titleSmallGray700_1,
          ),
        ],
      ),
    );
  }
}
