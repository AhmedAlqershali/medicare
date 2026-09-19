import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/auth/models/account_role.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'role_login_screen.dart';

export 'auth_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _animationController.forward();
    _navigationTimer = Timer(const Duration(milliseconds: 1500), _openOnboarding);
  }

  void _openOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const OnboardingScreen()));
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const _BrandMark(size: 78),
                const SizedBox(height: AppSpacing.md),
                Text('Medicare', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 30, color: AppColors.primaryDark)),
                const SizedBox(height: AppSpacing.xs),
                Text('رعايتك الصحية، أقرب إليك', style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
          ),
        ),
      );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _page = 0;

  static const _pages = [
    _OnboardingData(
      title: 'رعايتك الصحية تبدأ بسهولة',
      description: 'الوصول إلى العيادات والخدمات الصحية أصبح أقرب وأبسط.',
      icon: Icons.favorite_outline_rounded,
      color: AppColors.mint,
    ),
    _OnboardingData(
      title: 'اعثر على طبيبك بثقة',
      description: 'اكتشف الأطباء واحجز موعدك المناسب في خطوات واضحة.',
      icon: Icons.medical_services_outlined,
      color: AppColors.sky,
    ),
    _OnboardingData(
      title: 'كل مواعيدك في مكان واحد',
      description: 'تابع مواعيدك ورحلة رعايتك الصحية بكل راحة.',
      icon: Icons.calendar_month_outlined,
      color: AppColors.peach,
    ),
  ];

  void _next() {
    if (_page == _pages.length - 1) {
      _openUserType();
      return;
    }
    _pageController.nextPage(duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
  }

  void _skip() => _openUserType();

  void _openUserType() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const UserTypeScreen()));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
            child: Column(children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(onPressed: _skip, child: const Text('تخطي')),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var index = 0; index < _pages.length; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: index == _page ? 22 : 7,
                    height: 7,
                    decoration: BoxDecoration(color: index == _page ? AppColors.primary : AppColors.border, borderRadius: BorderRadius.circular(8)),
                  ),
              ]),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(label: _page == _pages.length - 1 ? 'ابدأ الآن' : 'التالي', onPressed: _next, icon: Icons.arrow_back_rounded),
            ]),
          ),
        ),
      );
}

class UserTypeScreen extends StatefulWidget {
  const UserTypeScreen({super.key});

  @override
  State<UserTypeScreen> createState() => _UserTypeScreenState();
}

class _UserTypeScreenState extends State<UserTypeScreen> {
  AccountRole _selectedRole = AccountRole.patient;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('اختر نوع الحساب', style: Theme.of(context).textTheme.headlineSmall),
              const Text('مرحبا سعيد'),
              const SizedBox(height: AppSpacing.xs),
              Text('لنقدم لك تجربة مناسبة لاحتياجاتك', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xl),
              _AccountTypeCard(
                title: 'مريض',
                description: 'احجز مواعيدك وتابع رعايتك الصحية',
                icon: Icons.person_outline_rounded,
                color: AppColors.mint,
                selected: _selectedRole == AccountRole.patient,
                onTap: () => setState(() => _selectedRole = AccountRole.patient),
              ),
              const SizedBox(height: AppSpacing.md),
              _AccountTypeCard(
                title: 'طبيب',
                description: 'أدر مواعيدك وتواصل مع مرضاك',
                icon: Icons.medical_information_outlined,
                color: AppColors.sky,
                selected: _selectedRole == AccountRole.doctor,
                onTap: () => setState(() => _selectedRole = AccountRole.doctor),
              ),
              const SizedBox(height: AppSpacing.md),
              _AccountTypeCard(
                title: 'مؤسسة طبية',
                description: 'أدر عياداتك وأطباءك وخدماتك الطبية',
                icon: Icons.business_outlined,
                color: AppColors.peach,
                selected: _selectedRole == AccountRole.organization,
                onTap: () => setState(() => _selectedRole = AccountRole.organization),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'متابعة', onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => RoleLoginScreen(role: _selectedRole)))),
            ]),
          ),
        ),
      );
}

class DoctorPlaceholderScreen extends StatelessWidget {
  const DoctorPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              const SizedBox(height: AppSpacing.lg),
              const _BrandMark(size: 68),
              const SizedBox(height: AppSpacing.lg),
              const Text('مرحبا خالد'),
              Text('تجربة الطبيب قريباً', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text('نجهّز لك مساحة مهنية تساعدك على إدارة مواعيدك والتواصل مع مرضاك بسهولة.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: AppSpacing.xl),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(children: [
                  Container(width: 52, height: 52, decoration: BoxDecoration(color: AppColors.sky, borderRadius: BorderRadius.circular(15)), child: const Icon(Icons.medical_information_outlined, color: AppColors.primaryDark, size: 27)),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const StatusBadge(label: 'قيد التجهيز', color: AppColors.primary),
                    const SizedBox(height: AppSpacing.xs),
                    Text('أدوات الطبيب ستتوفر قريباً', style: Theme.of(context).textTheme.titleMedium),
                  ])),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'العودة لاختيار الحساب', onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const UserTypeScreen()))),
            ]),
          ),
        ),
      );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(size * .28)),
        child: Icon(Icons.add_rounded, color: Colors.white, size: size * .52),
      );
}

class _OnboardingData {
  const _OnboardingData({required this.title, required this.description, required this.icon, required this.color});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});
  final _OnboardingData data;

  @override
  Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(color: data.color, borderRadius: BorderRadius.circular(28)),
          child: Stack(alignment: Alignment.center, children: [
            PositionedDirectional(top: 24, end: 28, child: Icon(Icons.add_rounded, color: AppColors.primary.withValues(alpha: .14), size: 54)),
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .72), shape: BoxShape.circle),
              child: Icon(data.icon, color: AppColors.primaryDark, size: 54),
            ),
          ]),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(data.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.sm),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 310),
          child: Text(data.description, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.muted)),
        ),
      ]);
}

class _AccountTypeCard extends StatelessWidget {
  const _AccountTypeCard({required this.title, required this.description, required this.icon, required this.color, required this.selected, required this.onTap});
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: selected ? color : AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: selected ? 1.5 : 1),
              boxShadow: selected ? const [BoxShadow(color: Color(0x0A173A3A), blurRadius: 14, offset: Offset(0, 5))] : null,
            ),
            child: Row(children: [
              Container(width: 52, height: 52, decoration: BoxDecoration(color: selected ? Colors.white.withValues(alpha: .65) : color, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: AppColors.primaryDark, size: 26)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(description, style: Theme.of(context).textTheme.bodyMedium),
              ])),
              Icon(selected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: selected ? AppColors.primary : AppColors.muted),
            ]),
          ),
        ),
      );
}
