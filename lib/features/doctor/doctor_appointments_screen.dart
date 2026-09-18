import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'data/mock_doctor_appointments.dart';
import 'models/doctor_appointment.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  const DoctorAppointmentsScreen({super.key});

  @override
  State<DoctorAppointmentsScreen> createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  DoctorAppointmentFilter _selectedFilter = DoctorAppointmentFilter.today;
  late List<DoctorAppointment> _appointments = List.of(doctorAppointments);

  @override
  Widget build(BuildContext context) {
    final visible = _appointments.where((item) => item.status == _selectedFilter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('مواعيدي')),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('نظّم جدولك وتابع مرضاك بسهولة', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.lg),
                    _FilterTabs(
                      selected: _selectedFilter,
                      onChanged: (filter) => setState(() => _selectedFilter = filter),
                    ),
                  ],
                ),
              ),
            ),
            if (visible.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  title: 'لا توجد مواعيد',
                  message: 'ستظهر المواعيد هنا عند توفرها.',
                  icon: Icons.event_available_outlined,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final appointment = visible[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _DoctorAppointmentCard(
                          appointment: appointment,
                          onDetails: () => _openDetails(appointment),
                        ),
                      );
                    },
                    childCount: visible.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openDetails(DoctorAppointment appointment) async {
    final updated = await Navigator.of(context).push<DoctorAppointment>(MaterialPageRoute(builder: (_) => DoctorAppointmentDetailsScreen(appointment: appointment)));
    if (updated != null && mounted) setState(() { final index = _appointments.indexOf(appointment); if (index != -1) _appointments[index] = updated; });
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs({required this.selected, required this.onChanged});
  final DoctorAppointmentFilter selected;
  final ValueChanged<DoctorAppointmentFilter> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            for (final item in const [
              (DoctorAppointmentFilter.today, 'اليوم'),
              (DoctorAppointmentFilter.upcoming, 'القادمة'),
              (DoctorAppointmentFilter.completed, 'المكتملة'),
              (DoctorAppointmentFilter.cancelled, 'الملغاة'),
            ])
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(item.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: selected == item.$1 ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.$2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected == item.$1 ? Colors.white : AppColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}

class _DoctorAppointmentCard extends StatelessWidget {
  const _DoctorAppointmentCard({required this.appointment, required this.onDetails});
  final DoctorAppointment appointment;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) => AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [AppAvatar(initials: appointment.patientInitials, size: 52, backgroundColor: appointment.avatarColor), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.patientName, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text('${appointment.age}  •  ${appointment.gender}', style: Theme.of(context).textTheme.bodyMedium)])), StatusBadge(label: appointment.statusLabel, color: appointment.statusColor)]), const SizedBox(height: AppSpacing.md), Row(children: [Expanded(child: _Meta(icon: Icons.calendar_month_outlined, value: appointment.date)), const SizedBox(width: AppSpacing.sm), Expanded(child: _Meta(icon: Icons.schedule_outlined, value: appointment.time))]), const SizedBox(height: AppSpacing.xs), _Meta(icon: Icons.medical_services_outlined, value: appointment.type), const SizedBox(height: AppSpacing.md), SizedBox(width: double.infinity, child: OutlinedButton(onPressed: onDetails, child: const Text('عرض التفاصيل')))]));
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: AppColors.primary, size: 17), const SizedBox(width: 6), Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)))]);
}

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  const DoctorAppointmentDetailsScreen({super.key, required this.appointment});
  final DoctorAppointment appointment;

  @override
  State<DoctorAppointmentDetailsScreen> createState() => _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState extends State<DoctorAppointmentDetailsScreen> {
  late DoctorAppointmentFilter _status = widget.appointment.status;

  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment.copyWith(status: _status);
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الموعد')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                child: Row(
                  children: [
                    AppAvatar(initials: appointment.patientInitials, size: 68, backgroundColor: appointment.avatarColor),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appointment.patientName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                          const SizedBox(height: 5),
                          Text('${appointment.age}  •  ${appointment.gender}', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: AppSpacing.sm),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const _DoctorPatientPreviewScreen())),
                            child: const Text('عرض ملف المريض'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('معلومات الموعد', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(
                  children: [
                    _DetailRow(label: 'التاريخ', value: appointment.date, icon: Icons.calendar_month_outlined),
                    const Divider(height: AppSpacing.lg),
                    _DetailRow(label: 'الوقت', value: appointment.time, icon: Icons.schedule_outlined),
                    const Divider(height: AppSpacing.lg),
                    _DetailRow(label: 'نوع الموعد', value: appointment.type, icon: Icons.medical_services_outlined),
                    const Divider(height: AppSpacing.lg),
                    _DetailRow(label: 'الحالة', value: appointment.statusLabel, icon: Icons.info_outline, valueColor: appointment.statusColor),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('ملاحظات الموعد', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(child: Text(appointment.notes, style: Theme.of(context).textTheme.bodyLarge)),
              if (_status == DoctorAppointmentFilter.today || _status == DoctorAppointmentFilter.upcoming) ...[
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'تأكيد الموعد',
                    icon: Icons.check_rounded,
                    onPressed: () => setState(() => _status = DoctorAppointmentFilter.upcoming),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _status = DoctorAppointmentFilter.cancelled),
                        child: const Text('إلغاء الموعد'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => setState(() => _status = DoctorAppointmentFilter.completed),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('بدء الموعد'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value, required this.icon, this.valueColor});
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: AppColors.primary, size: 19),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('$label: ', style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: valueColor ?? AppColors.ink, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      );
}

class _DoctorPatientPreviewScreen extends StatelessWidget {
  const _DoctorPatientPreviewScreen();

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('ملف المريض')), body: const Center(child: Text('تفاصيل المريض متاحة من قائمة المرضى')));
}