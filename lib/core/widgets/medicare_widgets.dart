import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

export 'info_row.dart';

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(AppSpacing.md)});
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [BoxShadow(color: Color(0x0A173A3A), blurRadius: 18, offset: Offset(0, 7))],
        ),
        child: child,
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, required this.onPressed, this.icon, this.isLoading = false});
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        child: FilledButton.icon(
          onPressed: isLoading ? null : onPressed,
          icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : icon == null ? const SizedBox.shrink() : Icon(icon, size: 19),
          label: Text(isLoading ? 'جارٍ التحميل...' : label),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: .55),
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
      );
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.label, this.hintText, this.prefixIcon, this.controller, this.obscureText = false, this.keyboardType, this.onChanged, this.errorText, this.validator, this.textInputAction, this.autofillHints});
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) => _TextField(
        label: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        errorText: errorText,
        validator: validator,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
      );
}

class _TextField extends StatefulWidget {
  const _TextField({required this.label, this.hintText, this.prefixIcon, this.controller, required this.obscureText, this.keyboardType, this.onChanged, this.errorText, this.validator, this.textInputAction, this.autofillHints});
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late bool _isObscured = widget.obscureText;

  @override
  void didUpdateWidget(covariant _TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                  icon: Icon(_isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  tooltip: _isObscured ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                )
              : null,
        ),
      );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          if (actionLabel != null) TextButton(onPressed: onAction, child: Text(actionLabel!)),
        ],
      );
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.color = AppColors.success});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(8)),
        child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
      );
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, required this.initials, this.size = 48, this.backgroundColor = AppColors.mint});
  final String initials;
  final double size;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: size / 2,
        backgroundColor: backgroundColor,
        child: Text(initials, style: TextStyle(color: AppColors.primaryDark, fontSize: size * .3, fontWeight: FontWeight.w800)),
      );
}

class ServiceTile extends StatelessWidget {
  const ServiceTile({super.key, required this.label, required this.icon, required this.color, required this.onTap});
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            Container(height: 56, width: 56, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: AppColors.primaryDark, size: 25)),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w600)),
          ]),
        ),
      );
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key, required this.currentIndex, required this.onTap});
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppColors.mint,
        height: 72,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'مواعيدي'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'الأطباء'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      );
}

class RoleBottomNavigationBar extends StatelessWidget {
  const RoleBottomNavigationBar({super.key, required this.currentIndex, required this.onTap, required this.destinations});
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppColors.mint,
        height: 72,
        destinations: destinations,
      );
}

class ClinicCard extends StatelessWidget {
  const ClinicCard({super.key, required this.name, required this.location});
  final String name;
  final String location;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Row(children: [
          const AppAvatar(initials: 'ع', size: 48, backgroundColor: AppColors.sky),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: Theme.of(context).textTheme.titleMedium),
            Text(location, style: Theme.of(context).textTheme.bodyMedium),
          ])),
          const Icon(Icons.chevron_left, color: AppColors.muted),
        ]),
      );
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message, this.icon = Icons.inbox_outlined});
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: AppColors.primary, size: 40),
        const SizedBox(height: AppSpacing.md),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
      ]);
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator(color: AppColors.primary));
}

class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, color: Color(0xFFC84C4C), size: 40),
        const SizedBox(height: AppSpacing.md),
        Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
        if (onRetry != null) TextButton(onPressed: onRetry, child: const Text('حاول مرة أخرى')),
      ]);
}