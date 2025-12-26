import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../models/list_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ListOneItemWidget extends StatelessWidget {
  ListOneItemWidget(this.listOneItemModelObj, {Key? key}) : super(key: key);

  ListOneItemModel listOneItemModelObj;

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
            imagePath: listOneItemModelObj.image!,
            height: 86.h,
            width: 76.h,
            radius: BorderRadius.circular(5.h),
          ),
          SizedBox(width: 14.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomRatingBar(ignoreGestures: true, initialRating: 5),
                SizedBox(height: 6.h),
                Text(
                  listOneItemModelObj.thethree!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: CustomTextStyles.titleMediumBlack90001SemiBold_1
                      .copyWith(height: 1.25),
                ),
                SizedBox(height: 6.h),
                Text(
                  listOneItemModelObj.price!,
                  style: CustomTextStyles.titleMediumPrimarySemiBold_1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
