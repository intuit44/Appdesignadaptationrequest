import '../../../core/app_export.dart';

/// This class is used in the [booklist_item_widget] screen.

// ignore_for_file: must_be_immutable
class BooklistItemModel {
  BooklistItemModel({this.imageOne, this.thethree, this.price, this.id}) {
    imageOne = imageOne ?? ImageConstant.imgImage240x230;
    thethree = thethree ?? "The Three Musketeers";
    price = price ?? "\$40.00";
    id = id ?? "";
  }

  String? imageOne;

  String? thethree;

  String? price;

  String? id;
}
