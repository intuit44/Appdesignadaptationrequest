import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../data/repositories/shop_repository.dart';

/// Pantalla de Mis Pedidos
/// Muestra el historial de compras del usuario
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar pedidos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(shopRepositoryProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopRepositoryProvider);
    final orders = shopState.orders;

    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: shopState.isLoadingOrders
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? _buildEmptyState()
              : _buildOrdersList(orders),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 80.h,
            color: appTheme.blueGray600,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tienes pedidos aún',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Cuando realices una compra, aparecerá aquí',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              NavigatorService.pushNamed(AppRoutes.productCategoriesScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 12.h),
            ),
            child: const Text('Ir a la Tienda'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<dynamic> orders) {
    return ListView.separated(
      padding: EdgeInsets.all(16.h),
      itemCount: orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _OrderCard(order: order);
      },
    );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final orderId = order['id']?.toString() ?? 'N/A';
    final status = order['status'] ?? 'pending';
    final total = order['total'] ?? '0.00';
    final dateCreated = order['date_created'] ?? '';

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #$orderId',
                style: TextStyle(
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w600,
                  color: appTheme.blueGray80001,
                ),
              ),
              _buildStatusChip(status),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            _formatDate(dateCreated),
            style: TextStyle(
              fontSize: 12.fSize,
              color: appTheme.blueGray600,
            ),
          ),
          SizedBox(height: 12.h),
          Divider(color: appTheme.gray100),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14.fSize,
                  color: appTheme.blueGray600,
                ),
              ),
              Text(
                '\$$total',
                style: TextStyle(
                  fontSize: 18.fSize,
                  fontWeight: FontWeight.bold,
                  color: FibroColors.primaryOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        label = 'Completado';
        break;
      case 'processing':
        color = Colors.blue;
        label = 'Procesando';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pendiente';
        break;
      case 'cancelled':
        color = Colors.red;
        label = 'Cancelado';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.h),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.fSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return dateStr;
    }
  }
}
