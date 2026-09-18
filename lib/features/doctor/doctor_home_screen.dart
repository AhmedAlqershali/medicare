import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_patients_screen.dart';
import 'doctor_profile_screens.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedTab,
            children: [
              _DoctorDashboard(onTabSelected: (index) => setState(() => _selectedTab = index)),
              const DoctorAppointmentsScreen(),
              const DoctorPatientsScreen(),
              const DoctorProfileScreen(),
            ],
          ),
        ),
        bottomNavigationBar: RoleBottomNavigationBar(
          currentIndex: _selectedTab,
          onTap: (index) => setState(() => _selectedTab = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'المواعيد'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'المرضى'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'الملف الشخصي'),
          ],
        ),
      );
}

class _DoctorDashboard extends StatelessWidget {
  const _DoctorDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Row(children: [
                const AppAvatar(initials: 'أ ح', size: 52, backgroundColor: AppColors.sky),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحباً د. أحمد', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text('إليك ملخص يومك الطبي', style: Theme.of(context).textTheme.bodyMedium),
                ])),
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded), tooltip: 'الإشعارات'),
              ]),
              const SizedBox(height: AppSpacing.xl),
              Text('نظرة اليوم', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const _OverviewGrid(),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'مواعيد اليوم', actionLabel: 'عرض الكل', onAction: () => onTabSelected(1)),
              const SizedBox(height: AppSpacing.sm),
              for (final appointment in doctorAppointments.take(3)) ...[
                _DashboardAppointmentCard(appointment: appointment, onDetails: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorAppointmentDetailsScreen(appointment: appointment)))),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
              Text('إجراءات سريعة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _QuickActions(onTabSelected: onTabSelected),
            ])),
          ),
        ],
      );
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _OverviewCard(width: width, label: 'مواعيد اليوم', value: '٨', icon: Icons.calendar_today_outlined, color: AppColors.sky),
          _OverviewCard(width: width, label: 'المرضى', value: '١٢٤', icon: Icons.people_outline, color: AppColors.mint),
          _OverviewCard(width: width, label: 'المواعيد القادمة', value: '١٦', icon: Icons.upcoming_outlined, color: AppColors.peach),
          _OverviewCard(width: width, label: 'المواعيد المكتملة', value: '٣٦', icon: Icons.task_alt_outlined, color: AppColors.mint),
        ]);
      });
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({required this.width, required this.label, required this.value, required this.icon, required this.color});
  final double width;
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => SizedBox(width: width, child: AppCard(padding: const EdgeInsets.all(AppSpacing.md), child: Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primaryDark, size: 19)), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20)), Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium)])])));
}

class _DashboardAppointmentCard extends StatelessWidget {
  const _DashboardAppointmentCard({required this.appointment, required this.onDetails});
  final DoctorAppointment appointment;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) => AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [AppAvatar(initials: appointment.patientInitials, size: 48, backgroundColor: appointment.avatarColor), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(appointment.patientName, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text('${appointment.time}  •  ${appointment.type}', style: Theme.of(context).textTheme.bodyMedium)])), StatusBadge(label: appointment.statusLabel, color: appointment.statusColor)]), const SizedBox(height: AppSpacing.xs), Align(alignment: AlignmentDirectional.centerStart, child: TextButton(onPressed: onDetails, child: const Text('عرض التفاصيل')))]));
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) => Row(children: [
        Expanded(child: _Action(icon: Icons.calendar_month_outlined, label: 'مواعيدي', onTap: () => onTabSelected(1))),
        Expanded(child: _Action(icon: Icons.people_outline, label: 'المرضى', onTap: () => onTabSelected(2))),
        Expanded(child: _Action(icon: Icons.schedule_outlined, label: 'الجدول', onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DoctorScheduleScreen())))),
        Expanded(child: _Action(icon: Icons.person_outline, label: 'الملف الشخصي', onTap: () => onTabSelected(3))),
      ]);
}

class _Action extends StatelessWidget {
  const _Action({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Padding(padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm), child: Column(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: AppColors.primary, size: 22)), const SizedBox(height: 6), Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600, fontSize: 11))])));
}