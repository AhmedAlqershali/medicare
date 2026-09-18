import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';

class OrganizationProfileScreen extends StatefulWidget {
  const OrganizationProfileScreen({super.key});

  @override
  State<OrganizationProfileScreen> createState() => _OrganizationProfileScreenState();
}

class _OrganizationProfileScreenState extends State<OrganizationProfileScreen> {
  var _profile = const _OrganizationProfile(name: 'مؤسسة Medicare الطبية', email: 'admin@medicare.sa', phone: '055 222 3344', location: 'الرياض، المملكة العربية السعودية', clinicsCount: 6);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الملف الشخصي')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(
                child: Row(children: [
                  const AppAvatar(initials: 'م م', size: 72, backgroundColor: AppColors.sky),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_profile.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text('إدارة الشبكة الطبية', style: Theme.of(context).textTheme.bodyMedium),
                  ])),
                  IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit_outlined), tooltip: 'تعديل الملف'),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'معلومات المؤسسة'),
              const SizedBox(height: AppSpacing.sm),
              _InfoTile(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _profile.email),
              _InfoTile(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _profile.phone),
              _InfoTile(icon: Icons.location_on_outlined, label: 'الموقع', value: _profile.location),
              _InfoTile(icon: Icons.local_hospital_outlined, label: 'عدد العيادات', value: '${_profile.clinicsCount} عيادة'),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'الإعدادات'),
              const SizedBox(height: AppSpacing.sm),
              _SettingTile(icon: Icons.edit_outlined, title: 'تعديل الملف', onTap: _editProfile),
              _SettingTile(icon: Icons.notifications_none_rounded, title: 'الإشعارات', onTap: () => _showMessage(context, 'إعدادات الإشعارات قيد التطوير محلياً')),
              _SettingTile(icon: Icons.brightness_6_outlined, title: 'المظهر', onTap: () => _showMessage(context: context, message: 'تم ضبط المظهر على الوضع الفاتح')),
              _SettingTile(icon: Icons.support_agent_outlined, title: 'المساعدة', onTap: () => _showMessage(context: context, message: 'سيتم التواصل معك في أقرب وقت')),
              _SettingTile(icon: Icons.info_outline, title: 'عن Medicare', onTap: () => _showMessage(context: context, message: 'Medicare منصة رعاية صحية حديثة')),
              _SettingTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', color: const Color(0xFFC84C4C), onTap: () => _showLogoutDialog(context)),
            ]),
          ),
        ),
      );

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<_OrganizationProfile>(MaterialPageRoute(builder: (_) => OrganizationProfileFormScreen(profile: _profile)));
    if (updated != null && mounted) setState(() => _profile = updated);
  }

  static void _showMessage({required BuildContext context, required String message}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  static Future<void> _showLogoutDialog(BuildContext context) async => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('تسجيل الخروج'), content: const Text('هل أنت متأكد من تسجيل الخروج؟'), actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')), FilledButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('تسجيل الخروج'))]));
}

class _OrganizationProfile {
  const _OrganizationProfile({required this.name, required this.email, required this.phone, required this.location, required this.clinicsCount});
  final String name;
  final String email;
  final String phone;
  final String location;
  final int clinicsCount;
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
        child: Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 2), Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))]))]),
      );
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

class OrganizationProfileFormScreen extends StatefulWidget {
  const OrganizationProfileFormScreen({super.key, required this.profile});
  final _OrganizationProfile profile;

  @override
  State<OrganizationProfileFormScreen> createState() => _OrganizationProfileFormScreenState();
}

class _OrganizationProfileFormScreenState extends State<OrganizationProfileFormScreen> {
  late final TextEditingController _nameController = TextEditingController(text: widget.profile.name);
  late final TextEditingController _emailController = TextEditingController(text: widget.profile.email);
  late final TextEditingController _phoneController = TextEditingController(text: widget.profile.phone);
  late final TextEditingController _locationController = TextEditingController(text: widget.profile.location);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = _OrganizationProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      clinicsCount: widget.profile.clinicsCount,
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تعديل الملف')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              CustomTextField(label: 'اسم المؤسسة', prefixIcon: Icons.business_outlined, controller: _nameController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'البريد الإلكتروني', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, controller: _phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'الموقع', prefixIcon: Icons.location_on_outlined, controller: _locationController),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'حفظ', icon: Icons.check_rounded, onPressed: _save)),
            ]),
          ),
        ),
      );
}
