import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/booklist_item_model.dart';
import '../models/eduvi_online_shop_one_model.dart';
import '../models/list_item_model.dart';
import '../models/list_one_item_model.dart';
import '../models/scrollview_one_tab1_model.dart';
part 'eduvi_online_shop_one_state.dart';

final eduviOnlineShopOneNotifier = StateNotifierProvider.autoDispose<
  EduviOnlineShopOneNotifier,
  EduviOnlineShopOneState
>(
  (ref) => EduviOnlineShopOneNotifier(
    EduviOnlineShopOneState(
      searchController: TextEditingController(),
      emailController: TextEditingController(),
      selectedDropDownValue: SelectionPopupModel(title: ''),
      scrollviewOneTab1ModelObj: ScrollviewOneTab1Model(
        dropdownItemList: [
          SelectionPopupModel(id: 1, title: "Item One", isSelected: true),
          SelectionPopupModel(id: 2, title: "Item Two"),
          SelectionPopupModel(id: 3, title: "Item Three"),
        ],
        booklistItemList: [
          BooklistItemModel(
            imageOne: ImageConstant.imgImage240x230,
            thethree: "The Three Musketeers",
            price: "\$40.00",
          ),
          BooklistItemModel(
            imageOne: ImageConstant.imgImage1,
            thethree: "The Three Musketeers",
            price: "\$40.00",
          ),
          BooklistItemModel(
            imageOne: ImageConstant.imgImage2,
            thethree: "The Three Musketeers",
            price: "\$40.00",
          ),
        ],
        listItemList: [
          ListItemModel(
            image: ImageConstant.imgImage14,
            thethree: "The Three Musketeers, by\nAlexandre Dumas",
            price: "\$39.00",
          ),
          ListItemModel(
            image: ImageConstant.imgImage86x76,
            thethree: "The Three Musketeers, by\nAlexandre Dumas",
            price: "\$39.00",
          ),
          ListItemModel(
            image: ImageConstant.imgImage4,
            thethree: "The Three Musketeers, by\nAlexandre Dumas",
            price: "\$39.00",
          ),
        ],
        listOneItemList: [
          ListOneItemModel(
            image: ImageConstant.imgImage14,
            thethree: "The Three Musketeers, by\nAlexandre Dumas",
            price: "\$39.00",
          ),
          ListOneItemModel(
            image: ImageConstant.imgImage86x76,
            thethree: "The Three Musketeers, by\nAlexandre Dumas",
            price: "\$39.00",
          ),
          ListOneItemModel(
            image: ImageConstant.imgImage4,
            thethree: "The Three Musketeers, by\nAlexandre Dumas",
            price: "\$39.00",
          ),
        ],
      ),
    ),
  ),
);

/// A notifier that manages the state of a EduviOnlineShopOne according to the event that is dispatched to it.
class EduviOnlineShopOneNotifier
    extends StateNotifier<EduviOnlineShopOneState> {
  EduviOnlineShopOneNotifier(EduviOnlineShopOneState state) : super(state);
}
