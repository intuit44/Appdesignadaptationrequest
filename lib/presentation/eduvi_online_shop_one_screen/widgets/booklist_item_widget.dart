import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../models/booklist_item_model.dart';

// ignore_for_file: must_be_immutable
class BooklistItemWidget extends StatelessWidget {
  BooklistItemWidget(this.booklistItemModelObj, {Key? key}) : super(key: key);

  BooklistItemModel booklistItemModelObj;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 280.h,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: appTheme.whiteA700,
              borderRadius: BorderRadiusStyle.roundedBorder10,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: booklistItemModelObj.imageOne!,
                  height: 240.h,
                  width: 232.h,
                  radius: BorderRadius.circular(10.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            booklistItemModelObj.thethree!,
            style: CustomTextStyles.titleMediumBlack90001SemiBold,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booklistItemModelObj.price!,
                  style: CustomTextStyles.titleMediumPrimarySemiBold18,
                ),
                CustomRatingBar(
                  ignoreGestures: true,
                  initialRating: 5,
                  itemSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
