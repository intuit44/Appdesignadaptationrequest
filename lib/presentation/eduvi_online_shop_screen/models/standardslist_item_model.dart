import '../../../core/app_export.dart';

/// This class is used in the [standardslist_item_widget] screen.

// ignore_for_file: must_be_immutable
class StandardslistItemModel {
  StandardslistItemModel({
    this.standardOne,
    this.standardone1,
    this.standard1isa,
    this.id,
  }) {
    standardOne = standardOne ?? ImageConstant.imgUser;
    standardone1 = standardone1 ?? "Standard One";
    standard1isa =
        standard1isa ??
        "Standard 1 is a foundation Standard that reflects 7 important concepts...";
    id = id ?? "";
  }

  String? standardOne;

  String? standardone1;

  String? standard1isa;

  String? id;
}
