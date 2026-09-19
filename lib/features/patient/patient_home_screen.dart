import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../clinics/clinics_screens.dart';
import '../doctors/doctors_screens.dart';
import '../appointments/appointments_screens.dart';
import 'patient_profile_screens.dart';
import 'widgets/patient_appointment_card.dart';

part 'patient_home_screen_patient_home_screen_state.dart';
part 'patient_home_screen_home_content.dart';
part 'patient_home_screen_home_header.dart';
part 'patient_home_screen_quick_actions.dart';
part 'patient_home_screen_quick_action.dart';
part 'patient_home_screen_doctors_section.dart';
part 'patient_home_screen_doctor_card.dart';
part 'patient_home_screen_clinics_section.dart';


class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}
