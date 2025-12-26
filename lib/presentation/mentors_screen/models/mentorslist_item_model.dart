import '../../../core/app_export.dart';

/// This class is used in the [mentorslist_item_widget] screen.

// ignore_for_file: must_be_immutable
class MentorslistItemModel {
  MentorslistItemModel({
    this.founderMentor,
    this.kristinwatson,
    this.foundermentor1,
    this.id,
  }) {
    founderMentor = founderMentor ?? ImageConstant.imgBg;
    kristinwatson = kristinwatson ?? "Kristin Watson";
    foundermentor1 = foundermentor1 ?? "Founder & Mentor";
    id = id ?? "";
  }

  String? founderMentor;

  String? kristinwatson;

  String? foundermentor1;

  String? id;
}
