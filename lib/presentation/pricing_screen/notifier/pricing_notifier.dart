import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/pricing_model.dart';
import '../models/pricing_one_item_model.dart';
part 'pricing_state.dart';

final pricingNotifier =
    StateNotifierProvider.autoDispose<PricingNotifier, PricingState>(
      (ref) => PricingNotifier(
        PricingState(
          emailSubscriptionInputController: TextEditingController(),
          pricingModelObj: PricingModel(
            pricingOneItemList: [
              PricingOneItemModel(
                basicpackOne: "Basic Pack",
                hdvideo: "3 HD video lessons & tutorials",
                officialexam: "1 Official exam",
                practice: "100 Practice questions",
                duration: "1 Month subscriptions",
                freebook: "1 Free book",
                practicequizes: "Practice quizes & assignments",
                indepth: "In depth explanations",
                personal: "Personal instructor Assitance",
              ),
              PricingOneItemModel(
                basicpackOne: "Standard Plan",
                hdvideo: "3 HD video lessons & tutorials",
                officialexam: "1 Official exam",
                practice: "100 Practice questions",
                duration: "1 Month subscriptions",
                freebook: "1 Free book",
                practicequizes: "Practice quizes & assignments",
                indepth: "In depth explanations",
                personal: "Personal instructor Assitance",
              ),
              PricingOneItemModel(
                basicpackOne: "Premium Plan",
                hdvideo: "3 HD video lessons & tutorials",
                officialexam: "1 Official exam",
                practice: "100 Practice questions",
                duration: "1 Month subscriptions",
                freebook: "1 Free book",
                practicequizes: "Practice quizes & assignments",
                indepth: "In depth explanations",
                personal: "Personal instructor Assitance",
              ),
            ],
          ),
        ),
      ),
    );

/// A notifier that manages the state of a Pricing according to the event that is dispatched to it.
class PricingNotifier extends StateNotifier<PricingState> {
  PricingNotifier(PricingState state) : super(state);
}
