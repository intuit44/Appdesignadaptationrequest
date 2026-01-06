import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../core/providers/auth_state_provider.dart';
import '../../data/models/agent_crm_models.dart';
import '../../widgets/app_bar/appbar_leading_image.dart';
import '../../widgets/app_bar/appbar_title.dart';
import '../../widgets/app_bar/custom_app_bar.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final calendarsAsync = ref.watch(crmCalendarsProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.gray50,
        appBar: _buildAppBar(context),
        body: isAuthenticated
            ? _buildContent(calendarsAsync)
            : _buildLoginPrompt(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 40.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(left: 16.h),
        onTap: () => NavigatorService.goBack(),
      ),
      title: AppbarTitle(
        text: 'Citas y Calendarios',
        margin: EdgeInsets.only(left: 8.h),
      ),
      styleType: Style.bgFill,
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 80.h,
              color: appTheme.blueGray600,
            ),
            SizedBox(height: 24.h),
            Text(
              'Inicia sesión para ver tus citas',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            Text(
              'Programa citas en nuestros calendarios de talleres, consultas y capacitaciones.',
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () => _showSignInDialog(context),
              icon: const Icon(Icons.login),
              label: const Text('Iniciar Sesión'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FibroColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32.h, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignInDialog(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.mainScreen);
    // Navegar a la pantalla de cuenta que tiene el login
  }

  Widget _buildContent(AsyncValue<List<Map<String, dynamic>>> calendarsAsync) {
    return Column(
      children: [
        // Tabs
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: FibroColors.primaryOrange,
            unselectedLabelColor: appTheme.blueGray600,
            indicatorColor: FibroColors.primaryOrange,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Calendarios', icon: Icon(Icons.calendar_view_month)),
              Tab(text: 'Mis Citas', icon: Icon(Icons.event_note)),
            ],
          ),
        ),
        // Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCalendarsList(calendarsAsync),
              _buildMyAppointments(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarsList(
      AsyncValue<List<Map<String, dynamic>>> calendarsAsync) {
    return calendarsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.h, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Error al cargar calendarios'),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: () => ref.refresh(crmCalendarsProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      data: (calendars) => calendars.isEmpty
          ? _buildEmptyCalendars()
          : ListView.builder(
              padding: EdgeInsets.all(16.h),
              itemCount: calendars.length,
              itemBuilder: (context, index) =>
                  _buildCalendarCard(calendars[index]),
            ),
    );
  }

  Widget _buildEmptyCalendars() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64.h,
            color: appTheme.blueGray600,
          ),
          SizedBox(height: 16.h),
          Text(
            'No hay calendarios disponibles',
            style: TextStyle(
              fontSize: 16.fSize,
              color: appTheme.blueGray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(Map<String, dynamic> calendar) {
    final name = calendar['name'] ?? 'Calendario';
    final description = calendar['description'] ?? '';
    final isActive = calendar['isActive'] ?? true;
    final calendarType = calendar['calendarType'] ?? 'round_robin';

    IconData icon;
    Color color;

    // Asignar icono y color según el nombre/tipo
    if (name.toLowerCase().contains('taller')) {
      icon = Icons.work_outline;
      color = FibroColors.primaryOrange;
    } else if (name.toLowerCase().contains('consulta')) {
      icon = Icons.medical_services_outlined;
      color = FibroColors.secondaryTeal;
    } else if (name.toLowerCase().contains('capacitación') ||
        name.toLowerCase().contains('curso')) {
      icon = Icons.school_outlined;
      color = const Color(0xFF7E57C2);
    } else {
      icon = Icons.calendar_today;
      color = const Color(0xFF42A5F5);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.h),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.h),
          onTap: isActive ? () => _openCalendarBooking(calendar) : null,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Row(
              children: [
                // Icono
                Container(
                  width: 56.h,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.h),
                  ),
                  child: Icon(icon, size: 28.h, color: color),
                ),
                SizedBox(width: 16.h),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 16.fSize,
                                fontWeight: FontWeight.w600,
                                color: appTheme.blueGray80001,
                              ),
                            ),
                          ),
                          if (!isActive)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.h, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8.h),
                              ),
                              child: Text(
                                'Inactivo',
                                style: TextStyle(
                                  fontSize: 10.fSize,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (description.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13.fSize,
                            color: appTheme.blueGray600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            _getCalendarTypeIcon(calendarType),
                            size: 14.h,
                            color: appTheme.blueGray600,
                          ),
                          SizedBox(width: 4.h),
                          Text(
                            _getCalendarTypeLabel(calendarType),
                            style: TextStyle(
                              fontSize: 11.fSize,
                              color: appTheme.blueGray600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Flecha
                if (isActive)
                  Icon(
                    Icons.chevron_right,
                    color: appTheme.blueGray600,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCalendarTypeIcon(String type) {
    switch (type) {
      case 'round_robin':
        return Icons.group;
      case 'event':
        return Icons.event;
      case 'class_booking':
        return Icons.school;
      case 'collective':
        return Icons.groups;
      default:
        return Icons.calendar_today;
    }
  }

  String _getCalendarTypeLabel(String type) {
    switch (type) {
      case 'round_robin':
        return 'Asignación rotativa';
      case 'event':
        return 'Evento único';
      case 'class_booking':
        return 'Reserva de clase';
      case 'collective':
        return 'Colectivo';
      default:
        return 'Estándar';
    }
  }

  void _openCalendarBooking(Map<String, dynamic> calendar) {
    // Mostrar modal de reserva
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingBottomSheet(calendar: calendar),
    );
  }

  Widget _buildMyAppointments() {
    final appointmentsAsync = ref.watch(crmUserAppointmentsProvider);

    return appointmentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.h, color: Colors.red),
            SizedBox(height: 16.h),
            Text('Error al cargar tus citas'),
            SizedBox(height: 8.h),
            ElevatedButton(
              onPressed: () => ref.refresh(crmUserAppointmentsProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      data: (appointments) => appointments.isEmpty
          ? _buildEmptyAppointments()
          : ListView.builder(
              padding: EdgeInsets.all(16.h),
              itemCount: appointments.length,
              itemBuilder: (context, index) =>
                  _buildAppointmentCard(appointments[index]),
            ),
    );
  }

  Widget _buildEmptyAppointments() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64.h,
            color: appTheme.blueGray600,
          ),
          SizedBox(height: 16.h),
          Text(
            'No tienes citas programadas',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w600,
              color: appTheme.blueGray80001,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Explora nuestros calendarios y agenda tu primera cita',
            style: TextStyle(
              fontSize: 14.fSize,
              color: appTheme.blueGray600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => _tabController.animateTo(0),
            icon: const Icon(Icons.add),
            label: const Text('Ver Calendarios'),
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AgentCRMAppointment appointment) {
    final isPast = appointment.startTime?.isBefore(DateTime.now()) ?? true;
    final status = appointment.status ?? 'confirmed';

    Color statusColor;
    String statusLabel;

    switch (status) {
      case 'confirmed':
        statusColor = Colors.green;
        statusLabel = 'Confirmada';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusLabel = 'Pendiente';
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusLabel = 'Cancelada';
        break;
      case 'completed':
        statusColor = Colors.blue;
        statusLabel = 'Completada';
        break;
      default:
        statusColor = Colors.grey;
        statusLabel = status;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isPast ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16.h),
        border: Border.all(
          color: isPast ? Colors.grey.shade300 : Colors.transparent,
        ),
        boxShadow: isPast
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título y status
            Row(
              children: [
                Expanded(
                  child: Text(
                    appointment.title,
                    style: TextStyle(
                      fontSize: 16.fSize,
                      fontWeight: FontWeight.w600,
                      color: isPast
                          ? appTheme.blueGray600
                          : appTheme.blueGray80001,
                    ),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      fontSize: 11.fSize,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Fecha y hora
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16.h,
                  color:
                      isPast ? appTheme.blueGray600 : FibroColors.primaryOrange,
                ),
                SizedBox(width: 8.h),
                Text(
                  _formatDate(appointment.startTime),
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color:
                        isPast ? appTheme.blueGray600 : appTheme.blueGray80001,
                  ),
                ),
                SizedBox(width: 16.h),
                Icon(
                  Icons.access_time,
                  size: 16.h,
                  color:
                      isPast ? appTheme.blueGray600 : FibroColors.secondaryTeal,
                ),
                SizedBox(width: 8.h),
                Text(
                  '${_formatTime(appointment.startTime)} - ${_formatTime(appointment.endTime)}',
                  style: TextStyle(
                    fontSize: 14.fSize,
                    color:
                        isPast ? appTheme.blueGray600 : appTheme.blueGray80001,
                  ),
                ),
              ],
            ),
            if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                appointment.notes!,
                style: TextStyle(
                  fontSize: 13.fSize,
                  color: appTheme.blueGray600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--';
    const months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '--:--';
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

/// Bottom sheet para reservar cita
class _BookingBottomSheet extends StatelessWidget {
  final Map<String, dynamic> calendar;

  const _BookingBottomSheet({required this.calendar});

  Future<void> _showDateTimePicker(
      BuildContext context, String calendarId, String calendarName) async {
    // Seleccionar fecha
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FibroColors.primaryOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: appTheme.blueGray80001,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null || !context.mounted) return;

    // Seleccionar hora
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FibroColors.primaryOrange,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: appTheme.blueGray80001,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime == null || !context.mounted) return;

    // Combinar fecha y hora
    final DateTime appointmentDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    // Mostrar confirmación
    _showConfirmationDialog(
        context, calendarId, calendarName, appointmentDateTime);
  }

  void _showConfirmationDialog(BuildContext context, String calendarId,
      String calendarName, DateTime dateTime) {
    final formattedDate = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        title: Row(
          children: [
            Icon(Icons.event_available, color: FibroColors.secondaryTeal),
            SizedBox(width: 8.h),
            const Text('Confirmar Cita'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              calendarName,
              style: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            _buildConfirmRow(Icons.calendar_today, 'Fecha', formattedDate),
            SizedBox(height: 8.h),
            _buildConfirmRow(Icons.access_time, 'Hora', formattedTime),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: appTheme.blueGray600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Aquí se integraría con el API de GoHighLevel para crear la cita
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      SizedBox(width: 8.h),
                      const Text('¡Cita reservada exitosamente!'),
                    ],
                  ),
                  backgroundColor: FibroColors.secondaryTeal,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FibroColors.primaryOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.h, color: FibroColors.secondaryTeal),
        SizedBox(width: 8.h),
        Text('$label: ', style: TextStyle(color: appTheme.blueGray600)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = calendar['name'] ?? 'Calendario';
    final description = calendar['description'] ?? '';
    final calendarId = calendar['id'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.h)),
      ),
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40.h,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.h),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          // Título
          Text(
            name,
            style: TextStyle(
              fontSize: 20.fSize,
              fontWeight: FontWeight.bold,
              color: appTheme.blueGray80001,
            ),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.fSize,
                color: appTheme.blueGray600,
              ),
            ),
          ],
          SizedBox(height: 24.h),
          // Info
          _buildInfoRow(Icons.access_time, 'Duración', '30 - 60 minutos'),
          SizedBox(height: 12.h),
          _buildInfoRow(
              Icons.location_on_outlined, 'Ubicación', 'Presencial / Virtual'),
          SizedBox(height: 24.h),
          // Botón de reserva
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _showDateTimePicker(context, calendarId, name);
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Seleccionar Fecha y Hora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FibroColors.primaryOrange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.h),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20.h, color: FibroColors.secondaryTeal),
        SizedBox(width: 12.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.fSize,
                color: appTheme.blueGray600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.fSize,
                fontWeight: FontWeight.w500,
                color: appTheme.blueGray80001,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
