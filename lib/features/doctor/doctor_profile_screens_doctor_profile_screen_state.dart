part of 'doctor_profile_screens.dart';

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  var _profile = const DoctorProfile(name: 'د. أحمد العتيبي', specialty: 'طب عام', clinic: 'مركز Medicare الطبي', email: 'ahmed.alotaibi@example.com', phone: '050 987 6543');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الملف الشخصي')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Row(
                    children: [
                      const AppAvatar(initials: 'أ ح', size: 72, backgroundColor: AppColors.sky),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_profile.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                            const SizedBox(height: 4),
                            Text(_profile.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 3),
                            Text(_profile.clinic, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      IconButton(onPressed: _editProfile, icon: const Icon(Icons.edit_outlined), tooltip: 'تعديل الملف الشخصي'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'معلومات التواصل'),
                const SizedBox(height: AppSpacing.sm),
                _InfoTile(icon: Icons.badge_outlined, label: 'التخصص', value: _profile.specialty),
                _InfoTile(icon: Icons.local_hospital_outlined, label: 'العيادة', value: _profile.clinic),
                _InfoTile(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _profile.email),
                _InfoTile(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _profile.phone),
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader(title: 'الإعدادات'),
                const SizedBox(height: AppSpacing.sm),
                _SettingTile(icon: Icons.edit_outlined, title: 'تعديل الملف الشخصي', onTap: _editProfile),
                _SettingTile(icon: Icons.notifications_none_rounded, title: 'الإشعارات', onTap: () => _showMessage(context, 'إعدادات الإشعارات متاحة محلياً')),
                _SettingTile(icon: Icons.brightness_6_outlined, title: 'المظهر', onTap: () => _showMessage(context, 'المظهر مضبوط على الوضع الفاتح')),
                _SettingTile(icon: Icons.support_agent_outlined, title: 'المساعدة', onTap: () => _showMessage(context, 'يسعدنا مساعدتك')),
                _SettingTile(icon: Icons.info_outline, title: 'عن Medicare', onTap: () => _showMessage(context, 'Medicare للرعاية الصحية')),
                _SettingTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', color: const Color(0xFFC84C4C), onTap: () => _showLogoutDialog(context)),
              ],
            ),
          ),
        ),
      );

  Future<void> _editProfile() async {
    final updated = await Navigator.of(context).push<DoctorProfile>(MaterialPageRoute(builder: (_) => DoctorEditProfileScreen(profile: _profile)));
    if (updated != null && mounted) setState(() => _profile = updated);
  }

  static void _showMessage(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  static Future<void> _showLogoutDialog(BuildContext context) async => showDialog<void>(context: context, builder: (dialogContext) => AlertDialog(title: const Text('تسجيل الخروج'), content: const Text('هل أنت متأكد من تسجيل الخروج؟'), actions: [TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('إلغاء')), FilledButton(onPressed: () { Navigator.of(dialogContext).pop(); AuthNavigation.openSignedOutFlow(context); }, child: const Text('تسجيل الخروج'))]));
}
