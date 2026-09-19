import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.title, required this.subtitle, required this.children, this.showBack = false});
  final String title;
  final String subtitle;
  final List<Widget> children;
  final bool showBack;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: showBack ? AppBar(leading: const BackButton()) : null,
        body: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xl),
            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              const _BrandMark(size: 50),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xl),
              ...children,
            ]),
          ),
        ),
      );
}

class AuthPrompt extends StatelessWidget {
  const AuthPrompt({required this.label, required this.action, required this.onPressed});
  final String label;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(onPressed: onPressed, child: Text(action)),
      ]);
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
