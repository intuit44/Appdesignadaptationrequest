import 'package:flutter/material.dart';
import '../../core/app_export.dart';

/// Pantalla de Direcciones de Envío
/// Permite gestionar las direcciones del usuario
class AddressesScreen extends ConsumerStatefulWidget {
  const AddressesScreen({super.key});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  final List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    // Simular carga de direcciones desde storage o API
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isLoading = false;
      // Direcciones de ejemplo/demo
      _addresses.addAll([
        {
          'id': '1',
          'name': 'Casa',
          'address': '123 Main Street',
          'city': 'Miami',
          'state': 'FL',
          'zip': '33101',
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
        title: const Text('Mis Direcciones'),
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddressDialog(),
        backgroundColor: FibroColors.primaryOrange,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _addresses.isEmpty
              ? _buildEmptyState()
              : _buildAddressList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80.h,
            color: appTheme.blueGray600,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tienes direcciones guardadas',
            style: TextStyle(
              fontSize: 18.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Agrega una dirección de envío',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView.separated(
      padding: EdgeInsets.all(16.h),
      itemCount: _addresses.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final address = _addresses[index];
        return _AddressCard(
          address: address,
          onEdit: () => _showEditAddressDialog(address),
          onDelete: () => _deleteAddress(index),
          onSetDefault: () => _setDefaultAddress(index),
        );
      },
    );
  }

  void _showAddAddressDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        onSave: (address) {
          setState(() {
            if (_addresses.isEmpty) {
              address['isDefault'] = true;
            }
            _addresses.add(address);
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditAddressDialog(Map<String, dynamic> address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddressFormSheet(
        address: address,
        onSave: (updatedAddress) {
          setState(() {
            final index =
                _addresses.indexWhere((a) => a['id'] == address['id']);
            if (index != -1) {
              _addresses[index] = {..._addresses[index], ...updatedAddress};
            }
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _deleteAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Dirección'),
        content: const Text('¿Estás seguro de eliminar esta dirección?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _addresses.removeAt(index));
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

  void _setDefaultAddress(int index) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i]['isDefault'] = (i == index);
      }
    });
  }
}

class _AddressCard extends StatelessWidget {
  final Map<String, dynamic> address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const _AddressCard({
    required this.address,
    required this.onEdit,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    final isDefault = address['isDefault'] ?? false;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: FibroColors.primaryOrange,
                size: 20.h,
              ),
              SizedBox(width: 8.h),
              Text(
                address['name'] ?? 'Dirección',
                style: TextStyle(
                  fontSize: 16.fSize,
                  fontWeight: FontWeight.w600,
                  color: appTheme.blueGray80001,
                ),
              ),
              if (isDefault) ...[
                SizedBox(width: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: FibroColors.primaryOrange.withValues(alpha: 0.1),
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
              const Spacer(),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;
                    case 'delete':
                      onDelete();
                      break;
                    case 'default':
                      onSetDefault();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Editar')),
                  if (!isDefault)
                    const PopupMenuItem(
                        value: 'default', child: Text('Hacer principal')),
                  const PopupMenuItem(
                    value: 'delete',
                    child:
                        Text('Eliminar', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            address['address'] ?? '',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray80001,
            ),
          ),
          Text(
            '${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['zip'] ?? ''}',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressFormSheet extends StatefulWidget {
  final Map<String, dynamic>? address;
  final Function(Map<String, dynamic>) onSave;

  const _AddressFormSheet({
    this.address,
    required this.onSave,
  });

  @override
  State<_AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<_AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _zipController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.address?['name'] ?? '');
    _addressController =
        TextEditingController(text: widget.address?['address'] ?? '');
    _cityController =
        TextEditingController(text: widget.address?['city'] ?? '');
    _stateController =
        TextEditingController(text: widget.address?['state'] ?? '');
    _zipController = TextEditingController(text: widget.address?['zip'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.h)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.h),
        child: Form(
          key: _formKey,
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
                widget.address == null ? 'Nueva Dirección' : 'Editar Dirección',
                style: TextStyle(
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
              SizedBox(height: 20.h),
              _buildTextField(_nameController, 'Nombre (Casa, Oficina, etc.)'),
              SizedBox(height: 12.h),
              _buildTextField(_addressController, 'Dirección'),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(child: _buildTextField(_cityController, 'Ciudad')),
                  SizedBox(width: 12.h),
                  Expanded(child: _buildTextField(_stateController, 'Estado')),
                ],
              ),
              SizedBox(height: 12.h),
              _buildTextField(_zipController, 'Código Postal'),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FibroColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.h),
                    ),
                  ),
                  child: const Text('Guardar Dirección'),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 14.h),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Campo requerido';
        return null;
      },
    );
  }

  void _saveAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSave({
        'id': widget.address?['id'] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        'name': _nameController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zip': _zipController.text,
        'isDefault': widget.address?['isDefault'] ?? false,
      });
    }
  }
}
