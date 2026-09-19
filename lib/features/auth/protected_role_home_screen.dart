import 'package:flutter/material.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/auth/models/account_role.dart';
import '../../core/auth/services/mock_auth_repository.dart';
import '../doctor/doctor_home_screen.dart';
import '../organization/organization_home_screen.dart';
import '../patient/patient_home_screen.dart';

class ProtectedRoleHomeScreen extends StatelessWidget {
  const ProtectedRoleHomeScreen({super.key, required this.role});

  final AccountRole role;

  @override
  Widget build(BuildContext context) {
    final session = MockAuthRepository.instance.session;
    if (!session.isAuthenticated || session.currentRole != role) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) AuthNavigation.openSignedOutFlow(context);
      });
      return const SizedBox.shrink();
    }
    return switch (role) {
      AccountRole.patient => const PatientHomeScreen(),
      AccountRole.doctor => const DoctorHomeScreen(),
      AccountRole.organization => const OrganizationHomeScreen(),
    };
  }
}
