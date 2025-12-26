import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/chipviewone_two_item_model.dart';
import '../models/classlist_item_model.dart';
import '../models/home_model.dart';
import '../models/scrollview_one_tab_model.dart';
part 'home_state.dart';

final homeNotifier = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>(
  (ref) => HomeNotifier(
    HomeState(
      classInputController: TextEditingController(),
      emailInputController: TextEditingController(),
      selectedDropDownValue: SelectionPopupModel(title: ''),
      scrollviewOneTabModelObj: ScrollviewOneTabModel(
        classlistItemList: [
          ClasslistItemModel(
            standardOne: ImageConstant.imgUser,
            standardone1: "Standard One",
            standard1isa:
                "Standard 1 is a foundation Standard that reflects 7 important concepts...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgProfile,
            standardone1: "Standard Two",
            standard1isa:
                "Standard 2 builds on the foundations of Standard 1 and includes requirements...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgProfileTealA400,
            standardone1: "Standard Three",
            standard1isa:
                "Standard 3 of the Aged Care Quality Standards applies to all services delivering personal...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgForward,
            standardone1: "Standard Four",
            standard1isa:
                "Standard 4 of the Aged Care Quality Standards focuses on services and supports...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgGroup,
            standardone1: "Standard Five",
            standard1isa:
                "Standard 5 Learning Resources. Learning Resources ensure that the school has the...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgUserDeepOrange500,
            standardone1: "Standard Six",
            standard1isa:
                "Standard 6 requires an organisation to have a system to resolve complaints...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgCursor,
            standardone1: "Standard Seven",
            standard1isa:
                "Standard 7 Blood Management mandates that leaders of health service organisations...",
          ),
          ClasslistItemModel(
            standardOne: ImageConstant.imgSettings,
            standardone1: "Standard Eight",
            standard1isa:
                "Standard 8 Course from NCERT Solutions help students to understand...",
          ),
        ],
      ),
      homeModelObj: HomeModel(
        dropdownItemList: [
          SelectionPopupModel(id: 1, title: "Item One", isSelected: true),
          SelectionPopupModel(id: 2, title: "Item Two"),
          SelectionPopupModel(id: 3, title: "Item Three"),
        ],
        chipviewoneTwoItemList: [
          ChipviewoneTwoItemModel(oneTwo: "Audio Classes"),
          ChipviewoneTwoItemModel(oneTwo: "Live Classes"),
          ChipviewoneTwoItemModel(oneTwo: "Recorded Classes"),
        ],
      ),
    ),
  ),
);

/// A notifier that manages the state of a Home according to the event that is dispatched to it.
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier(HomeState state) : super(state);

  void onSelectedChipView(int index, bool value) {
    List<ChipviewoneTwoItemModel> newList = List<ChipviewoneTwoItemModel>.from(
      state.homeModelObj!.chipviewoneTwoItemList,
    );
    newList[index] = newList[index].copyWith(isSelected: value);
    state = state.copyWith(
      homeModelObj: state.homeModelObj?.copyWith(
        chipviewoneTwoItemList: newList,
      ),
    );
  }
}
