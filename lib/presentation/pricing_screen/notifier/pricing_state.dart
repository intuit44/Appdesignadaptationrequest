part of 'pricing_notifier.dart';

/// Represents the state of Pricing in the application.

// ignore_for_file: must_be_immutable
class PricingState extends Equatable {
  PricingState({this.emailSubscriptionInputController, this.pricingModelObj});

  TextEditingController? emailSubscriptionInputController;

  PricingModel? pricingModelObj;

  @override
  List<Object?> get props => [
    emailSubscriptionInputController,
    pricingModelObj,
  ];
  PricingState copyWith({
    TextEditingController? emailSubscriptionInputController,
    PricingModel? pricingModelObj,
  }) {
    return PricingState(
      emailSubscriptionInputController:
          emailSubscriptionInputController ??
          this.emailSubscriptionInputController,
      pricingModelObj: pricingModelObj ?? this.pricingModelObj,
    );
  }
}
