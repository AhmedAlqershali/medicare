import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  var _profile = const _DoctorProfile(name: 'د. أحمد العتيبي', specialty: 'طب عام', clinic: 'مركز Medicare الطبي', email: 'ahmed.alotaibi@example.com', phone: '050 987 6543');

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الملف الشخصي')), body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [AppCard(child: Row(children: [const AppAvatar(initials: 'أ ح', size: 72, backgroundColor: AppColors.sky), const SizedBox(width: AppSpacing.md), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_profile.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)), const SizedBox(height: 4), Text(_profile.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(_profile.clinic, style: Theme.of(context).textTheme.bodyMedium)])), IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit_outlined), tooltip: 'تعديل الملف الشخصي')])), const SizedBox(height: AppSpacing.xl), const SectionHeader(title: 'معلومات التواصل'), const SizedBox(height: AppSpacing.sm), _InfoTile(icon: Icons.badge_outlined, label: 'التخصص', value: _profile.specialty), _InfoTile(icon: Icons.local_hospital_outlined, label: 'العيادة', value: _profile.clinic), _InfoTile(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _profile.email), _InfoTile(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _profile.phone), const SizedBox(height: AppSpacing.lg), const SectionHeader(title: 'الإعدادات'), const SizedBox(height: AppSpacing.sm), _SettingTile(icon: Icons.edit_outlined, title: 'تعديل الملف الشخصي', onTap: _editProfile), _SettingTile(icon: Icons.notifications_none_rounded, title: 'الإشعارات', onTap: () => _showMessage(context, 'إعدادات الإشعارات متاحة محلياً')), _SettingTile(icon: Icons.brightness_6_outlined, title: 'المظهر', onTap: () => _showMessage(context, 'المظهر مضبوط على الوضع الفاتح')), _SettingTile(icon: Icons.support_agent_outlined, title: 'المساعدة', onTap: () => _showMessage(context, 'يسعدنا مساعدتك')), _SettingTile(icon: Icons.info_outline, title: 'عن Medicare', onTap: () => _showMessage(context, 'Medicare للرعاية الصحية')), _SettingTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', color: const Color(0xFFC84C4C), onTap: () => _showLogoutDialog(context))])));

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<_DoctorProfile>(MaterialPageRoute(builder: (_) => DoctorEditProfileScreen(profile: _profile)));
    if (updated != null && mounted) setState(() => _profile = updated);
  }

  static void _showMessage(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  static Future<void> _showLogoutDialog(BuildContext context) async => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('تسجيل الخروج'), content: const Text('هل أنت متأكد من تسجيل الخروج؟'), actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('تسجيل الخروج'))]));
}

class _DoctorProfile {
  const _DoctorProfile({required this.name, required this.specialty, required this.clinic, required this.email, required this.phone});
  final String name;
  final String specialty;
  final String clinic;
  final String email;
  final String phone;
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => AppCard(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 13), child: Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 2), Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))]))]));
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({required this.icon, required this.title, required this.onTap, this.color = AppColors.ink});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 4), leading: Icon(icon, color: color), title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)), trailing: const Icon(Icons.chevron_left_rounded, color: AppColors.muted), onTap: onTap);
}

class DoctorEditProfileScreen extends StatefulWidget {
  const DoctorEditProfileScreen({super.key, required this.profile});
  final _DoctorProfile profile;

  @override
  State<DoctorEditProfileScreen> createState() => _DoctorEditProfileScreenState();
}

class _DoctorEditProfileScreenState extends State<DoctorEditProfileScreen> {
  late final _nameController = TextEditingController(text: widget.profile.name);
  late final _specialtyController = TextEditingController(text: widget.profile.specialty);
  late final _clinicController = TextEditingController(text: widget.profile.clinic);
  late final _emailController = TextEditingController(text: widget.profile.email);
  late final _phoneController = TextEditingController(text: widget.profile.phone);

