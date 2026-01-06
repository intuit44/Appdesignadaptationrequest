import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/fibro_shop_model.dart';
import '../models/listthethree_item_model.dart';
import '../models/scrollview_one_tab2_model.dart';
import '../models/standardslist_item_model.dart';
part 'fibro_shop_state.dart';

final fibroShopNotifier =
    StateNotifierProvider.autoDispose<FibroShopNotifier, FibroShopState>(
  (ref) => FibroShopNotifier(
    FibroShopState(
      searchController: TextEditingController(),
      subscribeEmailInputController: TextEditingController(),
      selectedDropDownValue: SelectionPopupModel(title: ''),
      scrollviewOneTab2ModelObj: ScrollviewOneTab2Model(
        standardslistItemList: [
          StandardslistItemModel(
            standardOne: ImageConstant.imgUser,
            standardone1: "Standard One",
            standard1isa:
                "Standard 1 is a foundation Standard that reflects 7 important concepts...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgProfile,
            standardone1: "Standard Two",
            standard1isa:
                "Standard 2 builds on the foundations of Standard 1 and includes requirements...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgProfileTealA400,
            standardone1: "Standard Three",
            standard1isa:
                "Standard 3 of the Aged Care Quality Standards applies to all services delivering personal...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgForward,
            standardone1: "Standard Four",
            standard1isa:
                "Standard 4 of the Aged Care Quality Standards focuses on services and supports...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgGroup,
            standardone1: "Standard Five",
            standard1isa:
                "Standard 5 Learning Resources. Learning Resources ensure that the school has the...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgUserDeepOrange500,
            standardone1: "Standard Six",
            standard1isa:
                "Standard 6 requires an organisation to have a system to resolve complaints...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgCursor,
            standardone1: "Standard Seven",
            standard1isa:
                "Standard 7 Blood Management mandates that leaders of health service organisations...",
          ),
          StandardslistItemModel(
            standardOne: ImageConstant.imgSettings,
            standardone1: "Standard Eight",
            standard1isa:
                "Standard 8 Course from NCERT Solutions help students to understand...",
          ),
        ],
        dropdownItemList: [
          SelectionPopupModel(id: 1, title: "Item One", isSelected: true),
          SelectionPopupModel(id: 2, title: "Item Two"),
          SelectionPopupModel(id: 3, title: "Item Three"),
        ],
        listthethreeItemList: [
          ListthethreeItemModel(
            image: ImageConstant.imgImage14,
            thethree: "The Three Musketeers",
            price: "\$39.00",
            shoppingbagtwen: ImageConstant.imgShoppingBag24,
          ),
          ListthethreeItemModel(
            image: ImageConstant.imgImage86x76,
            thethree: "The Three Musketeers",
            price: "\$39.00",
            shoppingbagtwen: ImageConstant.imgShoppingBag24Primary,
          ),
          ListthethreeItemModel(
            image: ImageConstant.imgImage4,
            thethree: "The Three Musketeers",
            price: "\$39.00",
            shoppingbagtwen: ImageConstant.imgShoppingBag24Primary,
          ),
        ],
      ),
    ),
  ),
);

/// A notifier that manages the state of a EduviOnlineShop according to the event that is dispatched to it.
class FibroShopNotifier extends StateNotifier<FibroShopState> {
  FibroShopNotifier(super.state);
}
