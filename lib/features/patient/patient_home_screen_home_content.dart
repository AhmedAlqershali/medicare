part of 'patient_home_screen.dart';

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.onBook});
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _HomeHeader(),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(title: 'موعدك القادم', actionLabel: 'عرض الكل', onAction: _noop),
                const SizedBox(height: AppSpacing.sm),
                PatientAppointmentCard(onView: _noop),
                const SizedBox(height: AppSpacing.xl),
                Text('كيف نساعدك اليوم؟', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17)),
                const SizedBox(height: AppSpacing.md),
                _QuickActions(onBook: onBook, onClinics: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const ClinicsListScreen()))),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(title: 'أطباء مقترحون', actionLabel: 'عرض الكل', onAction: _noop),
                const SizedBox(height: AppSpacing.sm),
                const _DoctorsSection(),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(title: 'اكتشف العيادات', actionLabel: 'عرض الكل', onAction: _noop),
                const SizedBox(height: AppSpacing.sm),
                const _ClinicsSection(),
                const SizedBox(height: AppSpacing.lg),
              ]),
            ),
          ),
        ],
      );

  static void _noop() {}
}
