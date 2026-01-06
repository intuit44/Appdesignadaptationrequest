import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/listthethree_item_model.dart';
import 'models/standardslist_item_model.dart';
import 'notifier/fibro_shop_notifier.dart';
import 'widgets/listthethree_item_widget.dart';
import 'widgets/standardslist_item_widget.dart';

class ScrollviewOneTab2Page extends ConsumerStatefulWidget {
  const ScrollviewOneTab2Page({super.key});

  @override
  ScrollviewOneTab2PageState createState() => ScrollviewOneTab2PageState();
}

class ScrollviewOneTab2PageState extends ConsumerState<ScrollviewOneTab2Page> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 30.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                children: [
                  _buildStandardsList(context),
                  SizedBox(height: 70.h),
                  _buildPopularBooksSection(context),
                  SizedBox(height: 70.h),
                  _buildSubscribeSection(context),
                ],
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStandardsList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.h),
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 14.h);
            },
            itemCount: ref
                    .watch(fibroShopNotifier)
                    .scrollviewOneTab2ModelObj
                    ?.standardslistItemList
                    .length ??
                0,
            itemBuilder: (context, index) {
              StandardslistItemModel model = ref
                      .watch(fibroShopNotifier)
                      .scrollviewOneTab2ModelObj
                      ?.standardslistItemList[index] ??
                  StandardslistItemModel();
              return StandardslistItemWidget(model);
            },
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPopularBooksSection(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_popular_books".tr,
            style: CustomTextStyles.headlineSmallBlack9000124,
          ),
          SizedBox(height: 12.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomSearchView(
                controller: ref.watch(fibroShopNotifier).searchController,
                hintText: "msg_serach_class_course".tr,
                contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
              );
            },
          ),
          SizedBox(height: 20.h),
          Consumer(
            builder: (context, ref, _) {
              return CustomDropDown(
                icon: Container(
                  margin: EdgeInsets.only(left: 16.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgArrowdown,
                    height: 22.h,
                    width: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
                iconSize: 22.h,
                hintText: "lbl_sort_by_latest".tr,
                items: ref
                        .watch(fibroShopNotifier)
                        .scrollviewOneTab2ModelObj
                        ?.dropdownItemList ??
                    [],
                contentPadding: EdgeInsets.fromLTRB(16.h, 12.h, 10.h, 12.h),
              );
            },
          ),
          SizedBox(height: 20.h),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
                itemCount: ref
                        .watch(fibroShopNotifier)
                        .scrollviewOneTab2ModelObj
                        ?.listthethreeItemList
                        .length ??
                    0,
                itemBuilder: (context, index) {
                  ListthethreeItemModel model = ref
                          .watch(fibroShopNotifier)
                          .scrollviewOneTab2ModelObj
                          ?.listthethreeItemList[index] ??
                      ListthethreeItemModel();
                  return ListthethreeItemWidget(model);
                },
              );
            },
          ),
          SizedBox(height: 20.h),
          Text("lbl_see_more".tr, style: CustomTextStyles.titleMediumPrimary),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildSubscribeEmailInput(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return CustomTextFormField(
          controller:
              ref.watch(fibroShopNotifier).subscribeEmailInputController,
          hintText: "msg_enter_your_email".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.emailAddress,
          contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
          validator: (value) {
            if (value == null || (!isValidEmail(value, isRequired: true))) {
              return "err_msg_please_enter_valid_email".tr;
            }
            return null;
          },
        );
      },
    );
  }

  /// Section Widget
  Widget _buildSubscribeButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl_subscribe".tr,
      buttonTextStyle: theme.textTheme.titleSmall!,
    );
  }

  /// Section Widget
  Widget _buildSubscribeSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 34.h),
      decoration: BoxDecoration(
        color: appTheme.black900,
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "msg_subscribe_for_get".tr,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium!.copyWith(height: 1.36),
          ),
          SizedBox(height: 8.h),
          Text(
            "msg_20k_students_daily".tr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: CustomTextStyles.bodyLargeWhiteA700.copyWith(height: 1.50),
          ),
          SizedBox(height: 28.h),
          _buildSubscribeEmailInput(context),
          SizedBox(height: 20.h),
          _buildSubscribeButton(context),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCoursesColumn(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl_courses".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text("msg_classroom_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("msg_virtual_classroom".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("msg_e_learning_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_video_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_offline_courses".tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildFooter(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 46.h),
      decoration: BoxDecoration(color: appTheme.gray100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 6.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup7623,
                  height: 30.h,
                  width: 30.h,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.h),
                      child: Text(
                        "lbl_educatsy".tr,
                        style: theme.textTheme.headlineLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgFacebook,
                  height: 22.h,
                  width: 22.h,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgUserDeepOrange400,
                  height: 36.h,
                  width: 36.h,
                  margin: EdgeInsets.only(left: 14.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgTwitterLogo,
                  height: 16.h,
                  width: 22.h,
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(left: 14.h, top: 8.h),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgLinkedinIcon,
                  height: 18.h,
                  width: 22.h,
                  margin: EdgeInsets.only(left: 14.h),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Text("lbl_2021_educatsy".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 18.h),
          Text(
            "msg_educatsy_is_a_registered".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 58.h),
          Text("lbl_community".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text("lbl_learners".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_parteners".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_developers".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_transactions".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_blog".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_teaching_center".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 24.h),
          _buildCoursesColumn(context),
          SizedBox(height: 28.h),
          Text("lbl_quick_links".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 18.h),
          Text("lbl_home".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text(
            "msg_professional_education".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 16.h),
          Text("lbl_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_admissions".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_testimonial".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_programs".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 24.h),
          Text("lbl_more".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 18.h),
          Text("lbl_press".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_investors".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_terms".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_privacy".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_help".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 14.h),
          Text("lbl_contact".tr, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
