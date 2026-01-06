/// Widgets para mostrar Tags y Forms del CRM
/// Tags: Categorización dinámica de cursos
/// Forms: Formularios dinámicos del CRM para registros especiales
library;

import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../data/models/agent_crm_models.dart';
import '../data/services/agent_crm_service.dart';

// ==================== TAGS WIDGETS ====================

/// Widget que muestra un tag como chip seleccionable
class CRMTagChip extends StatelessWidget {
  final AgentCRMTag tag;
  final bool isSelected;
  final VoidCallback? onTap;

  const CRMTagChip({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? FibroColors.primaryOrange : Colors.white,
          borderRadius: BorderRadius.circular(20.h),
          border: Border.all(
            color:
                isSelected ? FibroColors.primaryOrange : appTheme.blueGray100,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: FibroColors.primaryOrange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          tag.name,
          style: TextStyle(
            fontSize: 13.fSize,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : appTheme.blueGray700,
          ),
        ),
      ),
    );
  }
}

/// Widget que muestra los tags como filtros de categorías
class CRMTagsFilter extends ConsumerWidget {
  final Function(AgentCRMTag?)? onTagSelected;
  final String? selectedTagId;
  final String? title;
  final bool showAllOption;

  const CRMTagsFilter({
    super.key,
    this.onTagSelected,
    this.selectedTagId,
    this.title,
    this.showAllOption = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(crmTagsProvider);

    return tagsAsync.when(
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                child: Text(
                  title!,
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blueGray80001,
                  ),
                ),
              ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 44.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                scrollDirection: Axis.horizontal,
                itemCount: showAllOption ? tags.length + 1 : tags.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.h),
                itemBuilder: (context, index) {
                  if (showAllOption && index == 0) {
                    return CRMTagChip(
                      tag: AgentCRMTag(id: '', name: 'Todos'),
                      isSelected: selectedTagId == null,
                      onTap: () => onTagSelected?.call(null),
                    );
                  }
                  final tagIndex = showAllOption ? index - 1 : index;
                  final tag = tags[tagIndex];
                  return CRMTagChip(
                    tag: tag,
                    isSelected: selectedTagId == tag.id,
                    onTap: () => onTagSelected?.call(tag),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => _buildLoadingTags(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildLoadingTags() {
    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, __) => SizedBox(width: 8.h),
        itemBuilder: (context, index) {
          return Container(
            width: 80.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.h),
            ),
          );
        },
      ),
    );
  }
}

/// Widget compacto que muestra los tags del usuario actual
class CRMUserTagsBadges extends ConsumerWidget {
  final int maxVisible;

  const CRMUserTagsBadges({
    super.key,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userTags = ref.watch(crmUserTagsProvider);

    if (userTags.isEmpty) return const SizedBox.shrink();

    final visibleTags = userTags.take(maxVisible).toList();
    final remaining = userTags.length - maxVisible;

    return Wrap(
      spacing: 6.h,
      runSpacing: 6.h,
      children: [
        ...visibleTags.map((tag) => _TagBadge(name: tag)),
        if (remaining > 0) _TagBadge(name: '+$remaining', isOverflow: true),
      ],
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String name;
  final bool isOverflow;

  const _TagBadge({
    required this.name,
    this.isOverflow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.h),
      decoration: BoxDecoration(
        color: isOverflow
            ? appTheme.blueGray100
            : FibroColors.secondaryTeal.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.h),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 11.fSize,
          fontWeight: FontWeight.w500,
          color: isOverflow ? appTheme.blueGray600 : FibroColors.secondaryTeal,
        ),
      ),
    );
  }
}

// ==================== FORMS WIDGETS ====================

/// Estado del formulario CRM
class CRMFormState {
  final Map<String, dynamic>? formData;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final bool submitted;

  const CRMFormState({
    this.formData,
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.submitted = false,
  });

  CRMFormState copyWith({
    Map<String, dynamic>? formData,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    bool? submitted,
  }) {
    return CRMFormState(
      formData: formData ?? this.formData,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      submitted: submitted ?? this.submitted,
    );
  }
}

/// Widget que muestra un formulario del CRM
class CRMDynamicForm extends ConsumerStatefulWidget {
  final String formId;
  final String? title;
  final Function(bool success)? onSubmit;

  const CRMDynamicForm({
    super.key,
    required this.formId,
    this.title,
    this.onSubmit,
  });

  @override
  ConsumerState<CRMDynamicForm> createState() => _CRMDynamicFormState();
}

