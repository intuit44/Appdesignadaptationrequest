import 'package:equatable/equatable.dart';
import 'classlist_item_model.dart';

/// This class is used in the [scrollview_one_tab_page] screen.

// ignore_for_file: must_be_immutable
class ScrollviewOneTabModel extends Equatable {
  ScrollviewOneTabModel({this.classlistItemList = const []});

  List<ClasslistItemModel> classlistItemList;

  ScrollviewOneTabModel copyWith({
    List<ClasslistItemModel>? classlistItemList,
  }) {
    return ScrollviewOneTabModel(
      classlistItemList: classlistItemList ?? this.classlistItemList,
    );
  }

  @override
  List<Object?> get props => [classlistItemList];
}
