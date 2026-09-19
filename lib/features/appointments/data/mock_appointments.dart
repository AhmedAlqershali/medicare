import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/appointment_model.dart';
import '../models/appointment_status.dart';

const mockAppointments = [
  MockAppointment(doctorName: 'د. ريم الحربي', doctorInitials: 'ر ح', specialty: 'طب عام', clinicName: 'عيادات النخبة', location: 'حي العليا، الرياض', date: 'الثلاثاء، ٢٤ سبتمبر', time: '١٠:٣٠ صباحاً', type: 'زيارة في العيادة', status: AppointmentStatus.upcoming, avatarColor: AppColors.sky, notes: 'إحضار نتائج الفحوصات السابقة.'),
  MockAppointment(doctorName: 'د. ليان السالم', doctorInitials: 'ل س', specialty: 'طب الأطفال', clinicName: 'مركز الحياة الطبي', location: 'حي المروج، الرياض', date: 'الخميس، ٢٦ سبتمبر', time: '٠٤:٠٠ مساءً', type: 'استشارة', status: AppointmentStatus.upcoming, avatarColor: AppColors.peach),
  MockAppointment(doctorName: 'د. ناصر العتيبي', doctorInitials: 'ن ع', specialty: 'طب القلب', clinicName: 'مركز Medicare الطبي', location: 'حي الورود، الرياض', date: 'الأحد، ١٥ سبتمبر', time: '٠٩:٠٠ صباحاً', type: 'زيارة في العيادة', status: AppointmentStatus.completed, avatarColor: AppColors.mint),
  MockAppointment(doctorName: 'د. سارة المنصور', doctorInitials: 'س م', specialty: 'طب الأسنان', clinicName: 'عيادات الأمل', location: 'حي النخيل، الرياض', date: 'الاثنين، ٩ سبتمبر', time: '٠٥:٣٠ مساءً', type: 'زيارة في العيادة', status: AppointmentStatus.completed, avatarColor: AppColors.peach),
  MockAppointment(doctorName: 'د. عبير القحطاني', doctorInitials: 'ع ك', specialty: 'الجلدية', clinicName: 'مركز Medicare الطبي', location: 'حي الورود، الرياض', date: 'الأربعاء، ٤ سبتمبر', time: '١١:٠٠ صباحاً', type: 'استشارة', status: AppointmentStatus.cancelled, avatarColor: AppColors.sky),
];
