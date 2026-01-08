import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/services/agent_crm_service.dart';
import '../models/pricing_model.dart';
import '../models/pricing_one_item_model.dart';
part 'pricing_state.dart';

/// Provider que carga membresías desde el CRM de GoHighLevel y las convierte a modelos de UI
/// Diferente de crmMembershipsProvider del servicio que devuelve AgentCRMProduct
final pricingMembershipsProvider =
    FutureProvider<List<PricingOneItemModel>>((ref) async {
  final crmService = AgentCRMService.instance;
  final memberships = await crmService.getMemberships();

  if (memberships.isEmpty) {
    // Si no hay membresías en CRM, devolver lista vacía
    // La UI mostrará un mensaje apropiado
    return [];
  }

  return memberships.map((m) => PricingOneItemModel.fromCRMProduct(m)).toList();
});

final pricingNotifier =
    StateNotifierProvider.autoDispose<PricingNotifier, PricingState>(
  (ref) => PricingNotifier(
    PricingState(
      emailSubscriptionInputController: TextEditingController(),
      pricingModelObj: PricingModel(
        pricingOneItemList: [], // Se carga desde CRM
      ),
    ),
  ),
);

/// A notifier that manages the state of a Pricing according to the event that is dispatched to it.
class PricingNotifier extends StateNotifier<PricingState> {
  PricingNotifier(super.state);

  /// Actualiza la lista de membresías desde el CRM
  void updateMemberships(List<PricingOneItemModel> memberships) {
    state = state.copyWith(
      pricingModelObj: state.pricingModelObj?.copyWith(
        pricingOneItemList: memberships,
      ),
    );
  }
}
