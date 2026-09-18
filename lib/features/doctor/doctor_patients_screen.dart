import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'data/mock_doctor_patients.dart';
import 'models/doctor_patient.dart';

class DoctorPatientsScreen extends StatefulWidget {
  const DoctorPatientsScreen({super.key});

  @override
  State<DoctorPatientsScreen> createState() => _DoctorPatientsScreenState();
}

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final patients = doctorPatients.where((patient) => patient.name.contains(_query.trim()) || patient.status.contains(_query.trim())).toList();
    return Scaffold(appBar: AppBar(title: const Text('المرضى')), body: SafeArea(child: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: [SliverPadding(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ابحث في قائمة مرضاك ومعلومات المتابعة', style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: AppSpacing.md), CustomTextField(label: 'ابحث عن مريض', prefixIcon: Icons.search_rounded, controller: _searchController, onChanged: (value) => setState(() => _query = value), textInputAction: TextInputAction.search), const SizedBox(height: AppSpacing.lg), Text('${patients.length} مرضى', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700))])), if (patients.isEmpty) const SliverFillRemaining(hasScrollBody: false, child: EmptyState(title: 'لا توجد نتائج', message: 'جرّب البحث باسم آخر.', icon: Icons.person_search_outlined)) else SliverPadding(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) { final patient = patients[index]; return Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: _PatientCard(patient: patient, onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorPatientDetailsScreen(patient: patient))))); }, childCount: patients.length))])));
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({required this.patient, required this.onTap});
  final DoctorPatient patient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Row(children: [AppAvatar(initials: patient.initials, size: 52, backgroundColor: patient.avatarColor), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(patient.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text('${patient.age}  •  ${patient.gender}', style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 3), Text('آخر موعد: ${patient.lastAppointment}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))])), StatusBadge(label: patient.status, color: patient.status == 'مستقر' ? AppColors.success : AppColors.primary), const SizedBox(width: 4), const Icon(Icons.chevron_left_rounded, color: AppColors.muted)])));
}

class DoctorPatientDetailsScreen extends StatelessWidget {
  const DoctorPatientDetailsScreen({super.key, required this.patient});
  final DoctorPatient patient;

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('ملف المريض')), body: SafeArea(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [AppCard(child: Row(children: [AppAvatar(initials: patient.initials, size: 72, backgroundColor: patient.avatarColor), const SizedBox(width: AppSpacing.md), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(patient.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)), const SizedBox(height: 5), Text('${patient.age}  •  ${patient.gender}', style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: AppSpacing.sm), StatusBadge(label: patient.status, color: AppColors.primary)]))])), const SizedBox(height: AppSpacing.xl), const SectionHeader(title: 'المعلومات الأساسية'), const SizedBox(height: AppSpacing.sm), AppCard(child: Column(children: [_InfoRow(label: 'العمر', value: patient.age, icon: Icons.cake_outlined), const Divider(height: AppSpacing.lg), _InfoRow(label: 'الجنس', value: patient.gender, icon: Icons.person_outline), const Divider(height: AppSpacing.lg), _InfoRow(label: 'آخر موعد', value: patient.lastAppointment, icon: Icons.calendar_month_outlined)])), const SizedBox(height: AppSpacing.xl), const SectionHeader(title: 'المواعيد السابقة'), const SizedBox(height: AppSpacing.sm), AppCard(child: Column(children: [_HistoryRow(date: patient.lastAppointment, title: 'زيارة متابعة', status: 'مكتمل'), const Divider(height: AppSpacing.lg), const _HistoryRow(date: '٢٨ أغسطس ٢٠٢٦', title: 'استشارة', status: 'مكتمل')])), const SizedBox(height: AppSpacing.xl), const SectionHeader(title: 'الملاحظات'), const SizedBox(height: AppSpacing.sm), AppCard(child: Text(patient.notes, style: Theme.of(context).textTheme.bodyLarge))])));
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: AppSpacing.sm), Text(label, style: Theme.of(context).textTheme.bodyMedium), const Spacer(), Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700))]);
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.date, required this.title, required this.status});
  final String date;
  final String title;
  final String status;

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 38, height: 38, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)), child: const Icon(Icons.event_available_outlined, color: AppColors.primary, size: 19)), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(date, style: Theme.of(context).textTheme.bodyMedium)])), StatusBadge(label: status, color: AppColors.success)]);
}