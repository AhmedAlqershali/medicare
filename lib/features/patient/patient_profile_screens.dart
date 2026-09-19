import 'package:flutter/material.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'data/mock_patient_profile.dart';
import 'models/patient_profile.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  var _patient = mockPatientProfile;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الملف الشخصي')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _ProfileHeader(
                patient: _patient,
                onEdit: () async {
                  final updated = await Navigator.of(context).push<PatientProfile>(MaterialPageRoute(builder: (_) => EditPatientProfileScreen(patient: _patient)));
                  if (updated != null && mounted) setState(() => _patient = updated);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'المعلومات الشخصية'),
              const SizedBox(height: AppSpacing.sm),
              _InfoCard(icon: Icons.badge_outlined, label: 'الاسم الكامل', value: _patient.name),
              _InfoCard(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _patient.phone),
              _InfoCard(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _patient.email),
              _InfoCard(icon: Icons.cake_outlined, label: 'تاريخ الميلاد', value: _patient.birthDate),
              _InfoCard(icon: Icons.person_outline, label: 'الجنس', value: _patient.gender),
              const SizedBox(height: AppSpacing.md),
              _NavigationTile(icon: Icons.settings_outlined, title: 'الإعدادات', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PatientSettingsScreen()))),
            ]),
          ),
        ),
      );
}

class EditPatientProfileScreen extends StatefulWidget {
  const EditPatientProfileScreen({super.key, required this.patient});
  final PatientProfile patient;

  @override
  State<EditPatientProfileScreen> createState() => _EditPatientProfileScreenState();
}

