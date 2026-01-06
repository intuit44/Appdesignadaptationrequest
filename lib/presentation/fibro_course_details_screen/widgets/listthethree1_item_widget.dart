import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_button.dart';
import '../../../widgets/custom_rating_bar.dart';
import '../models/listthethree1_item_model.dart';

// ignore_for_file: must_be_immutable
class Listthethree1ItemWidget extends StatelessWidget {
  Listthethree1ItemWidget(this.listthethree1ItemModelObj, {super.key});

  Listthethree1ItemModel listthethree1ItemModelObj;

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
            imagePath: ImageConstant.imgImage14,
            height: 86.h,
            width: 76.h,
            radius: BorderRadius.circular(5.h),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 14.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listthethree1ItemModelObj.thethree!,
                          style: CustomTextStyles.titleMediumGray90001SemiBold,
                        ),
                        SizedBox(height: 8.h),
                        CustomRatingBar(ignoreGestures: true, initialRating: 5),
                        SizedBox(height: 8.h),
                        Text(
                          listthethree1ItemModelObj.price!,
                          style: CustomTextStyles.titleMediumPrimarySemiBold_1,
                        ),
                      ],
                    ),
                  ),
                ),
                CustomIconButton(
                  height: 34.h,
                  width: 34.h,
                  padding: EdgeInsets.all(6.h),
                  decoration: IconButtonStyleHelper.none,
                  alignment: Alignment.bottomCenter,
                  child: CustomImageView(
                    imagePath: ImageConstant.imgShoppingBag24,
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