class _CRMDynamicFormState extends ConsumerState<CRMDynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  bool _isLoading = true;
  bool _isSubmitting = false;
  Map<String, dynamic>? _formData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadForm();
  }

  Future<void> _loadForm() async {
    try {
      // Nota: El endpoint GET /forms/:id de GoHighLevel API v2 no está implementado en el servicio.
      // Cuando se agregue AgentCRMService.getForm(id), reemplazar esta simulación.
      // Por ahora usamos campos básicos comunes para formularios de registro.
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _formData = {
          'id': widget.formId,
          'name': widget.title ?? 'Formulario de Registro',
          'fields': [
            {
              'name': 'firstName',
              'label': 'Nombre',
              'type': 'text',
              'required': true
            },
            {
              'name': 'lastName',
              'label': 'Apellido',
              'type': 'text',
              'required': true
            },
            {
              'name': 'email',
              'label': 'Email',
              'type': 'email',
              'required': true
            },
            {
              'name': 'phone',
              'label': 'Teléfono',
              'type': 'phone',
              'required': false
            },
            {
              'name': 'message',
              'label': 'Mensaje',
              'type': 'textarea',
              'required': false
            },
          ],
        };
        _isLoading = false;

        // Crear controllers para cada campo
        for (var field in _formData!['fields'] as List) {
          _controllers[field['name']] = TextEditingController();
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar el formulario';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // Recopilar datos del formulario
      final data = <String, dynamic>{};
      for (var entry in _controllers.entries) {
        data[entry.key] = entry.value.text;
      }

      // Crear contacto en CRM con los datos del formulario
      final service = AgentCRMService.instance;
      final contact = await service.createContact(
        email: data['email'] ?? '',
        firstName: data['firstName'],
        lastName: data['lastName'],
        phone: data['phone'],
        tags: ['form-${widget.formId}', 'app-submission'],
      );

      setState(() => _isSubmitting = false);

      if (contact != null) {
        widget.onSubmit?.call(true);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('¡Formulario enviado correctamente!'),
              backgroundColor: FibroColors.secondaryTeal,
            ),
          );
        }
      } else {
        widget.onSubmit?.call(false);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _error = 'Error al enviar el formulario';
      });
      widget.onSubmit?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: FibroColors.primaryOrange,
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 12.h),
            Text(
              _error!,
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.red.shade500,
              ),
            ),
          ],
        ),
      );
    }

    if (_formData == null) return const SizedBox.shrink();

    final fields = _formData!['fields'] as List;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Text(
                widget.title!,
                style: TextStyle(
                  fontSize: 20.fSize,
                  fontWeight: FontWeight.bold,
                  color: appTheme.blueGray80001,
                ),
              ),
            ),
          ...fields.map((field) => _buildField(field)),
          SizedBox(height: 24.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: FibroColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.h),
                ),
                elevation: 2,
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 24.h,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Enviar',
                      style: TextStyle(
                        fontSize: 16.fSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(Map<String, dynamic> field) {
    final name = field['name'] as String;
    final label = field['label'] as String;
    final type = field['type'] as String;
    final required = field['required'] as bool? ?? false;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: _controllers[name],
        keyboardType: _getKeyboardType(type),
        maxLines: type == 'textarea' ? 4 : 1,
        decoration: InputDecoration(
          labelText: label + (required ? ' *' : ''),
          labelStyle: TextStyle(
            fontSize: 14.fSize,
            color: appTheme.blueGray600,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.blueGray100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: appTheme.blueGray100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: FibroColors.primaryOrange, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.h),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 14.h,
          ),
        ),
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Este campo es requerido';
          }
          if (type == 'email' && value != null && value.isNotEmpty) {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Ingresa un email válido';
            }
          }
          return null;
        },
      ),
    );
  }

  TextInputType _getKeyboardType(String type) {
    switch (type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'phone':
        return TextInputType.phone;
      case 'number':
        return TextInputType.number;
      case 'textarea':
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }
}

/// Widget para mostrar botón de formulario de contacto/inscripción
class CRMFormButton extends StatelessWidget {
  final String formId;
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const CRMFormButton({
    super.key,
    required this.formId,
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap ??
          () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => _FormBottomSheet(formId: formId),
            );
          },
      style: ElevatedButton.styleFrom(
        backgroundColor: FibroColors.primaryOrange,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        elevation: 3,
      ),
      icon: Icon(icon ?? Icons.edit_document, size: 20.h),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 15.fSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FormBottomSheet extends StatelessWidget {
  final String formId;

  const _FormBottomSheet({required this.formId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
      ),
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.h,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2.h),
            ),
          ),
          SizedBox(height: 24.h),
          CRMDynamicForm(
            formId: formId,
            title: 'Solicitar Información',
            onSubmit: (success) {
              if (success) {
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
