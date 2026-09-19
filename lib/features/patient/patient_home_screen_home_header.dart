part of 'patient_home_screen.dart';

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const AppAvatar(initials: 'س', size: 50),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('صباح الخير، سارة', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 3),
          Text('نتمنى لك يوماً صحياً ومليئاً بالعافية', style: Theme.of(context).textTheme.bodyMedium),
        ])),
        IconButton(
          onPressed: _noop,
          icon: const Icon(Icons.notifications_none_rounded, size: 23),
          color: AppColors.ink,
          tooltip: 'الإشعارات',
          visualDensity: VisualDensity.compact,
        ),
      ]);

  static void _noop() {}
}