class _EditPatientProfileScreenState extends State<EditPatientProfileScreen> {
  late final TextEditingController _nameController = TextEditingController(text: widget.patient.name);
  late final TextEditingController _phoneController = TextEditingController(text: widget.patient.phone);
  late final TextEditingController _emailController = TextEditingController(text: widget.patient.email);
  late final TextEditingController _birthDateController = TextEditingController(text: widget.patient.birthDate);
  late String _gender = widget.patient.gender;
  final Map<String, String> _errors = {};

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _save() {
    final errors = <String, String>{};
    if (_nameController.text.trim().isEmpty) errors['name'] = 'أدخل الاسم الكامل';
    if (_phoneController.text.trim().isEmpty) errors['phone'] = 'أدخل رقم الهاتف';
    if (_emailController.text.trim().isEmpty || !_emailController.text.contains('@')) errors['email'] = 'أدخل بريداً إلكترونياً صحيحاً';
    if (_birthDateController.text.trim().isEmpty) errors['birthDate'] = 'أدخل تاريخ الميلاد';
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    if (errors.isNotEmpty) return;

    Navigator.of(context).pop(PatientProfile(name: _nameController.text.trim(), phone: _phoneController.text.trim(), email: _emailController.text.trim(), birthDate: _birthDateController.text.trim(), gender: _gender));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('حدّث معلوماتك لتبقى بياناتك الصحية محدثة.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(label: 'الاسم الكامل', prefixIcon: Icons.badge_outlined, controller: _nameController, errorText: _errors['name'], textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, controller: _phoneController, errorText: _errors['phone'], keyboardType: TextInputType.phone, textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'البريد الإلكتروني', prefixIcon: Icons.email_outlined, controller: _emailController, errorText: _errors['email'], keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'تاريخ الميلاد', hintText: 'مثال: ١٥ مايو ١٩٩٦', prefixIcon: Icons.cake_outlined, controller: _birthDateController, errorText: _errors['birthDate'], textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.lg),
              Text('الجنس', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(spacing: AppSpacing.sm, children: ['أنثى', 'ذكر'].map((gender) => ChoiceChip(label: Text(gender), selected: _gender == gender, onSelected: (_) => setState(() => _gender = gender))).toList()),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'حفظ التغييرات', icon: Icons.check_rounded, onPressed: _save),
            ]),
          ),
        ),
      );
}

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الإعدادات')),
        body: SafeArea(
          child: ListView(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), children: [
            const _SettingsSectionTitle(title: 'الحساب'),
            _NavigationTile(icon: Icons.person_outline, title: 'الملف الشخصي', onTap: () => Navigator.of(context).pop()),
            _NavigationTile(icon: Icons.lock_outline, title: 'تغيير كلمة المرور', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen()))),
            _NavigationTile(icon: Icons.logout_rounded, title: 'تسجيل الخروج', iconColor: const Color(0xFFC84C4C), onTap: () => _showLogoutDialog(context)),
            const SizedBox(height: AppSpacing.lg),
            const _SettingsSectionTitle(title: 'التفضيلات'),
            _NavigationTile(icon: Icons.language_outlined, title: 'اللغة', value: 'العربية', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LanguageScreen()))),
            _NavigationTile(icon: Icons.notifications_none_rounded, title: 'الإشعارات', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NotificationSettingsScreen()))),
            _NavigationTile(icon: Icons.brightness_6_outlined, title: 'الوضع الداكن / المظهر', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AppearanceScreen()))),
            const SizedBox(height: AppSpacing.lg),
            const _SettingsSectionTitle(title: 'الدعم'),
            _NavigationTile(icon: Icons.support_agent_outlined, title: 'المساعدة والدعم', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportScreen()))),
            _NavigationTile(icon: Icons.info_outline, title: 'عن Medicare', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutMedicareScreen()))),
          ]),
        ),
      );

  static Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog<void>(context: context, builder: (context) => AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('إلغاء')),
            FilledButton(onPressed: () { Navigator.of(context).pop(); AuthNavigation.openSignedOutFlow(context); }, child: const Text('تسجيل الخروج')),
          ],
        ));
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final Map<String, String> _errors = {};
  bool _success = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final errors = <String, String>{};
    if (_currentController.text.isEmpty) errors['current'] = 'أدخل كلمة المرور الحالية';
    if (_newController.text.length < 6) errors['new'] = 'يجب أن تتكون من 6 أحرف على الأقل';
    if (_confirmController.text.isEmpty || _confirmController.text != _newController.text) errors['confirm'] = 'كلمتا المرور غير متطابقتين';
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
      _success = errors.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تغيير كلمة المرور')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              CustomTextField(label: 'كلمة المرور الحالية', prefixIcon: Icons.lock_outline, controller: _currentController, obscureText: true, errorText: _errors['current'], textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'كلمة المرور الجديدة', prefixIcon: Icons.lock_reset_outlined, controller: _newController, obscureText: true, errorText: _errors['new'], textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'تأكيد كلمة المرور الجديدة', prefixIcon: Icons.verified_user_outlined, controller: _confirmController, obscureText: true, errorText: _errors['confirm'], textInputAction: TextInputAction.done),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'تغيير كلمة المرور', icon: Icons.check_rounded, onPressed: _changePassword),
              if (_success) ...[
                const SizedBox(height: AppSpacing.md),
                Text('تم تغيير كلمة المرور محلياً بنجاح.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
              ],
            ]),
          ),
        ),
      );
}

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _language = 'العربية';

  @override
  Widget build(BuildContext context) => _ChoiceScreen(title: 'لغة التطبيق', child: Column(children: ['العربية', 'English'].map((language) => _SelectionTile(title: language, selected: _language == language, onTap: () => setState(() => _language = language))).toList()));
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final Map<String, bool> _settings = {'تذكيرات المواعيد': true, 'تحديثات المواعيد': true, 'التنبيهات العامة': false};

  @override
  Widget build(BuildContext context) => _ChoiceScreen(title: 'الإشعارات', child: Column(children: _settings.keys.map((title) => SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, title: Text(title), value: _settings[title]!, activeColor: AppColors.primary, onChanged: (value) => setState(() => _settings[title] = value))).toList()));
}

class AppearanceScreen extends StatefulWidget {
  const AppearanceScreen({super.key});

