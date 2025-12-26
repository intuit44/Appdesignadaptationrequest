import 'package:equatable/equatable.dart';
import 'pricing_one_item_model.dart';

/// This class defines the variables used in the [pricing_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class PricingModel extends Equatable {
  PricingModel({this.pricingOneItemList = const []});

  List<PricingOneItemModel> pricingOneItemList;

  PricingModel copyWith({List<PricingOneItemModel>? pricingOneItemList}) {
    return PricingModel(
      pricingOneItemList: pricingOneItemList ?? this.pricingOneItemList,
    );
  }

  @override
  List<Object?> get props => [pricingOneItemList];
}
