import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/fibro_course_details_model.dart';
import '../models/listmaths_item_model.dart';
import '../models/listthethree1_item_model.dart';
part 'fibro_course_details_state.dart';

final fibroCourseDetailsNotifier = StateNotifierProvider.autoDispose<
    FibroCourseDetailsNotifier, FibroCourseDetailsState>(
  (ref) => FibroCourseDetailsNotifier(
    FibroCourseDetailsState(
      emailController: TextEditingController(),
      fibroCourseDetailsModelObj: FibroCourseDetailsModel(
        listmathsItemList: [
          ListmathsItemModel(
            image: ImageConstant.imgImage50x80,
            maths: "Maths - Introduction",
            time: "1:57",
          ),
          ListmathsItemModel(
            image: ImageConstant.imgImage50x80,
            maths: "Maths - Introduction",
            time: "1:57",
          ),
          ListmathsItemModel(maths: "Maths - Introduction", time: "1:57"),
          ListmathsItemModel(maths: "Maths - Introduction", time: "1:57"),
          ListmathsItemModel(maths: "Maths - Introduction", time: "1:57"),
        ],
        listthethree1ItemList: [
          Listthethree1ItemModel(
            thethree: "The Three Musketeers",
            price: "\$39.00",
          ),
          Listthethree1ItemModel(),
          Listthethree1ItemModel(),
        ],
      ),
    ),
  ),
);

/// A notifier that manages the state of a FibroCourseDetails according to the event that is dispatched to it.
class FibroCourseDetailsNotifier
    extends StateNotifier<FibroCourseDetailsState> {
  FibroCourseDetailsNotifier(super.state);
}
