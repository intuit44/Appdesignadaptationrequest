import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../widgets/custom_outlined_button.dart';
import '../models/pricing_one_item_model.dart';

// ignore_for_file: must_be_immutable
class PricingOneItemWidget extends StatelessWidget {
  PricingOneItemWidget(this.pricingOneItemModelObj, {Key? key})
      : super(key: key);

  PricingOneItemModel pricingOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgPriceTag1,
            height: 34.h,
            width: 36.h,
          ),
          SizedBox(height: 8.h),
          Text(
            pricingOneItemModelObj.basicpackOne!,
            style: CustomTextStyles.titleLargeGray9000120,
          ),
          SizedBox(height: 6.h),
          SizedBox(width: double.maxFinite, child: Divider()),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgApprove24Outline,
                        height: 24.h,
                        width: 24.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            pricingOneItemModelObj.hdvideo!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgApprove24Outline,
                        height: 24.h,
                        width: 24.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            pricingOneItemModelObj.officialexam!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgApprove24Outline,
                        height: 24.h,
                        width: 24.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            pricingOneItemModelObj.practice!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgApprove24Outline,
                        height: 24.h,
                        width: 24.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            pricingOneItemModelObj.duration!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgApprove24Outline,
                        height: 24.h,
                        width: 24.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            pricingOneItemModelObj.freebook!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                Opacity(
                  opacity: 0.7,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgClose24Outline,
                        height: 24.h,
                        width: 24.h,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.h),
                          child: Text(
                            pricingOneItemModelObj.practicequizes!,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Opacity(
                    opacity: 0.7,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgClose24Outline,
                          height: 24.h,
                          width: 24.h,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.h),
                            child: Text(
                              pricingOneItemModelObj.indepth!,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Opacity(
                    opacity: 0.7,
                    child: Row(
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.imgClose24Outline,
                          height: 24.h,
                          width: 24.h,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.h),
                            child: Text(
                              pricingOneItemModelObj.personal!,
                              style: theme.textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "lbl2".tr,
                  style: CustomTextStyles.titleLargeGray90001,
                ),
                TextSpan(
                  text: "lbl_2002".tr,
                  style: CustomTextStyles.headlineLargeGray90001,
                ),
              ],
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 12.h),
          _buildBasicPackPurchaseButton(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildBasicPackPurchaseButton(BuildContext context) {
    return CustomOutlinedButton(text: "lbl_purchase_course".tr);
  }
}
