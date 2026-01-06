import 'package:flutter/material.dart';
import '../../core/app_export.dart';

/// Pantalla de Métodos de Pago
/// Permite gestionar tarjetas y métodos de pago guardados
class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  final List<Map<String, dynamic>> _paymentMethods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  Future<void> _loadPaymentMethods() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
      // Métodos de pago de ejemplo
      _paymentMethods.addAll([
        {
          'id': '1',
          'type': 'visa',
          'last4': '4242',
          'expMonth': 12,
          'expYear': 2027,
          'isDefault': true,
        },
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: AppBar(
        title: const Text('Métodos de Pago'),
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPaymentDialog(),
        backgroundColor: FibroColors.primaryOrange,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _paymentMethods.isEmpty
              ? _buildEmptyState()
              : _buildPaymentList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_off_outlined,
            size: 80.h,
            color: appTheme.blueGray600,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tienes métodos de pago',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Agrega una tarjeta para pagar más rápido',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.h),
      itemCount: _paymentMethods.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final method = _paymentMethods[index];
        return _PaymentMethodCard(
          method: method,
          onDelete: () => _deleteMethod(index),
          onSetDefault: () => _setDefaultMethod(index),
        );
      },
    );
  }

  void _showAddPaymentDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.h,
                height: 4.h,
                decoration: BoxDecoration(
                  color: appTheme.gray300,
                  borderRadius: BorderRadius.circular(2.h),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Agregar Método de Pago',
                style: TextStyle(
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              SizedBox(height: 24.h),
              _buildPaymentOption(
                icon: Icons.credit_card,
                title: 'Tarjeta de Crédito/Débito',
                subtitle: 'Visa, Mastercard, American Express',
                onTap: () {
                  Navigator.pop(context);
                  _showAddCardDialog();
                },
              ),
              SizedBox(height: 12.h),
              _buildPaymentOption(
                icon: Icons.account_balance,
                title: 'PayPal',
                subtitle: 'Conecta tu cuenta PayPal',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Integración PayPal próximamente'),
                    ),
                  );
                },
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.h),
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          border: Border.all(color: appTheme.gray200),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Row(
          children: [
            Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: FibroColors.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.h),
              ),
              child: Icon(icon, color: FibroColors.primaryOrange),
            ),
            SizedBox(width: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blueGray80001,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.fSize,
                      color: appTheme.blueGray600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: appTheme.blueGray600),
          ],
        ),
      ),
    );
  }

  void _showAddCardDialog() {
    final cardNumberController = TextEditingController();
    final expController = TextEditingController();
    final cvcController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.h,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: appTheme.gray300,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Agregar Tarjeta',
                style: TextStyle(
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(
                  labelText: 'Número de Tarjeta',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.h),
                  ),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expController,
                      decoration: InputDecoration(
                        labelText: 'MM/AA',
                        hintText: '12/27',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                  SizedBox(width: 12.h),
                  Expanded(
                    child: TextField(
                      controller: cvcController,
                      decoration: InputDecoration(
                        labelText: 'CVC',
                        hintText: '123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.h),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Simular agregar tarjeta
                    setState(() {
                      _paymentMethods.add({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'type': 'visa',
                        'last4': cardNumberController.text.length >= 4
                            ? cardNumberController.text
                                .substring(cardNumberController.text.length - 4)
                            : '0000',
                        'expMonth': 12,
                        'expYear': 2027,
                        'isDefault': _paymentMethods.isEmpty,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarjeta agregada')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FibroColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                  ),
                  child: const Text('Guardar Tarjeta'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMethod(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Método'),
        content: const Text('¿Estás seguro de eliminar este método de pago?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _paymentMethods.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _setDefaultMethod(int index) {
    setState(() {
      for (int i = 0; i < _paymentMethods.length; i++) {
        _paymentMethods[i]['isDefault'] = (i == index);
      }
    });
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final Map<String, dynamic> method;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _PaymentMethodCard({
    required this.method,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = method['isDefault'] ?? false;
    final type = method['type'] ?? 'card';
    final last4 = method['last4'] ?? '****';

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.h),
        border: isDefault
            ? Border.all(color: FibroColors.primaryOrange, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.h,
            height: 32.h,
            decoration: BoxDecoration(
              color: _getCardColor(type),
              borderRadius: BorderRadius.circular(6.h),
            ),
            child: Center(
              child: Text(
                _getCardName(type),
                style: TextStyle(
                  fontSize: 10.fSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '•••• $last4',
                      style: TextStyle(
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w600,
                        color: appTheme.blueGray80001,
                      ),
                    ),
                    if (isDefault) ...[
                      SizedBox(width: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.h, vertical: 2.h),
                        decoration: BoxDecoration(
                          color:
                              FibroColors.primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.h),
                        ),
                        child: Text(
                          'Principal',
                          style: TextStyle(
                            fontSize: 10.fSize,
                            fontWeight: FontWeight.w600,
                            color: FibroColors.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Expira ${method['expMonth']}/${method['expYear']}',
                  style: TextStyle(
                    fontSize: 12.fSize,
                    color: appTheme.blueGray600,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'delete':
                  onDelete();
                  break;
                case 'default':
                  onSetDefault();
                  break;
              }
            },
            itemBuilder: (context) => [
              if (!isDefault)
                const PopupMenuItem(
                    value: 'default', child: Text('Hacer principal')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Eliminar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCardColor(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return const Color(0xFF1A1F71);
      case 'mastercard':
        return const Color(0xFFEB001B);
      case 'amex':
        return const Color(0xFF006FCF);
      default:
        return Colors.grey;
    }
  }

  String _getCardName(String type) {
    switch (type.toLowerCase()) {
      case 'visa':
        return 'VISA';
      case 'mastercard':
        return 'MC';
      case 'amex':
        return 'AMEX';
      default:
        return 'CARD';
    }
  }
}
