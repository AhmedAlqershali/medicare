import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../appointments/appointment_booking_screens.dart';
import '../appointments/models/appointment_booking_data.dart';
import '../doctors/doctors_screens.dart';
import 'data/mock_clinics.dart';
import 'models/clinic_model.dart';

part 'clinics_screens_clinics_list_screen_state.dart';
part 'clinics_screens_clinic_details_screen.dart';
part 'clinics_screens_clinic_list_card.dart';
part 'clinics_screens_clinic_doctor_card.dart';
part 'clinics_screens_clinic_info_row.dart';
part 'clinics_screens_specialty_chip.dart';
part 'clinics_screens_clinics_empty_state.dart';


class ClinicsListScreen extends StatefulWidget {
  const ClinicsListScreen({super.key});

  @override
  State<ClinicsListScreen> createState() => _ClinicsListScreenState();
}
