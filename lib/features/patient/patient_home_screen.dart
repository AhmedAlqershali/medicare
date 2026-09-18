import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../clinics/clinics_screens.dart';
import '../doctors/doctors_screens.dart';
import '../appointments/appointments_screens.dart';
import 'patient_profile_screens.dart';
import 'widgets/patient_appointment_card.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _HomeContent(onBook: () {}),
              const AppointmentsScreen(),
              const DoctorsListScreen(),
              const PatientProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: AppBottomNavigationBar(currentIndex: _selectedTab, onTap: (index) => setState(() => _selectedTab = index)),
      );
}

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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AppAvatar(initials: 'س', size: 50),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('صباح الخير، سارة', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 3),
          Text('نتمنى لك يوماً صحياً ومليئاً بالعافية', style: Theme.of(context).textTheme.bodyMedium),
        ])),
        IconButton(
          onPressed: _noop,
          icon: const Icon(Icons.notifications_none_rounded, size: 23),
          color: AppColors.ink,
          tooltip: 'الإشعارات',
          visualDensity: VisualDensity.compact,
        ),
      ]);

  static void _noop() {}
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onBook, required this.onClinics});
  final VoidCallback onBook;
  final VoidCallback onClinics;

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
        childAspectRatio: 2.55,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _QuickAction(label: 'حجز موعد', icon: Icons.add_circle_outline, color: AppColors.mint, onTap: onBook),
          _QuickAction(label: 'الأطباء', icon: Icons.medical_services_outlined, color: AppColors.sky, onTap: _noop),
          _QuickAction(label: 'مواعيدي', icon: Icons.event_available_outlined, color: AppColors.peach, onTap: _noop),
          _QuickAction(label: 'العيادات', icon: Icons.local_hospital_outlined, color: const Color(0xFFEDEAF7), onTap: onClinics),
        ],
      );

  static void _noop() {}
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.label, required this.icon, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Container(width: 38, height: 38, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primaryDark, size: 20)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700))),
              const Icon(Icons.chevron_left_rounded, color: AppColors.muted, size: 19),
            ]),
          ),
        ),
      );
}

class _DoctorsSection extends StatelessWidget {
  const _DoctorsSection();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 188,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: const [
            _DoctorCard(initials: 'ل س', name: 'د. ليان السالم', specialty: 'طب الأطفال', clinic: 'مركز الحياة', color: AppColors.peach),
            SizedBox(width: AppSpacing.sm),
            _DoctorCard(initials: 'ر ح', name: 'د. ريم الحربي', specialty: 'طب الأسرة', clinic: 'عيادات النخبة', color: AppColors.sky),
            SizedBox(width: AppSpacing.sm),
            _DoctorCard(initials: 'ن ع', name: 'د. ناصر العتيبي', specialty: 'طب العيون', clinic: 'مركز النور', color: AppColors.mint),
          ],
        ),
      );
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.initials, required this.name, required this.specialty, required this.clinic, required this.color});
  final String initials;
  final String name;
  final String specialty;
  final String clinic;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 198,
        child: AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              AppAvatar(initials: initials, size: 44, backgroundColor: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14))),
            ]),
            const SizedBox(height: AppSpacing.sm),
            Text(specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(clinic, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Row(children: [
              const Icon(Icons.circle, color: AppColors.success, size: 7),
              const SizedBox(width: 5),
              Text('متاحة اليوم', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
          ]),
        ),
      );
}

class _ClinicsSection extends StatelessWidget {
  const _ClinicsSection();

  @override
  Widget build(BuildContext context) => Column(children: const [
        ClinicCard(name: 'عيادات النخبة', location: 'حي العليا • رعاية متعددة التخصصات'),
        SizedBox(height: AppSpacing.sm),
        ClinicCard(name: 'مركز الحياة الطبي', location: 'حي المروج • طب الأطفال والأسرة'),
      ]);
}

class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.title, required this.icon, required this.message});
  final String title;
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 76, height: 76, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(24)), child: Icon(icon, color: AppColors.primary, size: 34)),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
          ]),
        ),
      );
}
