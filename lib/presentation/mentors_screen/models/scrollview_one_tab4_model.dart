import 'package:equatable/equatable.dart';
import 'mentorslist_item_model.dart';

/// This class is used in the [scrollview_one_tab4_page] screen.

// ignore_for_file: must_be_immutable
class ScrollviewOneTab4Model extends Equatable {
  ScrollviewOneTab4Model({this.mentorslistItemList = const []});

  List<MentorslistItemModel> mentorslistItemList;

  ScrollviewOneTab4Model copyWith({
    List<MentorslistItemModel>? mentorslistItemList,
  }) {
    return ScrollviewOneTab4Model(
      mentorslistItemList: mentorslistItemList ?? this.mentorslistItemList,
    );
  }

  @override
  List<Object?> get props => [mentorslistItemList];
}
