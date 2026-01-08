import '../../../core/app_export.dart';

/// This class is used in the [mentorslist_item_widget] screen.
/// Datos de mentores cargados desde el CRM de GoHighLevel

// ignore_for_file: must_be_immutable
class MentorslistItemModel {
  MentorslistItemModel({
    this.founderMentor,
    this.kristinwatson,
    this.foundermentor1,
    this.id,
    this.bio,
    this.specialties,
    this.socialLinks,
    this.email,
    this.phone,
  }) {
    founderMentor = founderMentor ?? ImageConstant.imgBg;
    kristinwatson = kristinwatson ?? "Instructor";
    foundermentor1 = foundermentor1 ?? "Especialista";
    id = id ?? "";
    bio = bio ?? "";
    specialties = specialties ?? [];
    socialLinks = socialLinks ?? {};
  }

  String? founderMentor;
  String? kristinwatson;
  String? foundermentor1;
  String? id;
  String? bio;
  List<String>? specialties;
  Map<String, String>? socialLinks;
  String? email;
  String? phone;
}
