import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../clinics/clinics_screens.dart';
import '../clinics/data/mock_clinics.dart';
import '../doctors/doctors_screens.dart';
import 'appointment_booking_screens.dart';
import 'data/mock_appointments.dart';
import 'models/appointment_model.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentStatus _selectedStatus = AppointmentStatus.upcoming;
  late List<MockAppointment> _appointments = List.of(mockAppointments);

  List<MockAppointment> get _visibleAppointments => _appointments.where((appointment) => appointment.status == _selectedStatus).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('مواعيدي'), leading: const BackButton()),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('تابع مواعيدك الطبية بسهولة', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: AppSpacing.lg),
                  _AppointmentTabs(selected: _selectedStatus, onChanged: (status) => setState(() => _selectedStatus = status)),
                ])),
              ),
              if (_visibleAppointments.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _EmptyAppointments(status: _selectedStatus, onBook: _openDoctors))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    final appointment = _visibleAppointments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppointmentCard(
                        appointment: appointment,
                        onDetails: () => _openDetails(appointment),
                        onRebook: appointment.status == AppointmentStatus.completed ? () => _rebook(appointment) : null,
                      ),
                    );
                  }, childCount: _visibleAppointments.length)),
                ),
            ],
          ),
        ),
      );

  void _openDetails(MockAppointment appointment) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AppointmentDetailsScreen(appointment: appointment, onCancelled: () => _cancelAppointment(appointment))));
  }

  void _cancelAppointment(MockAppointment appointment) {
    setState(() {
      final index = _appointments.indexOf(appointment);
      if (index != -1) _appointments[index] = appointment.copyWith(status: AppointmentStatus.cancelled);
    });
  }

  void _rebook(MockAppointment appointment) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AppointmentBookingScreen(bookingData: _bookingData(appointment))));
  }

  void _openDoctors() => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DoctorsListScreen()));
}

class _AppointmentTabs extends StatelessWidget {
  const _AppointmentTabs({required this.selected, required this.onChanged});
  final AppointmentStatus selected;
  final ValueChanged<AppointmentStatus> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
        child: Row(children: [
          for (final item in const [(AppointmentStatus.upcoming, 'القادمة'), (AppointmentStatus.completed, 'المكتملة'), (AppointmentStatus.cancelled, 'الملغاة')])
            Expanded(child: GestureDetector(
              onTap: () => onChanged(item.$1),
              child: AnimatedContainer(duration: const Duration(milliseconds: 180), padding: const EdgeInsets.symmetric(vertical: 11), decoration: BoxDecoration(color: selected == item.$1 ? AppColors.primary : Colors.transparent, borderRadius: BorderRadius.circular(10)), child: Text(item.$2, textAlign: TextAlign.center, style: TextStyle(color: selected == item.$1 ? Colors.white : AppColors.muted, fontSize: 12, fontWeight: FontWeight.w700))),
            )),
        ]),
      );
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment, required this.onDetails, this.onRebook});
  final MockAppointment appointment;
  final VoidCallback onDetails;
  final VoidCallback? onRebook;

  @override
  Widget build(BuildContext context) {
    final status = _statusDetails(appointment.status);
    return AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        AppAvatar(initials: appointment.doctorInitials, size: 52, backgroundColor: appointment.avatarColor),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.doctorName, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(appointment.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600))])),
        StatusBadge(label: status.label, color: status.color),
      ]),
      const SizedBox(height: AppSpacing.md),
      _AppointmentMeta(icon: Icons.local_hospital_outlined, value: appointment.clinicName),
      const SizedBox(height: AppSpacing.xs),
      Row(children: [Expanded(child: _AppointmentMeta(icon: Icons.calendar_month_outlined, value: appointment.date)), const SizedBox(width: AppSpacing.sm), Expanded(child: _AppointmentMeta(icon: Icons.schedule_outlined, value: appointment.time))]),
      const SizedBox(height: AppSpacing.xs),
      _AppointmentMeta(icon: Icons.medical_services_outlined, value: appointment.type),
      const SizedBox(height: AppSpacing.md),
      Row(children: [Expanded(child: OutlinedButton(onPressed: onDetails, child: const Text('عرض التفاصيل'))), if (onRebook != null) ...[const SizedBox(width: AppSpacing.sm), Expanded(child: TextButton(onPressed: onRebook, child: const Text('إعادة الحجز')))]]),
    ]));
  }
}

class _AppointmentMeta extends StatelessWidget {
  const _AppointmentMeta({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: AppColors.primary, size: 17), const SizedBox(width: 6), Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)))]);
}

class AppointmentDetailsScreen extends StatefulWidget {
  const AppointmentDetailsScreen({super.key, required this.appointment, this.onCancelled});
  final MockAppointment appointment;
  final VoidCallback? onCancelled;

