/// This class is used in the [pricing_one_item_widget] screen.

// ignore_for_file: must_be_immutable
class PricingOneItemModel {
  PricingOneItemModel({
    this.basicpackOne,
    this.hdvideo,
    this.officialexam,
    this.practice,
    this.duration,
    this.freebook,
    this.practicequizes,
    this.indepth,
    this.personal,
    this.id,
  }) {
    basicpackOne = basicpackOne ?? "Basic Pack";
    hdvideo = hdvideo ?? "3 HD video lessons & tutorials";
    officialexam = officialexam ?? "1 Official exam";
    practice = practice ?? "100 Practice questions";
    duration = duration ?? "1 Month subscriptions";
    freebook = freebook ?? "1 Free book";
    practicequizes = practicequizes ?? "Practice quizes & assignments";
    indepth = indepth ?? "In depth explanations";
    personal = personal ?? "Personal instructor Assitance";
    id = id ?? "";
  }

  String? basicpackOne;

  String? hdvideo;

  String? officialexam;

  String? practice;

  String? duration;

  String? freebook;

  String? practicequizes;

  String? indepth;

  String? personal;

  String? id;
}
