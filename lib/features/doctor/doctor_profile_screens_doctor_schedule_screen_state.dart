part of 'doctor_profile_screens.dart';

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  int _selectedDay = 0;
  static const List<(String, String)> _days = [];
  static const List<(String, bool)> _slots = [];

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
                if (_days.isEmpty) const EmptyState(title: 'لا يوجد جدول متاح', message: 'لم يتم نشر جدول لهذا الطبيب بعد.') else SizedBox(
                  height: 76,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
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
                              Text(_days[index].$1, style: TextStyle(color: selected ? Colors.white : AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(_days[index].$2, style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 18, fontWeight: FontWeight.w800)),
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
                  children: [if (_slots.isNotEmpty) for (final slot in _slots) _ScheduleSlot(time: slot.$1, booked: slot.$2)],
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_slots.isNotEmpty) const Row(
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
}
