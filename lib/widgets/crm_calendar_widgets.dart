/// Widgets para mostrar calendarios y eventos del CRM
/// Conecta los providers de Agent CRM Calendars con la UI
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/app_export.dart';
import '../data/models/agent_crm_models.dart';
import '../data/services/hybrid_auth_service.dart';

/// Widget que muestra un calendario del CRM
class CRMCalendarCard extends StatelessWidget {
  final Map<String, dynamic> calendar;
  final VoidCallback? onTap;

  const CRMCalendarCard({
    super.key,
    required this.calendar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = calendar['name'] ?? 'Calendario';
    final description = calendar['description'] ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icono
            Container(
              width: 48.h,
              height: 48.h,
              decoration: BoxDecoration(
                color: FibroColors.primaryOrange.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.h),
              ),
              child: Icon(
                Icons.calendar_month,
                size: 24.h,
                color: FibroColors.primaryOrange,
              ),
            ),
            SizedBox(width: 16.h),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blueGray80001,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.fSize,
                        color: appTheme.blueGray600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: appTheme.blueGray600,
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget que muestra una cita/evento del CRM
class CRMAppointmentCard extends StatelessWidget {
  final AgentCRMAppointment appointment;
  final VoidCallback? onTap;

  const CRMAppointmentCard({
    super.key,
    required this.appointment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.h),
          border: Border.all(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      fontSize: 11.fSize,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
                const Spacer(),
                if (appointment.startTime != null)
                  Text(
                    DateFormat('EEE, d MMM', 'es')
                        .format(appointment.startTime!),
                    style: TextStyle(
                      fontSize: 12.fSize,
                      fontWeight: FontWeight.w500,
                      color: appTheme.blueGray600,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            // Título
            Text(
              appointment.title,
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 8.h),
            // Hora
            if (appointment.startTime != null)
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16.h,
                    color: appTheme.blueGray600,
                  ),
                  SizedBox(width: 6.h),
                  Text(
                    _formatTimeRange(),
                    style: TextStyle(
                      fontSize: 13.fSize,
                      color: appTheme.blueGray600,
                    ),
                  ),
                ],
              ),
            // Notas
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                appointment.notes!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.fSize,
                  color: appTheme.blueGray600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (appointment.status?.toLowerCase()) {
      case 'confirmed':
        return FibroColors.secondaryTeal;
      case 'cancelled':
        return Colors.red;
      case 'showed':
        return Colors.green;
      case 'noshow':
        return Colors.orange;
      default:
        return appTheme.blueGray700;
    }
  }

  String _getStatusLabel() {
    switch (appointment.status?.toLowerCase()) {
      case 'confirmed':
        return 'Confirmado';
      case 'cancelled':
        return 'Cancelado';
      case 'showed':
        return 'Asistió';
      case 'noshow':
        return 'No asistió';
      default:
        return 'Pendiente';
    }
  }

  String _formatTimeRange() {
    final format = DateFormat('h:mm a');
    final start = appointment.startTime != null
        ? format.format(appointment.startTime!)
        : '';
    final end =
        appointment.endTime != null ? format.format(appointment.endTime!) : '';
    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }
    return start;
  }
}

/// Widget que muestra los calendarios disponibles del CRM
class CRMCalendarsList extends ConsumerWidget {
  final Function(Map<String, dynamic>)? onCalendarTap;

  const CRMCalendarsList({
    super.key,
    this.onCalendarTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarsAsync = ref.watch(crmCalendarsProvider);

    return calendarsAsync.when(
      data: (calendars) {
        if (calendars.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16.h),
          itemCount: calendars.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return CRMCalendarCard(
              calendar: calendars[index],
              onTap: () => onCalendarTap?.call(calendars[index]),
            );
          },
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, _) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            height: 80.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.h),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 48.h,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12.h),
            Text(
              'No hay calendarios disponibles',
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 12.h),
            Text(
              'Error al cargar calendarios',
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.red.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget que muestra las próximas citas del usuario
class CRMUserAppointments extends ConsumerWidget {
  final String? title;
  final Function(AgentCRMAppointment)? onAppointmentTap;
  final int maxItems;

  const CRMUserAppointments({
    super.key,
    this.title,
    this.onAppointmentTap,
    this.maxItems = 5,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isHybridAuthenticatedProvider);
    final appointmentsAsync = ref.watch(crmUserAppointmentsProvider);

    if (!isAuthenticated) {
      return _buildNotAuthenticatedState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 20.fSize,
                fontWeight: FontWeight.bold,
                color: appTheme.blueGray80001,
              ),
            ),
          ),
        SizedBox(height: 12.h),
        appointmentsAsync.when(
          data: (appointments) {
            if (appointments.isEmpty) {
              return _buildEmptyState();
            }

            // Ordenar por fecha y tomar solo las próximas
            final upcoming = appointments
                .where((a) =>
                    a.startTime != null &&
                    a.startTime!.isAfter(
                        DateTime.now().subtract(const Duration(hours: 1))))
                .toList()
              ..sort((a, b) => a.startTime!.compareTo(b.startTime!));

            final items = upcoming.take(maxItems).toList();

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return CRMAppointmentCard(
                  appointment: items[index],
                  onTap: () => onAppointmentTap?.call(items[index]),
                );
              },
            );
          },
          loading: () => _buildLoadingState(),
          error: (error, _) => _buildErrorState(error.toString()),
        ),
      ],
    );
  }

  Widget _buildNotAuthenticatedState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          children: [
            Icon(
              Icons.login,
              size: 48.h,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12.h),
            Text(
              'Inicia sesión para ver tus citas',
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: Column(
        children: List.generate(
          2,
          (index) => Container(
            height: 100.h,
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16.h),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          children: [
            Icon(
              Icons.event_available,
              size: 48.h,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 12.h),
            Text(
              'No tienes citas programadas',
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Explora nuestros cursos y agenda tu próxima sesión',
              style: TextStyle(
                fontSize: 12.fSize,
                color: Colors.grey.shade400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 12.h),
            Text(
              'Error al cargar citas',
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.red.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sección compacta de calendarios y próximos eventos para el Home
class CRMCalendarSection extends ConsumerWidget {
  final String? title;

  const CRMCalendarSection({
    super.key,
    this.title = 'Próximos Eventos',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarsAsync = ref.watch(crmCalendarsProvider);

    return calendarsAsync.when(
      data: (calendars) {
        if (calendars.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 20.fSize,
                      fontWeight: FontWeight.bold,
                      color: appTheme.blueGray80001,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      NavigatorService.pushNamed(AppRoutes.appointmentsScreen);
                    },
                    child: Text(
                      'Ver todos',
                      style: TextStyle(
                        fontSize: 14.fSize,
                        color: FibroColors.primaryOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 100.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                scrollDirection: Axis.horizontal,
                itemCount: calendars.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.h),
                itemBuilder: (context, index) {
                  final calendar = calendars[index];
                  return _CalendarChip(
                    name: calendar['name'] ?? 'Calendario',
                    onTap: () {
                      NavigatorService.pushNamed(AppRoutes.appointmentsScreen);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _CalendarChip extends StatelessWidget {
  final String name;
  final VoidCallback? onTap;

  const _CalendarChip({
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160.h,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              FibroColors.primaryOrange,
              FibroColors.orangeDark,
            ],
          ),
          borderRadius: BorderRadius.circular(16.h),
          boxShadow: [
            BoxShadow(
              color: FibroColors.primaryOrange.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 20.h,
            ),
            SizedBox(height: 6.h),
            Flexible(
              child: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.fSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
