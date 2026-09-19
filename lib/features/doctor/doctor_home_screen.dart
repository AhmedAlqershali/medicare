import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'data/mock_doctor_appointments.dart';
import 'models/doctor_appointment.dart';
import 'doctor_appointments_screen.dart';
import 'doctor_patients_screen.dart';
import 'doctor_profile_screens.dart';

part 'doctor_home_screen_doctor_home_screen_state.dart';
part 'doctor_home_screen_doctor_dashboard.dart';
part 'doctor_home_screen_overview_grid.dart';
part 'doctor_home_screen_overview_card.dart';
part 'doctor_home_screen_dashboard_appointment_card.dart';
part 'doctor_home_screen_quick_actions.dart';
part 'doctor_home_screen_action.dart';


class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}
