import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_rating_bar.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/booklist_item_model.dart';
import 'models/list_item_model.dart';
import 'models/list_one_item_model.dart';
import 'notifier/eduvi_online_shop_one_notifier.dart';
import 'widgets/booklist_item_widget.dart';
import 'widgets/list_item_widget.dart';
import 'widgets/list_one_item_widget.dart';

class ScrollviewOneTab1Page extends ConsumerStatefulWidget {
  const ScrollviewOneTab1Page({Key? key}) : super(key: key);

  @override
  ScrollviewOneTab1PageState createState() => ScrollviewOneTab1PageState();
}

class ScrollviewOneTab1PageState extends ConsumerState<ScrollviewOneTab1Page> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      child: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 20.h),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      return CustomSearchView(
                        controller: ref
                            .watch(eduviOnlineShopOneNotifier)
                            .searchController,
                        hintText: "msg_serach_class_course".tr,
                        contentPadding: EdgeInsets.fromLTRB(
                          16.h,
                          12.h,
                          10.h,
                          12.h,
                        ),
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
                                .watch(eduviOnlineShopOneNotifier)
                                .scrollviewOneTab1ModelObj
                                ?.dropdownItemList ??
                            [],
                        contentPadding: EdgeInsets.fromLTRB(
                          16.h,
                          12.h,
                          10.h,
                          12.h,
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  _buildBookList(context),
                  SizedBox(height: 18.h),
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.only(left: 34.h, right: 30.h),
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
                                imagePath: ImageConstant.imgImage3,
                                height: 240.h,
                                width: 232.h,
                                radius: BorderRadius.circular(10.h),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "msg_the_three_musketeers".tr,
                          style: CustomTextStyles.titleMediumBlack90001SemiBold,
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "lbl_40_00".tr,
                                style: CustomTextStyles
                                    .titleMediumPrimarySemiBold18,
                              ),
                              CustomRatingBar(initialRating: 5, itemSize: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 34.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconButton(
                        height: 44.h,
                        width: 44.h,
                        padding: EdgeInsets.all(10.h),
                        decoration: IconButtonStyleHelper.fillWhiteA,
                        child: CustomImageView(
                          imagePath: ImageConstant.imgArrowLeft,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.h, bottom: 8.h),
                          child: Text(
                            "lbl_page".tr,
                            style: CustomTextStyles.titleMediumBlack90001_2,
                          ),
                        ),
                      ),
                      CustomElevatedButton(
                        height: 44.h,
                        width: 44.h,
                        text: "lbl_5".tr,
                        margin: EdgeInsets.only(left: 16.h),
                        buttonStyle: CustomButtonStyles.fillWhiteATL8,
                        buttonTextStyle:
                            CustomTextStyles.titleMediumBluegray80001,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 14.h),
                        child: Text(
                          "lbl_of_80".tr,
                          style: CustomTextStyles.titleMediumBlack90001_2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 22.h),
                        child: CustomIconButton(
                          height: 44.h,
                          width: 44.h,
                          padding: EdgeInsets.all(10.h),
                          decoration: IconButtonStyleHelper.none,
                          child: CustomImageView(
                            imagePath: ImageConstant.imgArrowLeftWhiteA700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 70.h),
                  _buildPopularBooks(context),
                  SizedBox(height: 68.h),
                  _buildNewArrivals(context),
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
  Widget _buildBookList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 34.h, right: 30.h),
      child: Consumer(
        builder: (context, ref, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(height: 18.h);
            },
            itemCount: ref
                    .watch(eduviOnlineShopOneNotifier)
                    .scrollviewOneTab1ModelObj
                    ?.booklistItemList
                    .length ??
                0,
            itemBuilder: (context, index) {
              BooklistItemModel model = ref
                      .watch(eduviOnlineShopOneNotifier)
                      .scrollviewOneTab1ModelObj
                      ?.booklistItemList[index] ??
                  BooklistItemModel();
              return BooklistItemWidget(model);
            },
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPopularBooks(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_popular_books".tr,
            style: CustomTextStyles.headlineSmallBlack9000124,
          ),
          SizedBox(height: 6.h),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
                itemCount: ref
                        .watch(eduviOnlineShopOneNotifier)
                        .scrollviewOneTab1ModelObj
                        ?.listItemList
                        .length ??
                    0,
                itemBuilder: (context, index) {
                  ListItemModel model = ref
                          .watch(eduviOnlineShopOneNotifier)
                          .scrollviewOneTab1ModelObj
                          ?.listItemList[index] ??
                      ListItemModel();
                  return ListItemWidget(model);
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
  Widget _buildNewArrivals(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "lbl_new_arrivals".tr,
            style: CustomTextStyles.headlineSmallBlack9000124,
          ),
          SizedBox(height: 10.h),
          Consumer(
            builder: (context, ref, _) {
              return ListView.separated(
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.h);
                },
                itemCount: ref
                        .watch(eduviOnlineShopOneNotifier)
                        .scrollviewOneTab1ModelObj
                        ?.listOneItemList
                        .length ??
                    0,
                itemBuilder: (context, index) {
                  ListOneItemModel model = ref
                          .watch(eduviOnlineShopOneNotifier)
                          .scrollviewOneTab1ModelObj
                          ?.listOneItemList[index] ??
                      ListOneItemModel();
                  return ListOneItemWidget(model);
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
          Consumer(
            builder: (context, ref, _) {
              return CustomTextFormField(
                controller:
                    ref.watch(eduviOnlineShopOneNotifier).emailController,
                hintText: "msg_enter_your_email".tr,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
                contentPadding: EdgeInsets.fromLTRB(14.h, 16.h, 14.h, 14.h),
                validator: (value) {
                  if (value == null ||
                      (!isValidEmail(value, isRequired: true))) {
                    return "err_msg_please_enter_valid_email".tr;
                  }
                  return null;
                },
              );
            },
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            text: "lbl_subscribe".tr,
            buttonTextStyle: theme.textTheme.titleSmall!,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildCoursesSection(BuildContext context) {
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
  Widget _buildQuickLinks(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl_quick_links".tr, style: theme.textTheme.titleLarge),
          SizedBox(height: 16.h),
          Text("lbl_home".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text(
            "msg_professional_education".tr,
            style: theme.textTheme.bodyLarge,
          ),
          SizedBox(height: 16.h),
          Text("lbl_courses".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_admissions".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_testimonial".tr, style: theme.textTheme.bodyLarge),
          SizedBox(height: 16.h),
          Text("lbl_programs".tr, style: theme.textTheme.bodyLarge),
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
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: Text(
                      "lbl_educatsy".tr,
                      // Allow wrapping in the footer (no height constraint here)
                      // to avoid horizontal RenderFlex overflows.
                      softWrap: true,
                      style: theme.textTheme.headlineLarge,
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
          _buildCoursesSection(context),
          SizedBox(height: 28.h),
          _buildQuickLinks(context),
          SizedBox(height: 26.h),
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
