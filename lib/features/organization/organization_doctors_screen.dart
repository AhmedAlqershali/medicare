import 'package:flutter/material.dart';

import '../../core/auth/models/account_status.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'add_doctor_screen.dart';
import 'models/organization_doctor.dart';

part 'organization_doctors_screen_organization_doctors_screen_state.dart';
part 'organization_doctors_screen_doctor_card.dart';
part 'organization_doctors_screen_organization_doctor_details_screen.dart';
part 'organization_doctors_screen_organization_doctor_details_screen_state.dart';
part 'organization_doctors_screen_organization_doctor_form_screen.dart';
part 'organization_doctors_screen_organization_doctor_form_screen_state.dart';


class OrganizationDoctorsScreen extends StatefulWidget {
  const OrganizationDoctorsScreen({super.key});

  @override
  State<OrganizationDoctorsScreen> createState() => _OrganizationDoctorsScreenState();
}
