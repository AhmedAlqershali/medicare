import '../../../core/theme/app_theme.dart';
import '../models/organization_doctor.dart';

const mockOrganizationDoctors = [
  OrganizationDoctor(id: 'doc-1', name: 'د. أحمد العتيبي', initials: 'أ ع', specialty: 'طب عام', clinic: 'العيادة المركزية', phone: '055 333 2222', email: 'ahmed@medicare.sa', status: 'نشط', avatarColor: AppColors.sky, scheduleSummary: 'السبت - الأربعاء 08:00 - 17:00'),
  OrganizationDoctor(id: 'doc-2', name: 'د. ليان السالم', initials: 'ل س', specialty: 'أطفال', clinic: 'عيادة النمو', phone: '055 444 5555', email: 'lian@medicare.sa', status: 'نشط', avatarColor: AppColors.mint, scheduleSummary: 'الأحد - الخميس 09:00 - 18:00'),
  OrganizationDoctor(id: 'doc-3', name: 'د. عمر أبو زيد', initials: 'ع ز', specialty: 'جلدية', clinic: 'مركز الجلدية', phone: '055 666 7777', email: 'omar@medicare.sa', status: 'غير متاح', avatarColor: AppColors.peach, scheduleSummary: 'الاثنين - الخميس 10:00 - 16:00'),
];
