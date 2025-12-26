import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../models/listthethree_item_model.dart';

// ignore_for_file: must_be_immutable
class ListthethreeItemWidget extends StatelessWidget {
  ListthethreeItemWidget(this.listthethreeItemModelObj, {Key? key})
    : super(key: key);

  ListthethreeItemModel listthethreeItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: listthethreeItemModelObj.image!,
            height: 86.h,
            width: 76.h,
            radius: BorderRadius.circular(5.h),
          ),
          SizedBox(width: 14.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listthethreeItemModelObj.thethree!,
                  style: CustomTextStyles.titleMediumBlack90001SemiBold_1,
                ),
                SizedBox(height: 8.h),
                CustomRatingBar(ignoreGestures: true, initialRating: 5),
                SizedBox(height: 8.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listthethreeItemModelObj.price!,
                        style: CustomTextStyles.titleMediumPrimarySemiBold_1,
                      ),
                      CustomIconButton(
                        height: 34.h,
                        width: 34.h,
                        padding: EdgeInsets.all(6.h),
                        decoration: IconButtonStyleHelper.none,
                        alignment: Alignment.center,
                        child: CustomImageView(
                          imagePath: listthethreeItemModelObj.shoppingbagtwen!,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