  @override
  void dispose() { _nameController.dispose(); _specialtyController.dispose(); _clinicController.dispose(); _emailController.dispose(); _phoneController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('تعديل الملف الشخصي')), body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), child: Column(children: [CustomTextField(label: 'اسم الطبيب', prefixIcon: Icons.badge_outlined, controller: _nameController), const SizedBox(height: AppSpacing.md), CustomTextField(label: 'التخصص', prefixIcon: Icons.medical_information_outlined, controller: _specialtyController), const SizedBox(height: AppSpacing.md), CustomTextField(label: 'العيادة', prefixIcon: Icons.local_hospital_outlined, controller: _clinicController), const SizedBox(height: AppSpacing.md), CustomTextField(label: 'البريد الإلكتروني', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress), const SizedBox(height: AppSpacing.md), CustomTextField(label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, controller: _phoneController, keyboardType: TextInputType.phone), const SizedBox(height: AppSpacing.xl), SizedBox(width: double.infinity, child: PrimaryButton(label: 'حفظ التغييرات', icon: Icons.check_rounded, onPressed: _save))])));

  void _save() => Navigator.of(context).pop(_DoctorProfile(name: _nameController.text.trim(), specialty: _specialtyController.text.trim(), clinic: _clinicController.text.trim(), email: _emailController.text.trim(), phone: _phoneController.text.trim()));
}

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  int _selectedDay = 0;
  static const _days = [('الأحد', '٢٢'), ('الاثنين', '٢٣'), ('الثلاثاء', '٢٤'), ('الأربعاء', '٢٥'), ('الخميس', '٢٦')];
  static const _slots = [('٠٨:٠٠ ص', true), ('٠٩:٠٠ ص', false), ('١٠:٠٠ ص', true), ('١١:٠٠ ص', false), ('٠١:٠٠ م', false), ('٠٢:٠٠ م', true), ('٠٤:٠٠ م', false)];

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('الجدول')), body: SafeArea(child: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('جدول مواعيدك لهذا الأسبوع', style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: AppSpacing.lg), SizedBox(height: 76, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: _days.length, separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm), itemBuilder: (context, index) { final selected = _selectedDay == index; return InkWell(onTap: () => setState(() => _selectedDay = index), borderRadius: BorderRadius.circular(14), child: Container(width: 76, decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppColors.primary : AppColors.border)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(_days[index].$1, style: TextStyle(color: selected ? Colors.white : AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(_days[index].$2, style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 18, fontWeight: FontWeight.w800))]))); })), const SizedBox(height: AppSpacing.xl), const SectionHeader(title: 'ساعات العمل'), const SizedBox(height: AppSpacing.sm), const AppCard(child: Row(children: [Icon(Icons.access_time_outlined, color: AppColors.primary), SizedBox(width: AppSpacing.sm), Text('من ٠٨:٠٠ صباحاً إلى ٠٥:٠٠ مساءً', style: TextStyle(fontWeight: FontWeight.w700)),])), const SizedBox(height: AppSpacing.xl), const SectionHeader(title: 'الفترات المتاحة'), const SizedBox(height: AppSpacing.sm), Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [for (final slot in _slots) _ScheduleSlot(time: slot.$1, booked: slot.$2)]), const SizedBox(height: AppSpacing.lg), Row(children: [const _Legend(color: AppColors.primary, label: 'محجوز'), const SizedBox(width: AppSpacing.lg), const _Legend(color: AppColors.mint, label: 'متاح')])])));
}

class _ScheduleSlot extends StatelessWidget {
  const _ScheduleSlot({required this.time, required this.booked});
  final String time;
  final bool booked;

  @override
  Widget build(BuildContext context) => Container(width: 106, padding: const EdgeInsets.symmetric(vertical: 13), alignment: Alignment.center, decoration: BoxDecoration(color: booked ? AppColors.primary : AppColors.mint, borderRadius: BorderRadius.circular(12), border: Border.all(color: booked ? AppColors.primary : AppColors.border)), child: Column(children: [Icon(booked ? Icons.event_available_outlined : Icons.add_circle_outline, color: booked ? Colors.white : AppColors.primary, size: 18), const SizedBox(height: 4), Text(time, style: TextStyle(color: booked ? Colors.white : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700))]));
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 10, height: 10, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))), const SizedBox(width: 5), Text(label, style: Theme.of(context).textTheme.bodyMedium)]);
}