  @override
  State<AppointmentDetailsScreen> createState() => _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  late AppointmentStatus _status = widget.appointment.status;

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment.copyWith(status: _status);
    final status = _statusDetails(_status);
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الموعد'), leading: const BackButton()),
      body: SafeArea(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppCard(child: Row(children: [AppAvatar(initials: appointment.doctorInitials, size: 66, backgroundColor: appointment.avatarColor), const SizedBox(width: AppSpacing.md), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.doctorName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)), const SizedBox(height: 4), Text(appointment.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)), const SizedBox(height: AppSpacing.sm), TextButton(onPressed: () => _openDoctor(appointment), child: const Text('عرض الملف'))]))])),
        const SizedBox(height: AppSpacing.xl),
        Text('العيادة', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AppCard(child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.local_hospital_outlined, color: AppColors.primary, size: 25)), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.clinicName, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(appointment.location, style: Theme.of(context).textTheme.bodyMedium)])), IconButton(onPressed: () => _openClinic(appointment), icon: const Icon(Icons.chevron_left_rounded), color: AppColors.primary, tooltip: 'عرض العيادة')])),
        const SizedBox(height: AppSpacing.xl),
        Text('معلومات الموعد', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        AppCard(child: Column(children: [_DetailRow(label: 'التاريخ', value: appointment.date, icon: Icons.calendar_month_outlined), const Divider(height: AppSpacing.lg), _DetailRow(label: 'الوقت', value: appointment.time, icon: Icons.schedule_outlined), const Divider(height: AppSpacing.lg), _DetailRow(label: 'نوع الموعد', value: appointment.type, icon: Icons.medical_services_outlined), const Divider(height: AppSpacing.lg), _DetailRow(label: 'الحالة', value: status.label, icon: Icons.info_outline, valueColor: status.color)])),
        if (appointment.notes != null) ...[const SizedBox(height: AppSpacing.xl), Text('ملاحظات الموعد', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: AppSpacing.sm), AppCard(child: Text(appointment.notes!, style: Theme.of(context).textTheme.bodyLarge))],
        if (_status == AppointmentStatus.upcoming) ...[const SizedBox(height: AppSpacing.xl), SizedBox(width: double.infinity, child: PrimaryButton(label: 'تعديل الموعد', icon: Icons.edit_calendar_outlined, onPressed: null)), const SizedBox(height: AppSpacing.sm), SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _confirmCancellation, child: const Text('إلغاء الموعد')))],
      ])),
    );
  }

  void _openDoctor(MockAppointment appointment) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorDetailsScreen.preview(initials: appointment.doctorInitials, name: appointment.doctorName, specialty: appointment.specialty, clinic: appointment.clinicName, location: appointment.location, rating: '٤.٨', reviews: '٩٦', experience: 9, bio: 'رعاية طبية متخصصة بخطة واضحة واهتمام باحتياجات كل مراجع.', services: const ['الفحوصات العامة', 'الاستشارات', 'المتابعة'], color: appointment.avatarColor)));

  void _openClinic(MockAppointment appointment) {
    final clinic = clinics.where((item) => item.name == appointment.clinicName).firstOrNull;
    if (clinic != null) Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ClinicDetailsScreen(clinic: clinic)));
  }

  void _confirmCancellation() {
    showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('إلغاء الموعد'), content: const Text('هل تريد إلغاء هذا الموعد؟'), actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('العودة')), FilledButton(onPressed: () { Navigator.of(dialogContext).pop(); setState(() => _status = AppointmentStatus.cancelled); widget.onCancelled?.call(); }, child: const Text('إلغاء الموعد'))]));
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, required this.icon, this.valueColor});
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: AppColors.primary, size: 19)), const SizedBox(width: AppSpacing.sm), Text('$label: ', style: Theme.of(context).textTheme.bodyMedium), Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor ?? AppColors.ink, fontWeight: FontWeight.w700)))]);
}

class _EmptyAppointments extends StatelessWidget {
  const _EmptyAppointments({required this.status, required this.onBook});
  final AppointmentStatus status;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = status == AppointmentStatus.upcoming;
    return Center(child: Padding(padding: const EdgeInsets.all(AppSpacing.xl), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(width: 76, height: 76, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(24)), child: Icon(status == AppointmentStatus.completed ? Icons.task_alt_rounded : status == AppointmentStatus.cancelled ? Icons.event_busy_outlined : Icons.calendar_month_outlined, color: AppColors.primary, size: 35)), const SizedBox(height: AppSpacing.lg), Text(isUpcoming ? 'لا توجد مواعيد قادمة' : status == AppointmentStatus.completed ? 'لا توجد مواعيد مكتملة' : 'لا توجد مواعيد ملغاة', style: Theme.of(context).textTheme.titleMedium), if (isUpcoming) ...[const SizedBox(height: AppSpacing.xs), Text('يمكنك حجز موعد مع أحد الأطباء.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: AppSpacing.lg), SizedBox(width: 150, child: PrimaryButton(label: 'حجز موعد', icon: Icons.add, onPressed: onBook))]])));
  }
}

({String label, Color color}) _statusDetails(AppointmentStatus status) => switch (status) {
      AppointmentStatus.upcoming => (label: 'قادم', color: AppColors.primary),
      AppointmentStatus.completed => (label: 'مكتمل', color: AppColors.success),
      AppointmentStatus.cancelled => (label: 'ملغي', color: AppColors.muted),
    };

AppointmentBookingData _bookingData(MockAppointment appointment) => AppointmentBookingData(doctorName: appointment.doctorName, doctorInitials: appointment.doctorInitials, specialty: appointment.specialty, clinicName: appointment.clinicName, location: appointment.location, avatarColor: appointment.avatarColor);