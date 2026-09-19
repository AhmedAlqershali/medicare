part of 'organization_home_screen.dart';

class _ClinicPreviewCard extends StatelessWidget {
  const _ClinicPreviewCard({required this.clinic, required this.onTap});
  final OrganizationClinic clinic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => AppCard(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20), child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: clinic.color, borderRadius: BorderRadius.circular(15)), child: Icon(clinic.icon, color: AppColors.primaryDark, size: 24)), const SizedBox(width: AppSpacing.sm), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(clinic.name, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 3), Text(clinic.location, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: 3), Text('${clinic.doctorsCount} أطباء', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11))])), StatusBadge(label: clinic.status, color: AppColors.success)])));
}