  @override
  State<AppearanceScreen> createState() => _AppearanceScreenState();
}

class _AppearanceScreenState extends State<AppearanceScreen> {
  String _appearance = 'النظام';

  @override
  Widget build(BuildContext context) => _ChoiceScreen(title: 'المظهر', child: Column(children: ['النظام', 'فاتح', 'داكن'].map((appearance) => _SelectionTile(title: appearance, selected: _appearance == appearance, onTap: () => setState(() => _appearance = appearance))).toList()));
}

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) => _ChoiceScreen(title: 'المساعدة والدعم', child: Column(children: [
        _NavigationTile(icon: Icons.quiz_outlined, title: 'الأسئلة الشائعة', onTap: () => _showMessage(context, 'ستجد هنا إجابات عن أكثر الأسئلة شيوعاً.')),
        _NavigationTile(icon: Icons.mail_outline, title: 'تواصل معنا', onTap: () => _showMessage(context, 'يمكنك التواصل مع فريق Medicare من خلال هذه الواجهة قريباً.')),
        _NavigationTile(icon: Icons.report_problem_outlined, title: 'الإبلاغ عن مشكلة', onTap: () => _showMessage(context, 'تم فتح نموذج الإبلاغ المحلي.')),
      ]));

  static void _showMessage(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class AboutMedicareScreen extends StatelessWidget {
  const AboutMedicareScreen({super.key});

  @override
  Widget build(BuildContext context) => _ChoiceScreen(title: 'عن Medicare', child: Column(children: [
        const SizedBox(height: AppSpacing.md),
        const _BrandMark(),
        const SizedBox(height: AppSpacing.md),
        Text('Medicare', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        Text('منصة رعاية صحية تساعدك على اكتشاف الأطباء والعيادات وحجز مواعيدك بسهولة.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.xl),
        _NavigationTile(icon: Icons.info_outline, title: 'عن التطبيق', onTap: () {}),
        _NavigationTile(icon: Icons.privacy_tip_outlined, title: 'سياسة الخصوصية', onTap: () {}),
        _NavigationTile(icon: Icons.description_outlined, title: 'شروط الاستخدام', onTap: () {}),
        const SizedBox(height: AppSpacing.md),
        Text('الإصدار 1.0.0', style: Theme.of(context).textTheme.bodyMedium),
      ]));
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.patient, required this.onEdit});
  final PatientProfile patient;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => AppCard(child: Column(children: [
        const AppAvatar(initials: 'س أ', size: 82, backgroundColor: AppColors.mint),
        const SizedBox(height: AppSpacing.md),
        Text(patient.name, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xs),
        Text(patient.email, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        const StatusBadge(label: 'مريض', color: AppColors.primary),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(onPressed: onEdit, icon: const Icon(Icons.edit_outlined, size: 18), label: const Text('تعديل الملف الشخصي')),
      ]));
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => AppCard(child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 2), Text(value, style: Theme.of(context).textTheme.titleMedium)])),
      ]));
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({required this.icon, required this.title, required this.onTap, this.value, this.iconColor});
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final String? value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) => AppCard(padding: EdgeInsets.zero, child: ListTile(onTap: onTap, leading: Icon(icon, color: iconColor ?? AppColors.primary), title: Text(title), trailing: value == null ? const Icon(Icons.chevron_left_rounded, color: AppColors.muted) : Text(value!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700))));
}

class _SettingsSectionTitle extends StatelessWidget {
  const _SettingsSectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)));
}

class _ChoiceScreen extends StatelessWidget {
  const _ChoiceScreen({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl), child: child)));
}

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({required this.title, required this.selected, required this.onTap});
  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(padding: EdgeInsets.zero, child: ListTile(onTap: onTap, title: Text(title), trailing: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off_outlined, color: selected ? AppColors.primary : AppColors.muted)));
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.size = 68});
  final double size;

  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)), child: Icon(Icons.favorite_rounded, color: Colors.white, size: size * .48));
}