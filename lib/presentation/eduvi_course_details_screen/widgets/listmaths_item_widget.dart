import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listmaths_item_model.dart';

// ignore_for_file: must_be_immutable
class ListmathsItemWidget extends StatelessWidget {
  ListmathsItemWidget(this.listmathsItemModelObj, {Key? key}) : super(key: key);

  ListmathsItemModel listmathsItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: listmathsItemModelObj.image!,
            height: 50.h,
            width: 80.h,
            radius: BorderRadius.circular(5.h),
          ),
          SizedBox(width: 10.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listmathsItemModelObj.maths!,
                  style: CustomTextStyles.titleMediumGray90001SemiBold,
                ),
                SizedBox(height: 4.h),
                Text(
                  listmathsItemModelObj.time!,
                  style: CustomTextStyles.titleSmallDeeporange400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
