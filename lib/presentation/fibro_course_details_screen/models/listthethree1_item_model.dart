/// This class is used in the [listthethree1_item_widget] screen.
library;

// ignore_for_file: must_be_immutable
class Listthethree1ItemModel {
  Listthethree1ItemModel({this.thethree, this.price, this.id}) {
    thethree = thethree ?? "The Three Musketeers";
    price = price ?? "\$39.00";
    id = id ?? "";
  }

  String? thethree;

  String? price;

  String? id;
}
