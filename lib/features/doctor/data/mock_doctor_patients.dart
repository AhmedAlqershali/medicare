import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/doctor_patient.dart';

const doctorPatients = [
  DoctorPatient(name: 'سارة أحمد', initials: 'س أ', age: '٢٨ سنة', gender: 'أنثى', lastAppointment: '٢٤ سبتمبر ٢٠٢٦', status: 'متابعة منتظمة', avatarColor: AppColors.mint, notes: 'تتابع الخطة العلاجية بشكل جيد وتحتاج إلى مراجعة النتائج القادمة.'),
  DoctorPatient(name: 'خالد محمد', initials: 'خ م', age: '٤٢ سنة', gender: 'ذكر', lastAppointment: '٢٤ سبتمبر ٢٠٢٦', status: 'يحتاج متابعة', avatarColor: AppColors.sky, notes: 'مراجعة ضغط الدم والأعراض الأخيرة في الزيارة القادمة.'),
  DoctorPatient(name: 'نورة علي', initials: 'ن ع', age: '٣٥ سنة', gender: 'أنثى', lastAppointment: '١٨ سبتمبر ٢٠٢٦', status: 'مستقر', avatarColor: AppColors.peach, notes: 'تحسن ملحوظ منذ الزيارة السابقة.'),
  DoctorPatient(name: 'عبدالله حسن', initials: 'ع ح', age: '٥١ سنة', gender: 'ذكر', lastAppointment: '١٢ سبتمبر ٢٠٢٦', status: 'متابعة منتظمة', avatarColor: AppColors.sky, notes: 'مراجعة الأدوية الحالية في الموعد القادم.'),
  DoctorPatient(name: 'ريم فهد', initials: 'ر ف', age: '٣١ سنة', gender: 'أنثى', lastAppointment: '٥ سبتمبر ٢٠٢٦', status: 'مستقر', avatarColor: AppColors.mint, notes: 'لا توجد ملاحظات إضافية حالياً.'),
];
