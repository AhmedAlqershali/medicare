import 'package:flutter/material.dart';

import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_clinic_repository.dart';
import '../../domain/repositories/organization_clinics_repository.dart';
import '../../models/organization_clinic.dart';

class OrganizationClinicsRepositoryImpl implements OrganizationClinicsRepository {
  const OrganizationClinicsRepositoryImpl();

  @override
  Future<List<OrganizationClinic>> getOrganizationClinics() async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || organizationId.isEmpty) return const [];
    final clinics = await FirestoreClinicRepository.instance.fetchClinicsForOrganization(organizationId);
    return clinics.map((clinic) => OrganizationClinic(
      id: clinic['id'] as String? ?? '',
      name: clinic['name'] as String? ?? '',
      location: clinic['location'] as String? ?? '',
      phone: clinic['phone'] as String? ?? '',
      description: clinic['description'] as String? ?? '',
      status: clinic['status'] as String? ?? '',
      doctorsCount: clinic['doctorsCount'] as int? ?? 0,
      departmentsCount: clinic['departmentsCount'] as int? ?? 0,
      patientsCount: clinic['patientsCount'] as int? ?? 0,
      icon: Icons.local_hospital_outlined,
      color: Colors.transparent,
      departments: _strings(clinic['departments'] ?? clinic['specialties']),
    )).toList();
  }

  List<String> _strings(Object? value) => value is List ? value.map((item) => item.toString()).toList() : const [];
}
