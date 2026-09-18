import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/doctor_appointment.dart';

const doctorAppointments = [
  DoctorAppointment(patientName: 'سارة أحمد', patientInitials: 'س أ', age: '٢٨ سنة', gender: 'أنثى', date: 'اليوم، ٢٤ سبتمبر', time: '٠٩:٠٠ صباحاً', type: 'زيارة في العيادة', status: DoctorAppointmentFilter.today, notes: 'مراجعة نتائج التحاليل ومتابعة الخطة العلاجية.', avatarColor: AppColors.mint),
  DoctorAppointment(patientName: 'خالد محمد', patientInitials: 'خ م', age: '٤٢ سنة', gender: 'ذكر', date: 'اليوم، ٢٤ سبتمبر', time: '١٠:٣٠ صباحاً', type: 'استشارة', status: DoctorAppointmentFilter.today, notes: 'متابعة ضغط الدم والأعراض الأخيرة.', avatarColor: AppColors.sky),
  DoctorAppointment(patientName: 'نورة علي', patientInitials: 'ن ع', age: '٣٥ سنة', gender: 'أنثى', date: 'غداً، ٢٥ سبتمبر', time: '٠١:٠٠ مساءً', type: 'زيارة متابعة', status: DoctorAppointmentFilter.upcoming, notes: 'متابعة التحسن بعد الزيارة السابقة.', avatarColor: AppColors.peach),
  DoctorAppointment(patientName: 'عبدالله حسن', patientInitials: 'ع ح', age: '٥١ سنة', gender: 'ذكر', date: 'الخميس، ٢٦ سبتمبر', time: '٠٤:٠٠ مساءً', type: 'زيارة في العيادة', status: DoctorAppointmentFilter.upcoming, notes: 'مراجعة الأدوية الحالية.', avatarColor: AppColors.sky),
  DoctorAppointment(patientName: 'ريم فهد', patientInitials: 'ر ف', age: '٣١ سنة', gender: 'أنثى', date: 'الأحد، ١٥ سبتمبر', time: '١١:٠٠ صباحاً', type: 'استشارة', status: DoctorAppointmentFilter.completed, notes: 'تمت المتابعة بنجاح.', avatarColor: AppColors.mint),
  DoctorAppointment(patientName: 'ماجد سالم', patientInitials: 'م س', age: '٣٩ سنة', gender: 'ذكر', date: 'الاثنين، ٩ سبتمبر', time: '٠٥:٣٠ مساءً', type: 'زيارة في العيادة', status: DoctorAppointmentFilter.cancelled, notes: 'تم إلغاء الموعد من قبل المريض.', avatarColor: AppColors.peach),
];
