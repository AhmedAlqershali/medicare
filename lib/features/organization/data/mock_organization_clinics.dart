import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/organization_clinic.dart';

const mockOrganizationClinics = [
  OrganizationClinic(id: 'clinic-1', name: 'العيادة المركزية', location: 'حي العليا، الرياض', phone: '055 123 4567', description: 'عيادة متعددة التخصصات تقدم خدمات رعاية أولية ومتابعة مستمرة.', status: 'نشطة', doctorsCount: 12, departmentsCount: 6, patientsCount: 320, icon: Icons.local_hospital_rounded, color: AppColors.sky, departments: ['باطنية', 'أطفال', 'أسنان', 'جلدية', 'قلب', 'نسائية']),
  OrganizationClinic(id: 'clinic-2', name: 'عيادة النمو', location: 'حي النخيل، الرياض', phone: '055 987 6543', description: 'رعاية متخصصة للأطفال والنساء مع متابعة دقيقة للمرضى.', status: 'نشطة', doctorsCount: 8, departmentsCount: 4, patientsCount: 210, icon: Icons.medical_services_rounded, color: AppColors.mint, departments: ['أطفال', 'نسائية', 'باطنية', 'جلدية']),
  OrganizationClinic(id: 'clinic-3', name: 'مركز الجلدية', location: 'حي الملقا، الرياض', phone: '056 111 2233', description: 'عيادة متخصصة في تشخيص وعلاج الأمراض الجلدية.', status: 'غير متاحة', doctorsCount: 5, departmentsCount: 2, patientsCount: 120, icon: Icons.healing_rounded, color: AppColors.peach, departments: ['جلدية', 'أسنان']),
];
