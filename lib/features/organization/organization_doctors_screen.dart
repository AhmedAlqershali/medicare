import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'data/mock_organization_doctors.dart';
import 'models/organization_doctor.dart';

class OrganizationDoctorsScreen extends StatefulWidget {
  const OrganizationDoctorsScreen({super.key});

  @override
  State<OrganizationDoctorsScreen> createState() => _OrganizationDoctorsScreenState();
}

class _OrganizationDoctorsScreenState extends State<OrganizationDoctorsScreen> {
  final _searchController = TextEditingController();
  final List<String> _specialties = ['الكل', 'طب عام', 'أطفال', 'جلدية'];
  final List<String> _clinics = ['الكل', 'العيادة المركزية', 'عيادة النمو', 'مركز الجلدية'];
  String _selectedSpecialty = 'الكل';
  String _selectedClinic = 'الكل';
  String _query = '';
  late List<OrganizationDoctor> _doctors = List.of(mockOrganizationDoctors);

  List<OrganizationDoctor> get _filteredDoctors => _doctors.where((doctor) {
    final query = _query.trim();
    final matchesSpecialty = _selectedSpecialty == 'الكل' || doctor.specialty == _selectedSpecialty;
    final matchesClinic = _selectedClinic == 'الكل' || doctor.clinic == _selectedClinic;
    final matchesSearch = query.isEmpty || doctor.name.contains(query) || doctor.specialty.contains(query) || doctor.clinic.contains(query);
    return matchesSpecialty && matchesClinic && matchesSearch;
  }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الأطباء')),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('إدارة الفريق الطبي', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(label: 'ابحث عن طبيب', prefixIcon: Icons.search_rounded, controller: _searchController, onChanged: (value) => setState(() => _query = value)),
                    const SizedBox(height: AppSpacing.lg),
                    Text('التخصص', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 39,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _specialties.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                        itemBuilder: (context, index) {
                          final specialty = _specialties[index];
                          final selected = specialty == _selectedSpecialty;
                          return ChoiceChip(
                            label: Text(specialty),
                            selected: selected,
                            onSelected: (_) => setState(() => _selectedSpecialty = specialty),
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface,
                            side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                            labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w600),
                            showCheckmark: false,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('العيادة', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedClinic,
                          items: _clinics.map((clinic) => DropdownMenuItem(value: clinic, child: Text(clinic))).toList(),
                          onChanged: (value) => setState(() => _selectedClinic = value ?? 'الكل'),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('${_filteredDoctors.length} طبيب', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              if (_filteredDoctors.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: EmptyState(title: 'لا توجد نتائج', message: 'لا توجد أطباء متطابقة مع الفلاتر الحالية.', icon: Icons.person_search_outlined))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    final doctor = _filteredDoctors[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _DoctorCard(doctor: doctor, onTap: () => _openDetails(doctor)),
                    );
                  }, childCount: _filteredDoctors.length)),
                ),
            ],
          ),
        ),
      );

  Future<void> _openDetails(OrganizationDoctor doctor) async {
    final updated = await Navigator.of(context).push<OrganizationDoctor>(MaterialPageRoute<void>(builder: (_) => OrganizationDoctorDetailsScreen(doctor: doctor)));
    if (updated != null && mounted) {
      setState(() {
        final index = _doctors.indexWhere((item) => item.id == doctor.id);
        if (index != -1) _doctors[index] = updated;
      });
    }
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({required this.doctor, required this.onTap});
  final OrganizationDoctor doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Row(children: [AppAvatar(initials: doctor.initials, size: 52, backgroundColor: doctor.avatarColor), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doctor.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(doctor.clinic, style: Theme.of(context).textTheme.bodyMedium)])), StatusBadge(label: doctor.status, color: doctor.status == 'نشط' ? AppColors.success : AppColors.muted)])));
}

class OrganizationDoctorDetailsScreen extends StatefulWidget {
  const OrganizationDoctorDetailsScreen({super.key, required this.doctor});
  final OrganizationDoctor doctor;

  @override
  State<OrganizationDoctorDetailsScreen> createState() => _OrganizationDoctorDetailsScreenState();
}

class _OrganizationDoctorDetailsScreenState extends State<OrganizationDoctorDetailsScreen> {
  late OrganizationDoctor _doctor = widget.doctor;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الطبيب'), leading: BackButton(onPressed: () => Navigator.of(context).pop(_doctor))),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(
                child: Row(children: [
                  AppAvatar(initials: _doctor.initials, size: 72, backgroundColor: _doctor.avatarColor),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_doctor.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(_doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    StatusBadge(label: _doctor.status, color: _doctor.status == 'نشط' ? AppColors.success : AppColors.muted),
                  ])),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'معلومات الطبيب'),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(children: [
                  InfoRow(icon: Icons.local_hospital_outlined, label: 'العيادة', value: _doctor.clinic),
                  const Divider(height: AppSpacing.lg),
                  InfoRow(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _doctor.phone),
                  const Divider(height: AppSpacing.lg),
                  InfoRow(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _doctor.email),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'الجدول'),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Row(children: [
                  const Icon(Icons.access_time_outlined, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(_doctor.scheduleSummary, style: Theme.of(context).textTheme.bodyLarge)),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'تعديل بيانات الطبيب', icon: Icons.edit_outlined, onPressed: () async {
                final updated = await Navigator.of(context).push<OrganizationDoctor>(MaterialPageRoute<void>(builder: (_) => OrganizationDoctorFormScreen(doctor: _doctor)));
                if (updated != null && mounted) setState(() => _doctor = updated);
              })),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _toggleStatus, icon: const Icon(Icons.swap_horiz_rounded), label: const Text('تغيير الحالة'))),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _showSchedule(), icon: const Icon(Icons.calendar_month_outlined), label: const Text('عرض الجدول'))),
            ]),
          ),
        ),
      );

  void _toggleStatus() {
    setState(() {
      final nextStatus = _doctor.status == 'نشط' ? 'غير متاح' : 'نشط';
      _doctor = _doctor.copyWith(status: nextStatus);
    });
  }

  void _showSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الجدول: ${_doctor.scheduleSummary}')));
  }
}

class OrganizationDoctorFormScreen extends StatefulWidget {
  const OrganizationDoctorFormScreen({super.key, required this.doctor});
  final OrganizationDoctor doctor;

  @override
  State<OrganizationDoctorFormScreen> createState() => _OrganizationDoctorFormScreenState();
}

class _OrganizationDoctorFormScreenState extends State<OrganizationDoctorFormScreen> {
  late final TextEditingController _nameController = TextEditingController(text: widget.doctor.name.replaceFirst('د. ', ''));
  late final TextEditingController _specialtyController = TextEditingController(text: widget.doctor.specialty);
  late final TextEditingController _clinicController = TextEditingController(text: widget.doctor.clinic);
  late final TextEditingController _phoneController = TextEditingController(text: widget.doctor.phone);
  late final TextEditingController _emailController = TextEditingController(text: widget.doctor.email);

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _clinicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.doctor.copyWith(
      name: 'د. ${_nameController.text.trim()}',
      specialty: _specialtyController.text.trim(),
      clinic: _clinicController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تعديل بيانات الطبيب')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              CustomTextField(label: 'اسم الطبيب', prefixIcon: Icons.badge_outlined, controller: _nameController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'التخصص', prefixIcon: Icons.medical_information_outlined, controller: _specialtyController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'العيادة', prefixIcon: Icons.local_hospital_outlined, controller: _clinicController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, controller: _phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'البريد الإلكتروني', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'حفظ', icon: Icons.check_rounded, onPressed: _save)),
            ]),
          ),
        ),
      );
}
