import '../../../core/app_export.dart';

/// This class is used in the [list_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListItemModel {
  ListItemModel({this.image, this.thethree, this.price, this.id}) {
    image = image ?? ImageConstant.imgImage14;
    thethree = thethree ?? "The Three Musketeers, by\nAlexandre Dumas";
    price = price ?? "\$39.00";
    id = id ?? "";
  }

  String? image;

  String? thethree;

  String? price;

  String? id;
}
