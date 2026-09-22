import 'package:flutter/material.dart';

import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_doctor_repository.dart';
import '../../domain/repositories/organization_doctors_repository.dart';
import '../../models/organization_doctor.dart';

class OrganizationDoctorsRepositoryImpl implements OrganizationDoctorsRepository {
  const OrganizationDoctorsRepositoryImpl();

  @override
  Future<List<OrganizationDoctor>> getOrganizationDoctors() async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || organizationId.isEmpty) throw StateError('لا توجد مؤسسة مرتبطة بجلسة المستخدم.');
    final doctors = await FirestoreDoctorRepository.instance.fetchDoctorsForOrganization(organizationId);
    return doctors.map((doctor) => OrganizationDoctor(
      id: doctor.id,
      name: doctor.name,
      initials: doctor.initials,
      specialty: doctor.specialty,
      clinic: doctor.clinic,
      phone: '',
      email: doctor.email,
      status: doctor.status.name,
      avatarColor: Colors.transparent,
      scheduleSummary: doctor.availability.isEmpty ? '' : '${doctor.availability.length} أيام متاحة',
    )).toList();
  }
}
