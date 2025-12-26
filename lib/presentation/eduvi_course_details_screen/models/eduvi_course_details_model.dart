import 'package:equatable/equatable.dart';
import 'listmaths_item_model.dart';
import 'listthethree1_item_model.dart';

/// This class defines the variables used in the [eduvi_course_details_screen],
/// and is typically used to hold data that is passed between different parts of the application.

// ignore_for_file: must_be_immutable
class EduviCourseDetailsModel extends Equatable {
  EduviCourseDetailsModel({
    this.listmathsItemList = const [],
    this.listthethree1ItemList = const [],
  });

  List<ListmathsItemModel> listmathsItemList;

  List<Listthethree1ItemModel> listthethree1ItemList;

  EduviCourseDetailsModel copyWith({
    List<ListmathsItemModel>? listmathsItemList,
    List<Listthethree1ItemModel>? listthethree1ItemList,
  }) {
    return EduviCourseDetailsModel(
      listmathsItemList: listmathsItemList ?? this.listmathsItemList,
      listthethree1ItemList:
          listthethree1ItemList ?? this.listthethree1ItemList,
    );
  }

  @override
  List<Object?> get props => [listmathsItemList, listthethree1ItemList];
}
