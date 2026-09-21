import 'package:flutter/material.dart';

import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_clinic_repository.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/repositories/clinics_repository.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  const ClinicsRepositoryImpl();

  @override
  Future<List<ClinicEntity>> getClinics() async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || organizationId.isEmpty) return const [];
    final clinics = await FirestoreClinicRepository.instance.fetchClinicsForOrganization(organizationId);
    return clinics.map((clinic) => ClinicEntity(
      name: clinic['name'] as String? ?? '',
      category: clinic['category'] as String? ?? '',
      location: clinic['location'] as String? ?? '',
      description: clinic['description'] as String? ?? '',
      hours: clinic['hours'] as String? ?? '',
      specialties: _strings(clinic['specialties']),
      status: clinic['status'] as String? ?? '',
      icon: Icons.local_hospital_outlined,
      colorValue: Colors.transparent.value,
      doctors: const [],
    )).toList();
  }

  List<String> _strings(Object? value) => value is List ? value.map((item) => item.toString()).toList() : const [];
}
