import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../appointments/appointment_booking_screens.dart';
import '../doctors/doctors_screens.dart';
import 'data/mock_clinics.dart';
import 'models/clinic_model.dart';

class ClinicsListScreen extends StatefulWidget {
  const ClinicsListScreen({super.key});

  @override
  State<ClinicsListScreen> createState() => _ClinicsListScreenState();
}

class _ClinicsListScreenState extends State<ClinicsListScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  String _searchQuery = '';

  static const _categories = ['الكل', 'عيادات عامة', 'أسنان', 'أطفال', 'قلب', 'جلدية', 'نسائية', 'عظام'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClinicData> get _filteredClinics => clinics.where((clinic) {
        final matchesCategory = _selectedCategory == 'الكل' || clinic.category == _selectedCategory;
        final query = _searchQuery.trim();
        final matchesSearch = query.isEmpty || clinic.name.contains(query) || clinic.category.contains(query) || clinic.location.contains(query);
        return matchesCategory && matchesSearch;
      }).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('العيادات'),
          leading: const BackButton(),
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text('اختر العيادة المناسبة لك', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: AppSpacing.md),
                    CustomTextField(
                      label: 'ابحث عن عيادة...',
                      prefixIcon: Icons.search_rounded,
                      controller: _searchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('التصنيف', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    SizedBox(
                      height: 39,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final selected = category == _selectedCategory;
                          return ChoiceChip(
                            label: Text(category),
                            selected: selected,
                            onSelected: (_) => setState(() => _selectedCategory = category),
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.surface,
                            side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                            labelStyle: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w600),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('${_filteredClinics.length} عيادات متاحة', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSpacing.sm),
                  ]),
                ),
              ),
              if (_filteredClinics.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: _ClinicsEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.crossAxisExtent >= 650 ? 2 : 1;
                      return SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final clinic = _filteredClinics[index];
                            return _ClinicListCard(clinic: clinic, onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ClinicDetailsScreen(clinic: clinic))));
                          },
                          childCount: _filteredClinics.length,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, crossAxisSpacing: AppSpacing.md, mainAxisSpacing: AppSpacing.md, mainAxisExtent: 274),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
}

