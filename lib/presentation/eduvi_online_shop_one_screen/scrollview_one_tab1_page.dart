import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/repositories/shop_repository.dart';
import '../../data/models/product_model.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_rating_bar.dart';
import '../../widgets/custom_search_view.dart';
import '../../widgets/custom_text_form_field.dart';
import '../product_detail_screen/product_detail_screen.dart';
import 'notifier/eduvi_online_shop_one_notifier.dart';

class ScrollviewOneTab1Page extends ConsumerStatefulWidget {
  const ScrollviewOneTab1Page({super.key});

  @override
  ScrollviewOneTab1PageState createState() => ScrollviewOneTab1PageState();
}

class ScrollviewOneTab1PageState extends ConsumerState<ScrollviewOneTab1Page> {
  /// Navega al detalle del producto
  void _navigateToProductDetail(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          productId: product.id,
          product: product,
        ),
      ),
    );
  }

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

  /// Section Widget - Lista de productos de WooCommerce
  Widget _buildBookList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.h, right: 20.h),
      child: Consumer(
        builder: (context, ref, _) {
          final shopState = ref.watch(shopRepositoryProvider);

          // Estado de carga
          if (shopState.isLoading && shopState.products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.h),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: appTheme.deepOrange400),
                    SizedBox(height: 16.h),
                    Text(
                      "Cargando productos...",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }

          // Estado de error
          if (shopState.error != null && shopState.products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.h),
                child: Column(
                  children: [
                    Icon(Icons.error_outline,
                        size: 48.h, color: Colors.red.shade300),
                    SizedBox(height: 16.h),
                    Text(
                      "Error al cargar productos",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 8.h),
                    TextButton(
                      onPressed: () {
                        ref
                            .read(shopRepositoryProvider.notifier)
                            .loadProducts(refresh: true);
                      },
                      child: const Text("Reintentar"),
                    ),
                  ],
                ),
              ),
            );
          }

          // Sin productos
          if (shopState.products.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(40.h),
                child: Text(
                  "No hay productos disponibles",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            );
          }

          // Grid de productos reales
          return GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.h,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.75,
            ),
            itemCount: shopState.products.length,
            itemBuilder: (context, index) {
              final product = shopState.products[index];
              return _buildProductCard(product);
            },
          );
        },
      ),
    );
  }

  /// Construye una tarjeta de producto
  Widget _buildProductCard(ProductModel product) {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.src : null;
    final rating = double.tryParse(product.averageRating) ?? 0;

    return GestureDetector(
      onTap: () => _navigateToProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: appTheme.whiteA700,
          borderRadius: BorderRadius.circular(10.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10.h)),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? ExtendedImage.network(
                        imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        cache: true,
                        loadStateChanged: (state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return Container(
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: appTheme.deepOrange400,
                                  ),
                                ),
                              );
                            case LoadState.failed:
                              return Container(
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 40.h,
                                  color: Colors.grey.shade400,
                                ),
                              );
                            case LoadState.completed:
                              return null;
                          }
                        },
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 40.h,
                          color: Colors.grey.shade400,
                        ),
                      ),
              ),
            ),
            // Info del producto
            Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: CustomTextStyles.titleSmallGray90001,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price}',
                        style: TextStyle(
                          fontSize: 14.fSize,
                          fontWeight: FontWeight.bold,
                          color: appTheme.deepOrange400,
                        ),
                      ),
                      if (rating > 0)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12.h, color: Colors.amber),
                            SizedBox(width: 2.h),
                            Text(
                              rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 10.fSize,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (product.onSale)
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.h, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(4.h),
                      ),
                      child: Text(
                        'OFERTA',
                        style: TextStyle(
                          fontSize: 9.fSize,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget - Productos Populares (Featured)
  Widget _buildPopularBooks(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Productos Populares",
            style: CustomTextStyles.headlineSmallBlack9000124,
          ),
          SizedBox(height: 6.h),
          Consumer(
            builder: (context, ref, _) {
              final shopState = ref.watch(shopRepositoryProvider);

              // Filtrar productos destacados
              final featuredProducts =
                  shopState.products.where((p) => p.featured).take(4).toList();

              if (shopState.isLoading && shopState.products.isEmpty) {
                return _buildLoadingIndicator();
              }

              if (featuredProducts.isEmpty) {
                // Si no hay destacados, tomar los primeros 4
                final topProducts = shopState.products.take(4).toList();
                if (topProducts.isEmpty) {
                  return const SizedBox.shrink();
                }
                return _buildHorizontalProductList(topProducts);
              }

              return _buildHorizontalProductList(featuredProducts);
            },
          ),
        ],
      ),
    );
  }

  /// Widget para mostrar indicador de carga
  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          width: 24.h,
          height: 24.h,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: appTheme.deepOrange400,
          ),
        ),
      ),
    );
  }

  /// Widget para lista horizontal de productos
  Widget _buildHorizontalProductList(List<ProductModel> products) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: products.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.h),
        itemBuilder: (context, index) {
          final product = products[index];
          return SizedBox(
            width: 140.h,
            child: _buildCompactProductCard(product),
          );
        },
      ),
    );
  }

  /// Tarjeta compacta para listas horizontales
  Widget _buildCompactProductCard(ProductModel product) {
    final imageUrl =
        product.images.isNotEmpty ? product.images.first.src : null;

    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteA700,
        borderRadius: BorderRadius.circular(10.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.h)),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? ExtendedImage.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cache: true,
                      loadStateChanged: (state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                            return Container(
                              color: Colors.grey.shade200,
                              child: Center(
                                child: SizedBox(
                                  width: 20.h,
                                  height: 20.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: appTheme.deepOrange400,
                                  ),
                                ),
                              ),
                            );
                          case LoadState.failed:
                            return Container(
                              color: Colors.grey.shade200,
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                size: 30.h,
                                color: Colors.grey.shade400,
                              ),
                            );
                          case LoadState.completed:
                            return null;
                        }
                      },
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        size: 30.h,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),
          ),
          // Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      product.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        fontWeight: FontWeight.w500,
                        color: appTheme.gray90001,
                      ),
                    ),
                  ),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 14.fSize,
                      fontWeight: FontWeight.bold,
                      color: appTheme.deepOrange400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget - Nuevos Productos
  Widget _buildNewArrivals(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nuevos Productos",
            style: CustomTextStyles.headlineSmallBlack9000124,
          ),
          SizedBox(height: 10.h),
          Consumer(
            builder: (context, ref, _) {
              final shopState = ref.watch(shopRepositoryProvider);

              if (shopState.isLoading && shopState.products.isEmpty) {
                return _buildLoadingIndicator();
              }

              // Ordenar por fecha de creación (más recientes primero)
              final sortedProducts =
                  List<ProductModel>.from(shopState.products);
              sortedProducts.sort((a, b) {
                final dateA = a.dateCreated ?? DateTime(2000);
                final dateB = b.dateCreated ?? DateTime(2000);
                return dateB.compareTo(dateA);
              });

              final newProducts = sortedProducts.take(4).toList();

              if (newProducts.isEmpty) {
                return const SizedBox.shrink();
              }

              return _buildHorizontalProductList(newProducts);
            },
          ),
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
