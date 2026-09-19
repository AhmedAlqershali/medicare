part of 'doctor_appointments_screen.dart';

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
