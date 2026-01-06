part of 'fibro_shop_notifier.dart';

/// Represents the state of FibroShop in the application.

// ignore_for_file: must_be_immutable
class FibroShopState extends Equatable {
  FibroShopState({
    this.searchController,
    this.subscribeEmailInputController,
    this.selectedDropDownValue,
    this.scrollviewOneTab2ModelObj,
    this.fibroShopModelObj,
  });

  TextEditingController? searchController;

  TextEditingController? subscribeEmailInputController;

  SelectionPopupModel? selectedDropDownValue;

  FibroShopModel? fibroShopModelObj;

  ScrollviewOneTab2Model? scrollviewOneTab2ModelObj;

  @override
  List<Object?> get props => [
        searchController,
        subscribeEmailInputController,
        selectedDropDownValue,
        scrollviewOneTab2ModelObj,
        fibroShopModelObj,
      ];
  FibroShopState copyWith({
    TextEditingController? searchController,
    TextEditingController? subscribeEmailInputController,
    SelectionPopupModel? selectedDropDownValue,
    ScrollviewOneTab2Model? scrollviewOneTab2ModelObj,
    FibroShopModel? fibroShopModelObj,
  }) {
    return FibroShopState(
      searchController: searchController ?? this.searchController,
      subscribeEmailInputController:
          subscribeEmailInputController ?? this.subscribeEmailInputController,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      scrollviewOneTab2ModelObj:
          scrollviewOneTab2ModelObj ?? this.scrollviewOneTab2ModelObj,
      fibroShopModelObj: fibroShopModelObj ?? this.fibroShopModelObj,
    );
  }
}
