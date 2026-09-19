import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../appointments/appointment_booking_screens.dart';
import '../appointments/models/appointment_booking_data.dart';
import 'data/mock_doctors.dart';
import 'models/doctor_model.dart';

class DoctorsListScreen extends StatefulWidget {
  const DoctorsListScreen({super.key});

  @override
  State<DoctorsListScreen> createState() => _DoctorsListScreenState();
}

class _DoctorsListScreenState extends State<DoctorsListScreen> {
  final _searchController = TextEditingController();
  String _selectedSpecialty = 'الكل';
  String _searchQuery = '';

  static const _specialties = ['الكل', 'طب عام', 'أطفال', 'أسنان', 'قلب', 'جلدية', 'نسائية', 'عظام'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DoctorData> get _filteredDoctors => doctors.where((doctor) {
        final matchesSpecialty = _selectedSpecialty == 'الكل' || doctor.specialty == _selectedSpecialty;
        final query = _searchQuery.trim();
        final matchesSearch = query.isEmpty || doctor.name.contains(query) || doctor.specialty.contains(query) || doctor.clinic.contains(query);
        return matchesSpecialty && matchesSearch;
      }).toList();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('الأطباء'),
          leading: const BackButton(),
        ),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
                sliver: SliverList(delegate: SliverChildListDelegate([
                  Text('اعثر على الطبيب المناسب لرعايتك', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: AppSpacing.md),
                  CustomTextField(
                    label: 'ابحث عن طبيب أو تخصص',
                    prefixIcon: Icons.search_rounded,
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('التخصص', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    height: 39,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('${_filteredDoctors.length} أطباء متاحون', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.sm),
                ])),
              ),
              if (_filteredDoctors.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: _DoctorsEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverLayoutBuilder(builder: (context, constraints) {
                    final columns = constraints.crossAxisExtent >= 600 ? 2 : 1;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _DoctorListCard(doctor: _filteredDoctors[index], onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorDetailsScreen(doctor: _filteredDoctors[index])))),
                        childCount: _filteredDoctors.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        mainAxisExtent: 224,
                      ),
                    );
                  }),
                ),
            ],
          ),
        ),
      );
}

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});
  DoctorDetailsScreen.preview({
    super.key,
    required String initials,
    required String name,
    required String specialty,
    required String clinic,
    required String location,
    required String rating,
    required String reviews,
    required int experience,
    required String bio,
    required List<String> services,
    required Color color,
  }) : doctor = DoctorData(initials: initials, name: name, specialty: specialty, clinic: clinic, location: location, rating: rating, reviews: reviews, experience: experience, bio: bio, services: services, color: color);
  final DoctorData doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  int _selectedDate = 0;
  String? _selectedTime;

  static const _dates = ['اليوم\n٢٤ سبتمبر', 'غداً\n٢٥ سبتمبر', 'الخميس\n٢٦ سبتمبر', 'الجمعة\n٢٧ سبتمبر'];
  static const _times = ['٠٩:٠٠ ص', '١٠:٣٠ ص', '١٢:٠٠ م', '٠٤:٣٠ م'];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text('ملف الطبيب'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(
                child: Row(children: [
                  AppAvatar(initials: widget.doctor.initials, size: 70, backgroundColor: widget.doctor.color),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.doctor.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(widget.doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 7),
                    Row(children: [
                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 17),
                      const SizedBox(width: 4),
                      Text('${widget.doctor.rating}  •  ${widget.doctor.reviews} تقييم', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    ]),
                  ])),
                ]),
              ),
              const SizedBox(height: AppSpacing.lg),
              _InfoLine(icon: Icons.local_hospital_outlined, title: 'العيادة', value: widget.doctor.clinic),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(icon: Icons.location_on_outlined, title: 'الموقع', value: widget.doctor.location),
              const SizedBox(height: AppSpacing.sm),
              _InfoLine(icon: Icons.workspace_premium_outlined, title: 'الخبرة', value: '${widget.doctor.experience} سنوات من الخبرة'),
              const SizedBox(height: AppSpacing.xl),
              Text('نبذة عن الطبيب', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(widget.doctor.bio, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xl),
              Text('الخدمات والتخصصات', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.xs, runSpacing: AppSpacing.xs, children: [for (final service in widget.doctor.services) _ServiceChip(label: service)]),
              const SizedBox(height: AppSpacing.xl),
              Text('المواعيد المتاحة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 68,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _dates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final selected = index == _selectedDate;
                    return InkWell(
                      onTap: () => setState(() {
                        _selectedDate = index;
                        _selectedTime = null;
                      }),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 90,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppColors.primary : AppColors.border)),
                        child: Text(_dates[index], textAlign: TextAlign.center, style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700, height: 1.45)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [for (final time in _times) _TimeChip(label: time, selected: time == _selectedTime, onTap: () => setState(() => _selectedTime = time))]),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  label: 'حجز موعد',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => AppointmentBookingScreen(
                        bookingData: AppointmentBookingData(
                          doctorName: widget.doctor.name,
                          doctorInitials: widget.doctor.initials,
                          specialty: widget.doctor.specialty,
                          clinicName: widget.doctor.clinic,
                          location: widget.doctor.location,
                          avatarColor: widget.doctor.color,
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

class _DoctorListCard extends StatelessWidget {
  const _DoctorListCard({required this.doctor, required this.onTap});
  final DoctorData doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            AppAvatar(initials: doctor.initials, size: 54, backgroundColor: doctor.color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(doctor.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 3),
              Text(doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)),
            ])),
          ]),
          const SizedBox(height: AppSpacing.sm),
          Text(doctor.clinic, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 3),
          Row(children: [
            const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 15),
            const SizedBox(width: 4),
            Expanded(child: Text(doctor.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12))),
          ]),
          const Spacer(),
          Row(children: [
            const Icon(Icons.star_rounded, color: AppColors.warning, size: 17),
            const SizedBox(width: 4),
            Text(doctor.rating, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
            const Spacer(),
            const Icon(Icons.circle, color: AppColors.success, size: 7),
            const SizedBox(width: 4),
            Text('متاحة اليوم', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(width: double.infinity, height: 38, child: OutlinedButton(onPressed: onTap, child: const Text('عرض الملف'))),
        ]),
      );
}

class _DoctorsEmptyState extends StatelessWidget {
  const _DoctorsEmptyState();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: EmptyState(title: 'لم نجد أطباء مطابقين لبحثك', message: 'جرّب تغيير كلمة البحث أو اختيار تخصص مختلف', icon: Icons.person_search_outlined),
        ),
      );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: AppColors.primary, size: 19)),
        const SizedBox(width: AppSpacing.sm),
        Text('$title: ', style: Theme.of(context).textTheme.bodyMedium),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600))),
      ]);
}

class _ServiceChip extends StatelessWidget {
  const _ServiceChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(10)),
        child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600, fontSize: 12)),
      );
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: selected ? AppColors.mint : AppColors.surface, borderRadius: BorderRadius.circular(11), border: Border.all(color: selected ? AppColors.primary : AppColors.border)),
          child: Text(label, style: TextStyle(color: selected ? AppColors.primaryDark : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      );
}

