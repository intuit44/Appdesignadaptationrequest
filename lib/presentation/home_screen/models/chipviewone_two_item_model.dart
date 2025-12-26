import 'package:equatable/equatable.dart';

/// This class is used in the [chipviewone_two_item_widget] screen.

// ignore_for_file: must_be_immutable
class ChipviewoneTwoItemModel extends Equatable {
  ChipviewoneTwoItemModel({this.oneTwo, this.isSelected}) {
    oneTwo = oneTwo ?? "Audio Classes";
    isSelected = isSelected ?? false;
  }

  String? oneTwo;

  bool? isSelected;

  ChipviewoneTwoItemModel copyWith({String? oneTwo, bool? isSelected}) {
    return ChipviewoneTwoItemModel(
      oneTwo: oneTwo ?? this.oneTwo,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [oneTwo, isSelected];
}
