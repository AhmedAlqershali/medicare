import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'data/mock_organization_clinics.dart';
import 'models/organization_clinic.dart';

class OrganizationClinicsScreen extends StatefulWidget {
  const OrganizationClinicsScreen({super.key});

  @override
  State<OrganizationClinicsScreen> createState() => _OrganizationClinicsScreenState();
}

class _OrganizationClinicsScreenState extends State<OrganizationClinicsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  late List<OrganizationClinic> _clinics = List.of(mockOrganizationClinics);

  List<OrganizationClinic> get _filteredClinics => _clinics.where((clinic) {
    final query = _query.trim();
    return query.isEmpty || clinic.name.contains(query) || clinic.location.contains(query) || clinic.departments.any((department) => department.contains(query));
  }).toList();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('العيادات'),
          actions: [IconButton(onPressed: _openAddClinic, icon: const Icon(Icons.add_rounded), tooltip: 'إضافة عيادة')],
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                sliver: SliverToBoxAdapter(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('إدارة العيادات والفرع', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      label: 'ابحث عن عيادة',
                      prefixIcon: Icons.search_rounded,
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('${_filteredClinics.length} عيادة', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
              if (_filteredClinics.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: EmptyState(title: 'لا توجد نتائج', message: 'لا توجد عيادات مطابقة لبحثك.', icon: Icons.search_off_outlined))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    final clinic = _filteredClinics[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _ClinicCard(
                        clinic: clinic,
                        onTap: () => _openClinicDetails(clinic),
                      ),
                    );
                  }, childCount: _filteredClinics.length)),
                ),
            ],
          ),
        ),
      );

  Future<void> _openClinicDetails(OrganizationClinic clinic) async {
    final updated = await Navigator.of(context).push<OrganizationClinic>(MaterialPageRoute<OrganizationClinic>(builder: (_) => OrganizationClinicDetailsScreen(clinic: clinic)));
    if (updated != null && mounted) {
      setState(() {
        final index = _clinics.indexWhere((item) => item.id == clinic.id);
        if (index != -1) _clinics[index] = updated;
      });
    }
  }

  Future<void> _openAddClinic() async {
    final created = await Navigator.of(context).push<OrganizationClinic>(MaterialPageRoute<OrganizationClinic>(builder: (_) => const OrganizationClinicFormScreen()));
    if (created != null && mounted) {
      setState(() => _clinics.insert(0, created));
    }
  }
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({required this.clinic, required this.onTap});
  final OrganizationClinic clinic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 52, height: 52, decoration: BoxDecoration(color: clinic.color, borderRadius: BorderRadius.circular(15)), child: Icon(clinic.icon, color: AppColors.primaryDark, size: 24)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(clinic.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(clinic.location, style: Theme.of(context).textTheme.bodyMedium),
              ])),
              StatusBadge(label: clinic.status, color: clinic.status == 'نشطة' ? AppColors.success : AppColors.muted),
            ]),
            const SizedBox(height: AppSpacing.md),
            Row(children: [
              Expanded(child: _Meta(icon: Icons.people_outline, value: '${clinic.doctorsCount} أطباء')),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _Meta(icon: Icons.category_outlined, value: '${clinic.departmentsCount} أقسام')),
            ]),
            const SizedBox(height: AppSpacing.xs),
            _Meta(icon: Icons.medical_services_outlined, value: '${clinic.patientsCount} مريضاً'),
          ]),
        ),
      );
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.value});
  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: AppColors.primary, size: 17), const SizedBox(width: 6), Expanded(child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)))]);
}

class OrganizationClinicDetailsScreen extends StatefulWidget {
  const OrganizationClinicDetailsScreen({super.key, required this.clinic});
  final OrganizationClinic clinic;

  @override
  State<OrganizationClinicDetailsScreen> createState() => _OrganizationClinicDetailsScreenState();
}

