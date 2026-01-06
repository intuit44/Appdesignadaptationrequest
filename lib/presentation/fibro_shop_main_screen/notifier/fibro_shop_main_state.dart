part of 'fibro_shop_main_notifier.dart';

/// Represents the state of FibroShopMain in the application.

// ignore_for_file: must_be_immutable
class FibroShopMainState extends Equatable {
  FibroShopMainState({
    this.searchController,
    this.emailController,
    this.selectedDropDownValue,
    this.scrollviewOneTab1ModelObj,
    this.fibroShopMainModelObj,
  });

  TextEditingController? searchController;

  TextEditingController? emailController;

  SelectionPopupModel? selectedDropDownValue;

  FibroShopMainModel? fibroShopMainModelObj;

  ScrollviewOneTab1Model? scrollviewOneTab1ModelObj;

  @override
  List<Object?> get props => [
        searchController,
        emailController,
        selectedDropDownValue,
        scrollviewOneTab1ModelObj,
        fibroShopMainModelObj,
      ];
  FibroShopMainState copyWith({
    TextEditingController? searchController,
    TextEditingController? emailController,
    SelectionPopupModel? selectedDropDownValue,
    ScrollviewOneTab1Model? scrollviewOneTab1ModelObj,
    FibroShopMainModel? fibroShopMainModelObj,
  }) {
    return FibroShopMainState(
      searchController: searchController ?? this.searchController,
      emailController: emailController ?? this.emailController,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      scrollviewOneTab1ModelObj:
          scrollviewOneTab1ModelObj ?? this.scrollviewOneTab1ModelObj,
      fibroShopMainModelObj:
          fibroShopMainModelObj ?? this.fibroShopMainModelObj,
    );
  }
}
