import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'organization_clinics_screen.dart';
import 'organization_doctors_screen.dart';
import 'organization_profile_screens.dart';

class OrganizationHomeScreen extends StatefulWidget {
  const OrganizationHomeScreen({super.key});

  @override
  State<OrganizationHomeScreen> createState() => _OrganizationHomeScreenState();
}

class _OrganizationHomeScreenState extends State<OrganizationHomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _OrganizationDashboard(onTabSelected: (index) => setState(() => _selectedTab = index)),
              const OrganizationClinicsScreen(),
              const OrganizationDoctorsScreen(),
              const OrganizationProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: RoleBottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => setState(() => _selectedTab = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.local_hospital_outlined), selectedIcon: Icon(Icons.local_hospital), label: 'العيادات'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'الأطباء'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'الملف الشخصي'),
          ],
        ),
      );
}

class _OrganizationDashboard extends StatelessWidget {
  const _OrganizationDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverList(delegate: SliverChildListDelegate([
              const Row(children: [
                AppAvatar(initials: 'م م', size: 52, backgroundColor: AppColors.sky),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحباً بك في Medicare', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  SizedBox(height: 3),
                  Text('مؤسسة Medicare الطبية', style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.45)),
                ])),
              ]),
              const SizedBox(height: AppSpacing.xl),
              Text('ملخص الإدارة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const _SummaryGrid(),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'العيادات', actionLabel: 'عرض جميع العيادات', onAction: () => onTabSelected(1)),
              const SizedBox(height: AppSpacing.sm),
              for (final clinic in mockOrganizationClinics.take(2)) ...[
                _ClinicPreviewCard(clinic: clinic, onTap: () => onTabSelected(1)),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'الأطباء', actionLabel: 'عرض جميع الأطباء', onAction: () => onTabSelected(2)),
              const SizedBox(height: AppSpacing.sm),
              for (final doctor in mockOrganizationDoctors.take(2)) ...[
                _DoctorPreviewCard(doctor: doctor, onTap: () => onTabSelected(2)),
                const SizedBox(height: AppSpacing.sm),
              ],
            ])),
          ),
        ],
      );
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _SummaryCard(width: width, label: 'عدد العيادات', value: '٦', icon: Icons.local_hospital_outlined, color: AppColors.sky),
          _SummaryCard(width: width, label: 'عدد الأطباء', value: '٣٢', icon: Icons.medical_information_outlined, color: AppColors.mint),
          _SummaryCard(width: width, label: 'عدد المرضى', value: '٨٤٠', icon: Icons.people_outline, color: AppColors.peach),
          _SummaryCard(width: width, label: 'مواعيد اليوم', value: '١٨', icon: Icons.calendar_month_outlined, color: AppColors.mint),
        ]);
      });
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.width, required this.label, required this.value, required this.icon, required this.color});
  final double width;
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, child: AppCard(padding: const EdgeInsets.all(AppSpacing.md), child: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primaryDark, size: 19)), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20)), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium)])]))));
}

class _ClinicPreviewCard extends StatelessWidget {
  const _ClinicPreviewCard({required this.clinic, required this.onTap});
  final OrganizationClinic clinic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: clinic.color, borderRadius: BorderRadius.circular(15)), child: Icon(clinic.icon, color: AppColors.primaryDark, size: 24)), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(clinic.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(clinic.location, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 3), Text('${clinic.doctorsCount} أطباء', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))])), StatusBadge(label: clinic.status, color: AppColors.success)])));
}

class _DoctorPreviewCard extends StatelessWidget {
  const _DoctorPreviewCard({required this.doctor, required this.onTap});
  final OrganizationDoctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Row(children: [AppAvatar(initials: doctor.initials, size: 48, backgroundColor: doctor.avatarColor), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doctor.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(doctor.clinic, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium)])), StatusBadge(label: doctor.status, color: doctor.status == 'نشط' ? AppColors.success : AppColors.muted)])));
}