class _OrganizationClinicDetailsScreenState extends State<OrganizationClinicDetailsScreen> {
  late OrganizationClinic _clinic = widget.clinic;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل العيادة'),
          leading: BackButton(onPressed: () => Navigator.of(context).pop(_clinic)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(
                child: Row(children: [
                  Container(width: 68, height: 68, decoration: BoxDecoration(color: _clinic.color, borderRadius: BorderRadius.circular(19)), child: Icon(_clinic.icon, color: AppColors.primaryDark, size: 30)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_clinic.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(_clinic.location, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 6),
                    StatusBadge(label: _clinic.status, color: _clinic.status == 'نشطة' ? AppColors.success : AppColors.muted),
                  ])),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'المعلومات الأساسية'),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(children: [
                  InfoRow(icon: Icons.location_on_outlined, label: 'الموقع', value: _clinic.location),
                  const Divider(height: AppSpacing.lg),
                  InfoRow(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _clinic.phone),
                  const Divider(height: AppSpacing.lg),
                  InfoRow(icon: Icons.info_outline, label: 'الحالة', value: _clinic.status),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'الإحصاءات'),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                Expanded(child: _MiniStat(label: 'الأطباء', value: '${_clinic.doctorsCount}', icon: Icons.medical_information_outlined)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _MiniStat(label: 'الأقسام', value: '${_clinic.departmentsCount}', icon: Icons.category_outlined)),
              ]),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                Expanded(child: _MiniStat(label: 'المرضى', value: '${_clinic.patientsCount}', icon: Icons.people_outline)),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _MiniStat(label: 'مواعيد اليوم', value: '١٨', icon: Icons.calendar_month_outlined)),
              ]),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'الأقسام'),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
                  for (final department in _clinic.departments) Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(10)), child: Text(department, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700))),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'تعديل بيانات العيادة', icon: Icons.edit_outlined, onPressed: () async {
                final updated = await Navigator.of(context).push<OrganizationClinic>(MaterialPageRoute<OrganizationClinic>(builder: (_) => OrganizationClinicFormScreen(clinic: _clinic)));
                if (updated != null && mounted) {
                  setState(() => _clinic = updated);
                  Navigator.of(context).pop(updated);
                }
              })),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _addDepartment, icon: const Icon(Icons.add_rounded), label: const Text('إدارة الأقسام'))),
            ]),
          ),
        ),
      );

  Future<void> _addDepartment() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(context: context, builder: (dialogContext) => AlertDialog(
      title: const Text('إضافة قسم'),
      content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'اسم القسم')),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')),
        FilledButton(onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()), child: const Text('إضافة')),
      ],
    ));
    if (result != null && result.isNotEmpty && mounted) {
      final updated = _clinic.copyWith(departments: [..._clinic.departments, result]);
      setState(() => _clinic = updated);
      Navigator.of(context).pop(updated);
    }
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: AppColors.primary, size: 20)),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ]),
      );
}

class OrganizationClinicFormScreen extends StatefulWidget {
  const OrganizationClinicFormScreen({super.key, this.clinic});
  final OrganizationClinic? clinic;

  @override
  State<OrganizationClinicFormScreen> createState() => _OrganizationClinicFormScreenState();
}

class _OrganizationClinicFormScreenState extends State<OrganizationClinicFormScreen> {
  late final TextEditingController _nameController = TextEditingController(text: widget.clinic?.name ?? '');
  late final TextEditingController _locationController = TextEditingController(text: widget.clinic?.location ?? '');
  late final TextEditingController _phoneController = TextEditingController(text: widget.clinic?.phone ?? '');
  late final TextEditingController _descriptionController = TextEditingController(text: widget.clinic?.description ?? '');
  final Map<String, String> _errors = {};

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    final errors = <String, String>{};
    if (_nameController.text.trim().isEmpty) errors['name'] = 'أدخل اسم العيادة';
    if (_locationController.text.trim().isEmpty) errors['location'] = 'أدخل الموقع';
    if (_phoneController.text.trim().isEmpty) errors['phone'] = 'أدخل رقم الهاتف';
    if (_descriptionController.text.trim().isEmpty) errors['description'] = 'أدخل وصفاً مختصراً';
    setState(() => _errors
      ..clear()
      ..addAll(errors));
    if (errors.isNotEmpty) return;

    final clinic = (widget.clinic ?? OrganizationClinic(id: 'clinic-${DateTime.now().millisecondsSinceEpoch}', name: '', location: '', phone: '', description: '', status: 'نشطة', doctorsCount: 0, departmentsCount: 0, patientsCount: 0, icon: Icons.local_hospital_rounded, color: AppColors.sky, departments: const []))
        .copyWith(
          name: _nameController.text.trim(),
          location: _locationController.text.trim(),
          phone: _phoneController.text.trim(),
          description: _descriptionController.text.trim(),
        );
    Navigator.of(context).pop(clinic);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.clinic == null ? 'إضافة عيادة' : 'تعديل العيادة')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              CustomTextField(label: 'اسم العيادة', prefixIcon: Icons.local_hospital_outlined, controller: _nameController, errorText: _errors['name']),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'الموقع', prefixIcon: Icons.location_on_outlined, controller: _locationController, errorText: _errors['location']),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, controller: _phoneController, errorText: _errors['phone'], keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'وصف مختصر', prefixIcon: Icons.description_outlined, controller: _descriptionController, errorText: _errors['description']),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'حفظ', icon: Icons.check_rounded, onPressed: _save)),
            ]),
          ),
        ),
      );
}
