part of 'organization_profile_screens.dart';

class _OrganizationProfileScreenState extends State<OrganizationProfileScreen> {
  var _profile = const OrganizationProfile(name: 'مؤسسة Medicare الطبية', email: 'admin@medicare.sa', phone: '055 222 3344', location: 'الرياض، المملكة العربية السعودية', clinicsCount: 6);

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
              _SettingTile(icon: Icons.notifications_none_rounded, title: 'الإشعارات', onTap: () => _showMessage(context: context, message: 'إعدادات الإشعارات قيد التطوير محلياً')),
              _SettingTile(icon: Icons.brightness_6_outlined, title: 'المظهر', onTap: () => _showMessage(context: context, message: 'تم ضبط المظهر على الوضع الفاتح')),
              _SettingTile(icon: Icons.support_agent_outlined, title: 'المساعدة', onTap: () => _showMessage(context: context, message: 'سيتم التواصل معك في أقرب وقت')),
              _SettingTile(icon: Icons.info_outline, title: 'عن Medicare', onTap: () => _showMessage(context: context, message: 'Medicare منصة رعاية صحية حديثة')),
              _SettingTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', color: const Color(0xFFC84C4C), onTap: () => _showLogoutDialog(context)),
            ]),
          ),
        ),
      );

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<OrganizationProfile>(MaterialPageRoute(builder: (_) => OrganizationProfileFormScreen(profile: _profile)));
    if (updated != null && mounted) setState(() => _profile = updated);
  }

  static void _showMessage({required BuildContext context, required String message}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  static Future<void> _showLogoutDialog(BuildContext context) async => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('تسجيل الخروج'), content: const Text('هل أنت متأكد من تسجيل الخروج؟'), actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')), FilledButton(onPressed: () { Navigator.of(dialogContext).pop(); AuthNavigation.openSignedOutFlow(context); }, child: const Text('تسجيل الخروج'))]));
}
