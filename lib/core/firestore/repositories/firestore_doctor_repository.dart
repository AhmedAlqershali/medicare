import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/account_status.dart';
import '../../auth/models/doctor.dart';
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
    final snapshot = await _service.firestore.collection(FirestorePaths.doctors).where('organizationId', isEqualTo: organizationId).get();
    return snapshot.docs.map((document) => Doctor.fromMap(document.data())).toList();
  }

  @override
  Future<Doctor?> doctorForId(String doctorId) => fetchDoctorById(doctorId);

  @override
  Future<Doctor> inviteDoctor({required String organizationId, required String name, required String email, required String specialty, required String invitedBy}) async {
    final now = DateTime.now();
    final trimmedEmail = email.trim();
    final doctor = Doctor(
      id: doctorIdFor(organizationId, trimmedEmail),
      name: name.trim(),
      email: trimmedEmail,
      organizationId: organizationId,
      specialty: specialty.trim(),
      status: AccountStatus.pending,
      initials: _initials(name),
      firebaseUid: null,
      createdAt: now,
      updatedAt: now,
    );
    await _service.doctorDocument(doctor.id).set(doctor.toMap());
    return doctor;
  }

  String doctorIdFor(String organizationId, String email) => '${organizationId}_${email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  Future<Doctor?> fetchDoctorById(String doctorId) async {
    final snapshot = await _service.doctorDocument(doctorId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Doctor.fromMap(snapshot.data()!);
  }

  Future<Doctor?> fetchDoctorByUid(String firebaseUid) async {
    final snapshot = await _service.firestore.collection(FirestorePaths.doctors).where('firebaseUid', isEqualTo: firebaseUid).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من سجل طبيب مرتبط بنفس Firebase UID.');
    }
    return Doctor.fromMap(snapshot.docs.first.data());
  }

  Future<Doctor?> fetchDoctorByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final snapshot = await _service.firestore.collection(FirestorePaths.doctors).where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من سجل طبيب بنفس البريد الإلكتروني.');
    }
    return Doctor.fromMap(snapshot.docs.first.data());
  }

  Future<void> saveDoctor(Doctor doctor) async {
    await _service.doctorDocument(doctor.id).set(doctor.toMap(), SetOptions(merge: true));
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
      status: doctor.status,
      initials: doctor.initials,
      firebaseUid: firebaseUid,
      createdAt: doctor.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveDoctor(updatedDoctor);
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1).toUpperCase()}${parts.last.substring(0, 1).toUpperCase()}';
  }
}