class ClinicDetailsScreen extends StatelessWidget {
  const ClinicDetailsScreen({super.key, required this.clinic});
  final ClinicData clinic;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تفاصيل العيادة'), leading: const BackButton()),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(child: Row(children: [
                Container(width: 68, height: 68, decoration: BoxDecoration(color: clinic.color, borderRadius: BorderRadius.circular(19)), child: Icon(clinic.icon, color: AppColors.primaryDark, size: 32)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(clinic.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(clinic.category, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 7),
                  Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 16), const SizedBox(width: 4), Expanded(child: Text(clinic.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium))]),
                ])),
                const SizedBox(width: AppSpacing.xs),
                StatusBadge(label: clinic.status, color: AppColors.success),
              ])),
              const SizedBox(height: AppSpacing.xl),
              Text('عن العيادة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(clinic.description, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xl),
              Text('معلومات العيادة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(child: Column(children: [
                _ClinicInfoRow(icon: Icons.location_on_outlined, title: 'الموقع', value: clinic.location),
                const Divider(height: AppSpacing.lg),
                _ClinicInfoRow(icon: Icons.schedule_outlined, title: 'ساعات العمل', value: clinic.hours),
                const Divider(height: AppSpacing.lg),
                _ClinicInfoRow(icon: Icons.people_outline, title: 'عدد الأطباء', value: '${clinic.doctors.length} أطباء'),
              ])),
              const SizedBox(height: AppSpacing.xl),
              Text('التخصصات', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [for (final specialty in clinic.specialties) _SpecialtyChip(label: specialty)]),
              const SizedBox(height: AppSpacing.xl),
              Text('أطباء العيادة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              ...clinic.doctors.map((doctor) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _ClinicDoctorCard(
                      doctor: doctor,
                      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorDetailsScreen.preview(initials: doctor.initials, name: doctor.name, specialty: doctor.specialty, clinic: clinic.name, location: clinic.location, rating: doctor.rating, reviews: doctor.reviews, experience: doctor.experience, bio: doctor.bio, services: doctor.services, color: doctor.color))),
                    ),
                  )),
              const SizedBox(height: AppSpacing.md),
              Text('موقع العيادة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: EdgeInsets.zero,
                child: Container(
                  height: 154,
                  decoration: BoxDecoration(color: AppColors.sky, borderRadius: BorderRadius.circular(20)),
                  child: Stack(alignment: Alignment.center, children: [
                    Icon(Icons.map_outlined, color: AppColors.primary.withValues(alpha: .18), size: 92),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 34),
                      const SizedBox(height: AppSpacing.xs),
                      Text('موقع العيادة على الخريطة', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'حجز موعد',
                  icon: Icons.calendar_month_outlined,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AppointmentBookingScreen(
                        bookingData: AppointmentBookingData(
                          doctorName: clinic.doctors.first.name,
                          doctorInitials: clinic.doctors.first.initials,
                          specialty: clinic.doctors.first.specialty,
                          clinicName: clinic.name,
                          location: clinic.location,
                          avatarColor: clinic.doctors.first.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );

}

class _ClinicListCard extends StatelessWidget {
  const _ClinicListCard({required this.clinic, required this.onTap});
  final ClinicData clinic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 52, height: 52, decoration: BoxDecoration(color: clinic.color, borderRadius: BorderRadius.circular(15)), child: Icon(clinic.icon, color: AppColors.primaryDark, size: 26)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(clinic.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(clinic.category, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600))])),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text(clinic.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 16), const SizedBox(width: 4), Expanded(child: Text(clinic.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)))]),
          const SizedBox(height: AppSpacing.xs),
          Row(children: [const Icon(Icons.people_outline, color: AppColors.muted, size: 16), const SizedBox(width: 4), Text('${clinic.doctors.length} أطباء', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)), const Spacer(), StatusBadge(label: clinic.status, color: AppColors.success)]),
          const Spacer(),
          SizedBox(width: double.infinity, height: 38, child: OutlinedButton(onPressed: onTap, child: const Text('عرض العيادة'))),
        ]),
      );
}

class _ClinicDoctorCard extends StatelessWidget {
  const _ClinicDoctorCard({required this.doctor, required this.onTap});
  final ClinicDoctorData doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(children: [
          AppAvatar(initials: doctor.initials, size: 52, backgroundColor: doctor.color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(doctor.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)), const SizedBox(height: 5), Row(children: [const Icon(Icons.star_rounded, color: AppColors.warning, size: 16), const SizedBox(width: 3), Text(doctor.rating, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(width: AppSpacing.sm), const Icon(Icons.circle, color: AppColors.success, size: 7), const SizedBox(width: 4), Text('متاحة اليوم', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700))])])),
          IconButton(onPressed: onTap, icon: const Icon(Icons.chevron_left_rounded), color: AppColors.primary, tooltip: 'عرض الملف'),
        ]),
      );
}

class _ClinicInfoRow extends StatelessWidget {
  const _ClinicInfoRow({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: AppColors.primary, size: 19)), const SizedBox(width: AppSpacing.sm), Text('$title: ', style: Theme.of(context).textTheme.bodyMedium), Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)))]);
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(10)), child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 12)));
}

class _ClinicsEmptyState extends StatelessWidget {
  const _ClinicsEmptyState();

  @override
  Widget build(BuildContext context) => const Center(child: Padding(padding: EdgeInsets.all(AppSpacing.xl), child: EmptyState(title: 'لم نجد عيادات مطابقة', message: 'جرّب البحث باسم مختلف أو اختر تصنيفًا آخر', icon: Icons.local_hospital_outlined)));
}

