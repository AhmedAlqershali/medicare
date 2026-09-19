import 'package:flutter/material.dart';

import 'add_doctor_screen_state.dart';
import '../../core/auth/services/mock_doctor_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../auth/auth_widgets.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => AddDoctorScreenState();
}
