import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import 'booklist_item_model.dart';
import 'list_item_model.dart';
import 'list_one_item_model.dart';

/// This class is used in the [scrollview_one_tab1_page] screen.

// ignore_for_file: must_be_immutable
class ScrollviewOneTab1Model extends Equatable {
  ScrollviewOneTab1Model({
    this.dropdownItemList = const [],
    this.booklistItemList = const [],
    this.listItemList = const [],
    this.listOneItemList = const [],
  });

  List<SelectionPopupModel> dropdownItemList;

  List<BooklistItemModel> booklistItemList;

  List<ListItemModel> listItemList;

  List<ListOneItemModel> listOneItemList;

  ScrollviewOneTab1Model copyWith({
    List<SelectionPopupModel>? dropdownItemList,
    List<BooklistItemModel>? booklistItemList,
    List<ListItemModel>? listItemList,
    List<ListOneItemModel>? listOneItemList,
  }) {
    return ScrollviewOneTab1Model(
      dropdownItemList: dropdownItemList ?? this.dropdownItemList,
      booklistItemList: booklistItemList ?? this.booklistItemList,
      listItemList: listItemList ?? this.listItemList,
      listOneItemList: listOneItemList ?? this.listOneItemList,
    );
  }

  @override
  List<Object?> get props => [
    dropdownItemList,
    booklistItemList,
    listItemList,
    listOneItemList,
  ];
}
