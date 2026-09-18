import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../models/doctor_model.dart';

const doctors = [
  DoctorData(initials: 'ل س', name: 'د. ليان السالم', specialty: 'أطفال', clinic: 'مركز الحياة الطبي', location: 'حي المروج، الرياض', rating: '٤.٩', reviews: '١٢٨', experience: 12, bio: 'متخصصة في طب الأطفال والرعاية الوقائية، وتهتم بتقديم تجربة هادئة ومطمئنة للعائلة.', services: ['فحوصات الأطفال', 'التطعيمات', 'الرعاية الوقائية'], color: AppColors.peach),
  DoctorData(initials: 'ر ح', name: 'د. ريم الحربي', specialty: 'طب عام', clinic: 'عيادات النخبة', location: 'حي العليا، الرياض', rating: '٤.٨', reviews: '٩٦', experience: 9, bio: 'تقدم رعاية أولية شاملة مع اهتمام خاص بالمتابعة الصحية ونمط الحياة المتوازن.', services: ['الرعاية الأولية', 'الفحوصات العامة', 'الاستشارات'], color: AppColors.sky),
  DoctorData(initials: 'ن ع', name: 'د. ناصر العتيبي', specialty: 'قلب', clinic: 'مركز النور الطبي', location: 'حي الورود، الرياض', rating: '٤.٧', reviews: '٨٤', experience: 15, bio: 'استشاري قلب يركز على التشخيص المبكر والمتابعة الواضحة لصحة القلب.', services: ['تخطيط القلب', 'ضغط الدم', 'المتابعة'], color: AppColors.mint),
  DoctorData(initials: 'س م', name: 'د. سارة المنصور', specialty: 'أسنان', clinic: 'عيادات ابتسامة', location: 'حي النخيل، الرياض', rating: '٤.٩', reviews: '١١٢', experience: 8, bio: 'تقدم عناية متكاملة بالأسنان في بيئة مريحة ومناسبة لجميع أفراد العائلة.', services: ['تنظيف الأسنان', 'الحشوات', 'العناية الوقائية'], color: AppColors.peach),
  DoctorData(initials: 'ع ك', name: 'د. عبير القحطاني', specialty: 'جلدية', clinic: 'مركز نضارة', location: 'حي الصحافة، الرياض', rating: '٤.٨', reviews: '٧٣', experience: 10, bio: 'متخصصة في العناية بالبشرة والتشخيص الجلدي بخطة رعاية واضحة ومبسطة.', services: ['فحص البشرة', 'العلاج الموضعي', 'العناية بالبشرة'], color: AppColors.sky),
  DoctorData(initials: 'ه ر', name: 'د. هدى الراشد', specialty: 'نسائية', clinic: 'مركز الأسرة الطبي', location: 'حي الياسمين، الرياض', rating: '٤.٩', reviews: '١٠١', experience: 13, bio: 'تقدم رعاية نسائية شاملة باهتمام وخصوصية خلال مختلف مراحل الحياة.', services: ['الفحوصات الدورية', 'صحة المرأة', 'الاستشارات'], color: AppColors.mint),
];
