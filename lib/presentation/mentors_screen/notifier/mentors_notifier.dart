import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/mentors_model.dart';
import '../models/mentorslist_item_model.dart';
import '../models/scrollview_one_tab4_model.dart';
part 'mentors_state.dart';

final mentorsNotifier =
    StateNotifierProvider.autoDispose<MentorsNotifier, MentorsState>(
      (ref) => MentorsNotifier(
        MentorsState(
          emailController: TextEditingController(),
          scrollviewOneTab4ModelObj: ScrollviewOneTab4Model(
            mentorslistItemList: [
              MentorslistItemModel(
                founderMentor: ImageConstant.imgBg,
                kristinwatson: "Kristin Watson",
                foundermentor1: "Founder & Mentor",
              ),
              MentorslistItemModel(
                founderMentor: ImageConstant.imgBg290x290,
                kristinwatson: "Brooklyn Simmons",
                foundermentor1: "Founder & Mentor",
              ),
              MentorslistItemModel(
                founderMentor: ImageConstant.imgBg1,
                kristinwatson: "Robert Fox",
                foundermentor1: "Founder & Mentor",
              ),
              MentorslistItemModel(),
            ],
          ),
        ),
      ),
    );

/// A notifier that manages the state of a Mentors according to the event that is dispatched to it.
class MentorsNotifier extends StateNotifier<MentorsState> {
  MentorsNotifier(MentorsState state) : super(state);
}
