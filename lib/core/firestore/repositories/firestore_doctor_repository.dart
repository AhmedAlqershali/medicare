import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/account_role.dart';
import '../../auth/models/account_status.dart';
import '../../auth/models/doctor.dart';
import '../../auth/models/invitation.dart';
import '../../auth/models/invitation_status.dart';
import '../../auth/repositories/doctor_repository.dart';
import '../firestore_paths.dart';
import '../firestore_service.dart';

class FirestoreDoctorRepository implements DoctorRepository {
  FirestoreDoctorRepository._({FirestoreService? service}) : _service = service ?? FirestoreService();

  static final instance = FirestoreDoctorRepository._();

  final FirestoreService _service;

  @override
  Future<List<Doctor>> doctorsForOrganization(String organizationId) => fetchDoctorsForOrganization(organizationId);

  Future<List<Doctor>> fetchDoctorsForOrganization(String organizationId) async {
    final nestedSnapshot = await _service.doctorCollectionForOrganization(organizationId).get();
    final legacySnapshot = await _service.doctorCollection().where('organizationId', isEqualTo: organizationId).get();
    final doctors = <String, Doctor>{
      for (final document in nestedSnapshot.docs) document.id: Doctor.fromMap(document.data(), document.id),
    };
    for (final document in legacySnapshot.docs) {
      doctors[document.id] = Doctor.fromMap(document.data(), document.id);
    }
    return doctors.values.toList();
  }

  @override
  Future<Doctor?> doctorForId(String doctorId) => fetchDoctorById(doctorId);

  @override
  Future<Doctor> inviteDoctor({required String organizationId, required String name, required String email, required String specialty, required String invitedBy, String? clinicId, String? clinicName}) async {
    final now = DateTime.now();
    final trimmedEmail = email.trim().toLowerCase();
    final doctor = Doctor(
      id: doctorIdFor(organizationId, trimmedEmail),
      name: name.trim(),
      email: trimmedEmail,
      organizationId: organizationId,
      specialty: specialty.trim(),
      clinic: clinicName?.trim() ?? '',
      clinicId: clinicId,
      phone: '',
      status: AccountStatus.pending,
      initials: _initials(name),
      firebaseUid: null,
      availability: const {},
      createdAt: now,
      updatedAt: now,
    );
    final invitation = Invitation(
      id: doctor.id,
      email: trimmedEmail,
      role: AccountRole.doctor,
      invitedBy: invitedBy.trim(),
      organizationId: organizationId,
      status: InvitationStatus.pending,
      doctorId: doctor.id,
      clinicId: clinicId,
    );
    await _service.firestore.runTransaction((transaction) async {
      transaction.set(_service.doctorDocumentForOrganization(organizationId, doctor.id), doctor.toMap());
      transaction.set(_service.invitationDocument(organizationId, invitation.id), invitation.toMap());
    });
    return doctor;
  }

  String doctorIdFor(String organizationId, String email) => '${organizationId}_${email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    final legacy = await _service.doctorDocument(doctorId).get();
    if (legacy.exists && legacy.data() != null) return Doctor.fromMap(legacy.data()!, legacy.id);
    final snapshot = await _service.firestore.collectionGroup(FirestorePaths.doctors).where('id', isEqualTo: doctorId).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) throw StateError('تم العثور على أكثر من سجل طبيب بالمعرف نفسه.');
    return Doctor.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
  }

  Future<Doctor?> fetchDoctorByUid(String firebaseUid) async {
    final snapshot = await _service.doctorCollection().where('firebaseUid', isEqualTo: firebaseUid).limit(2).get();
    if (snapshot.docs.length > 1) throw StateError('تم العثور على أكثر من سجل طبيب مرتبط بنفس Firebase UID.');
    if (snapshot.docs.isNotEmpty) return Doctor.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
    final nestedSnapshot = await _service.firestore.collectionGroup(FirestorePaths.doctors).where('firebaseUid', isEqualTo: firebaseUid).limit(2).get();
    if (nestedSnapshot.docs.isEmpty) return null;
    if (nestedSnapshot.docs.length > 1) throw StateError('تم العثور على أكثر من سجل طبيب مرتبط بنفس Firebase UID.');
    return Doctor.fromMap(nestedSnapshot.docs.first.data(), nestedSnapshot.docs.first.id);
  }

  Future<Doctor?> fetchDoctorByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final snapshot = await _service.doctorCollection().where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (snapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من سجل طبيب بنفس البريد الإلكتروني.');
    }
    if (snapshot.docs.isNotEmpty) return Doctor.fromMap(snapshot.docs.first.data(), snapshot.docs.first.id);
    final nestedSnapshot = await _service.firestore.collectionGroup(FirestorePaths.doctors).where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (nestedSnapshot.docs.isEmpty) return null;
    if (nestedSnapshot.docs.length > 1) throw StateError('تم العثور على أكثر من سجل طبيب بنفس البريد الإلكتروني.');
    return Doctor.fromMap(nestedSnapshot.docs.first.data(), nestedSnapshot.docs.first.id);
  }

  Future<void> saveDoctor(Doctor doctor) async {
    await _service.doctorDocumentForOrganization(doctor.organizationId, doctor.id).set(doctor.toMap(), SetOptions(merge: true));
  }

  Future<void> linkFirebaseUid({required String doctorId, required String firebaseUid, required String email}) async {
    final doctor = await fetchDoctorById(doctorId);
    if (doctor == null) {
      throw StateError('لم يتم العثور على سجل الطبيب المطلوب.');
    }
    if (doctor.email.trim().toLowerCase() != email.trim().toLowerCase()) {
      throw StateError('البريد الإلكتروني للطبيب غير مطابق للسجل الموجود.');
    }
    if (doctor.firebaseUid != null && doctor.firebaseUid != firebaseUid) {
      throw StateError('هذا الطبيب مرتبط بالفعل بحساب Firebase مختلف ولا يمكن نقله.');
    }

    final updatedDoctor = Doctor(
      id: doctor.id,
      name: doctor.name,
      email: doctor.email,
      organizationId: doctor.organizationId,
      specialty: doctor.specialty,
      status: AccountStatus.active,
      initials: doctor.initials,
      firebaseUid: firebaseUid,
      availability: doctor.availability,
      clinic: doctor.clinic,
      clinicId: doctor.clinicId,
      phone: doctor.phone,
      location: doctor.location,
      rating: doctor.rating,
      reviews: doctor.reviews,
      experience: doctor.experience,
      bio: doctor.bio,
      services: doctor.services,
      createdAt: doctor.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveDoctor(updatedDoctor);
    final legacySnapshot = await _service.doctorDocument(updatedDoctor.id).get();
    if (legacySnapshot.exists) {
      await _service.doctorDocument(updatedDoctor.id).set(updatedDoctor.toMap(), SetOptions(merge: true));
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1).toUpperCase()}${parts.last.substring(0, 1).toUpperCase()}';
  }
}
