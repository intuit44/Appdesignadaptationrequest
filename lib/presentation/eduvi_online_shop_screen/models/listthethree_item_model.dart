import '../../../core/app_export.dart';

/// This class is used in the [listthethree_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListthethreeItemModel {
  ListthethreeItemModel({
    this.image,
    this.thethree,
    this.price,
    this.shoppingbagtwen,
    this.id,
  }) {
    image = image ?? ImageConstant.imgImage14;
    thethree = thethree ?? "The Three Musketeers";
    price = price ?? "\$39.00";
    shoppingbagtwen = shoppingbagtwen ?? ImageConstant.imgShoppingBag24;
    id = id ?? "";
  }

  String? image;

  String? thethree;

  String? price;

  String? shoppingbagtwen;

  String? id;
}
