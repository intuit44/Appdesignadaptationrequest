part of 'eduvi_online_shop_one_notifier.dart';

/// Represents the state of EduviOnlineShopOne in the application.

// ignore_for_file: must_be_immutable
class EduviOnlineShopOneState extends Equatable {
  EduviOnlineShopOneState({
    this.searchController,
    this.emailController,
    this.selectedDropDownValue,
    this.scrollviewOneTab1ModelObj,
    this.eduviOnlineShopOneModelObj,
  });

  TextEditingController? searchController;

  TextEditingController? emailController;

  SelectionPopupModel? selectedDropDownValue;

  EduviOnlineShopOneModel? eduviOnlineShopOneModelObj;

  ScrollviewOneTab1Model? scrollviewOneTab1ModelObj;

  @override
  List<Object?> get props => [
    searchController,
    emailController,
    selectedDropDownValue,
    scrollviewOneTab1ModelObj,
    eduviOnlineShopOneModelObj,
  ];
  EduviOnlineShopOneState copyWith({
    TextEditingController? searchController,
    TextEditingController? emailController,
    SelectionPopupModel? selectedDropDownValue,
    ScrollviewOneTab1Model? scrollviewOneTab1ModelObj,
    EduviOnlineShopOneModel? eduviOnlineShopOneModelObj,
  }) {
    return EduviOnlineShopOneState(
      searchController: searchController ?? this.searchController,
      emailController: emailController ?? this.emailController,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      scrollviewOneTab1ModelObj:
          scrollviewOneTab1ModelObj ?? this.scrollviewOneTab1ModelObj,
      eduviOnlineShopOneModelObj:
          eduviOnlineShopOneModelObj ?? this.eduviOnlineShopOneModelObj,
    );
  }
}
