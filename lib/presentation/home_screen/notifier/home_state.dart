part of 'home_notifier.dart';

/// Represents the state of Home in the application.

// ignore_for_file: must_be_immutable
class HomeState extends Equatable {
  HomeState({
    this.classInputController,
    this.emailInputController,
    this.selectedDropDownValue,
    this.scrollviewOneTabModelObj,
    this.homeModelObj,
  });

  TextEditingController? classInputController;

  TextEditingController? emailInputController;

  SelectionPopupModel? selectedDropDownValue;

  HomeModel? homeModelObj;

  ScrollviewOneTabModel? scrollviewOneTabModelObj;

  @override
  List<Object?> get props => [
    classInputController,
    emailInputController,
    selectedDropDownValue,
    scrollviewOneTabModelObj,
    homeModelObj,
  ];
  HomeState copyWith({
    TextEditingController? classInputController,
    TextEditingController? emailInputController,
    SelectionPopupModel? selectedDropDownValue,
    ScrollviewOneTabModel? scrollviewOneTabModelObj,
    HomeModel? homeModelObj,
  }) {
    return HomeState(
      classInputController: classInputController ?? this.classInputController,
      emailInputController: emailInputController ?? this.emailInputController,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      scrollviewOneTabModelObj:
          scrollviewOneTabModelObj ?? this.scrollviewOneTabModelObj,
      homeModelObj: homeModelObj ?? this.homeModelObj,
    );
  }
}
