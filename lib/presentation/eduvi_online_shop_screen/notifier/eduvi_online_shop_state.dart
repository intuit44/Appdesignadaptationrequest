part of 'eduvi_online_shop_notifier.dart';

/// Represents the state of EduviOnlineShop in the application.

// ignore_for_file: must_be_immutable
class EduviOnlineShopState extends Equatable {
  EduviOnlineShopState({
    this.searchController,
    this.subscribeEmailInputController,
    this.selectedDropDownValue,
    this.scrollviewOneTab2ModelObj,
    this.eduviOnlineShopModelObj,
  });

  TextEditingController? searchController;

  TextEditingController? subscribeEmailInputController;

  SelectionPopupModel? selectedDropDownValue;

  EduviOnlineShopModel? eduviOnlineShopModelObj;

  ScrollviewOneTab2Model? scrollviewOneTab2ModelObj;

  @override
  List<Object?> get props => [
    searchController,
    subscribeEmailInputController,
    selectedDropDownValue,
    scrollviewOneTab2ModelObj,
    eduviOnlineShopModelObj,
  ];
  EduviOnlineShopState copyWith({
    TextEditingController? searchController,
    TextEditingController? subscribeEmailInputController,
    SelectionPopupModel? selectedDropDownValue,
    ScrollviewOneTab2Model? scrollviewOneTab2ModelObj,
    EduviOnlineShopModel? eduviOnlineShopModelObj,
  }) {
    return EduviOnlineShopState(
      searchController: searchController ?? this.searchController,
      subscribeEmailInputController:
          subscribeEmailInputController ?? this.subscribeEmailInputController,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      scrollviewOneTab2ModelObj:
          scrollviewOneTab2ModelObj ?? this.scrollviewOneTab2ModelObj,
      eduviOnlineShopModelObj:
          eduviOnlineShopModelObj ?? this.eduviOnlineShopModelObj,
    );
  }
}
