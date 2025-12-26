import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'listthethree_item_model.dart';
import 'standardslist_item_model.dart';

/// This class is used in the [scrollview_one_tab2_page] screen.

// ignore_for_file: must_be_immutable
class ScrollviewOneTab2Model extends Equatable {
  ScrollviewOneTab2Model({
    this.standardslistItemList = const [],
    this.dropdownItemList = const [],
    this.listthethreeItemList = const [],
  });

  List<StandardslistItemModel> standardslistItemList;

  List<SelectionPopupModel> dropdownItemList;

  List<ListthethreeItemModel> listthethreeItemList;

  ScrollviewOneTab2Model copyWith({
    List<StandardslistItemModel>? standardslistItemList,
    List<SelectionPopupModel>? dropdownItemList,
    List<ListthethreeItemModel>? listthethreeItemList,
  }) {
    return ScrollviewOneTab2Model(
      standardslistItemList:
          standardslistItemList ?? this.standardslistItemList,
      dropdownItemList: dropdownItemList ?? this.dropdownItemList,
      listthethreeItemList: listthethreeItemList ?? this.listthethreeItemList,
    );
  }

  @override
  List<Object?> get props => [
    standardslistItemList,
    dropdownItemList,
    listthethreeItemList,
  ];
}
