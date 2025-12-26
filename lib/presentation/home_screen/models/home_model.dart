import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'chipviewone_two_item_model.dart';

/// This class defines the variables used in the [home_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class HomeModel extends Equatable {
  HomeModel({
    this.dropdownItemList = const [],
    this.chipviewoneTwoItemList = const [],
  });

  List<SelectionPopupModel> dropdownItemList;

  List<ChipviewoneTwoItemModel> chipviewoneTwoItemList;

  HomeModel copyWith({
    List<SelectionPopupModel>? dropdownItemList,
    List<ChipviewoneTwoItemModel>? chipviewoneTwoItemList,
  }) {
    return HomeModel(
      dropdownItemList: dropdownItemList ?? this.dropdownItemList,
      chipviewoneTwoItemList:
          chipviewoneTwoItemList ?? this.chipviewoneTwoItemList,
    );
  }

  @override
  List<Object?> get props => [dropdownItemList, chipviewoneTwoItemList];
}
