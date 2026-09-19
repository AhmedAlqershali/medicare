part of 'doctor_patients_screen.dart';

class _DoctorPatientsScreenState extends State<DoctorPatientsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  List<DoctorPatient> _visiblePatients() => MockPatientRepository.instance.patientsForDoctor(MockPatientRepository.instance.currentDoctorId ?? '').map((patient) => DoctorPatient(name: patient.name, initials: patient.initials, age: 'غير محدد', gender: 'غير محدد', lastAppointment: 'لا يوجد موعد مسجل', status: patient.accountActivated ? 'نشط' : 'قيد التفعيل', avatarColor: AppColors.mint, notes: 'بيانات المريض مرتبطة بالطبيب الحالي فقط.')).toList();

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final patients = _visiblePatients()
        .where((patient) => patient.name.contains(_query.trim()) || patient.status.contains(_query.trim()))
        .toList();
    final slivers = <Widget>[
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
        sliver: SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ابحث في قائمة مرضاك ومعلومات المتابعة', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'ابحث عن مريض',
                prefixIcon: Icons.search_rounded,
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('${patients.length} مرضى', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    ];

    if (patients.isEmpty) {
      slivers.add(
        const SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyState(
            title: 'لا توجد نتائج',
            message: 'جرّب البحث باسم آخر.',
            icon: Icons.person_search_outlined,
          ),
        ),
      );
    } else {
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final patient = patients[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _PatientCard(
                    patient: patient,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => DoctorPatientDetailsScreen(patient: patient),
                      ),
                    ),
                  ),
                );
              },
              childCount: patients.length,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('المرضى'), actions: [IconButton(onPressed: _openAddPatient, icon: const Icon(Icons.person_add_alt_1_outlined), tooltip: 'إضافة مريض')]),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: slivers,
        ),
      ),
    );
  }

  void _openAddPatient() => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const AddPatientScreen()));
}
