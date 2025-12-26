import '../../../core/app_export.dart';

/// This class is used in the [listmaths_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListmathsItemModel {
  ListmathsItemModel({this.image, this.maths, this.time, this.id}) {
    image = image ?? ImageConstant.imgImage50x80;
    maths = maths ?? "Maths - Introduction";
    time = time ?? "1:57";
    id = id ?? "";
  }

  String? image;

  String? maths;

  String? time;

  String? id;
}
