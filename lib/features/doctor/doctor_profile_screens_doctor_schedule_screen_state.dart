part of 'doctor_profile_screens.dart';

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  int _selectedDay = 0;
  Map<String, List<String>> _availability = const {};
  Set<String> _bookedSlots = const {};
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    final doctorId = FirebaseAuthRepository.instance.session.doctorId;
    if (doctorId == null || doctorId.isEmpty) {
      if (mounted) setState(() => _error = 'لا توجد جلسة طبيب نشطة.');
      return;
    }
    try {
      final doctor = await FirestoreDoctorRepository.instance.fetchDoctorById(doctorId);
      final organizationId = FirebaseAuthRepository.instance.session.organizationId;
      final appointments = organizationId == null
          ? const <Map<String, dynamic>>[]
          : await FirestoreAppointmentRepository.instance.fetchAppointmentsForDoctor(organizationId: organizationId, doctorId: doctorId);
      if (!mounted) return;
      setState(() {
        _availability = doctor?.availability ?? const {};
        _bookedSlots = appointments.map((appointment) => '${appointment['date'] ?? ''}|${appointment['time'] ?? ''}').toSet();
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الجدول')),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('جدول مواعيدك لهذا الأسبوع', style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: AppSpacing.lg),
                if (_error != null) ErrorState(message: _error!, onRetry: _loadSchedule)
                else if (_availability.isEmpty) const EmptyState(title: 'لا يوجد جدول متاح', message: 'لم يتم نشر جدول لهذا الطبيب بعد.') else SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availability.length,
                    separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final selected = _selectedDay == index;
                      return InkWell(
                        onTap: () => setState(() => _selectedDay = index),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 76,
                          decoration: BoxDecoration(
                            color: selected ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_availability.keys.elementAt(index), style: TextStyle(color: selected ? Colors.white : AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('${_availability.values.elementAt(index).length}', style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 18, fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'ساعات العمل'),
                const SizedBox(height: AppSpacing.sm),
                const AppCard(
                  child: Row(
                    children: [
                      Icon(Icons.access_time_outlined, color: AppColors.primary),
                      SizedBox(width: AppSpacing.sm),
                      Text('لا توجد ساعات عمل منشورة', style: TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'الفترات المتاحة'),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [for (final slot in _selectedSlots) _ScheduleSlot(time: slot, booked: _bookedSlots.contains('${_availability.keys.elementAt(_selectedDay)}|$slot'))],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_selectedSlots.isNotEmpty) const Row(
                  children: [
                    _Legend(color: AppColors.primary, label: 'محجوز'),
                    SizedBox(width: AppSpacing.lg),
                    _Legend(color: AppColors.mint, label: 'متاح'),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      List<String> get _selectedSlots => _availability.isEmpty ? const [] : _availability.values.elementAt(_selectedDay);
}
