import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/account_status.dart';
import '../../auth/repositories/doctor_repository.dart';
import '../../auth/models/patient.dart';
import '../../auth/repositories/patient_repository.dart';
import '../firestore_paths.dart';
import '../firestore_service.dart';
import 'firestore_doctor_repository.dart';

class FirestorePatientRepository implements PatientRepository {
  FirestorePatientRepository._({FirestoreService? service, DoctorRepository? doctorRepository})
      : _service = service ?? FirestoreService(),
        _doctorRepository = doctorRepository ?? FirestoreDoctorRepository.instance;

  static final instance = FirestorePatientRepository._();

  final FirestoreService _service;
  final DoctorRepository _doctorRepository;

  @override
  Future<List<Patient>> patientsForDoctor(String doctorId) => fetchPatientsForDoctor(doctorId);

  Future<List<Patient>> fetchPatientsForDoctor(String doctorId) async {
    final doctor = await _doctorRepository.doctorForId(doctorId);
    if (doctor == null || doctor.organizationId.isEmpty) return [];
    final snapshot = await _service.patientCollectionForDoctor(doctor.organizationId, doctorId).get();
    final legacySnapshot = await _service.firestore.collection(FirestorePaths.patients).where('doctorId', isEqualTo: doctorId).where('organizationId', isEqualTo: doctor.organizationId).get();
    return _uniquePatients([
      ...snapshot.docs.map((document) => Patient.fromMap({...document.data(), 'id': document.id})),
      ...legacySnapshot.docs.map((document) => Patient.fromMap({...document.data(), 'id': document.id})),
    ]);
  }

  Future<List<Patient>> fetchPatientsForOrganization(String organizationId) async {
    if (organizationId.trim().isEmpty) throw StateError('Organization id is required to read patients.');
    final doctorsSnapshot = await _service.doctorCollectionForOrganization(organizationId).get();
    final nestedSnapshots = await Future.wait([
      for (final doctor in doctorsSnapshot.docs)
        _service.patientCollectionForDoctor(organizationId, doctor.id).get(),
    ]);
    final legacySnapshot = await _service.firestore.collection(FirestorePaths.patients).where('organizationId', isEqualTo: organizationId).get();
    return _uniquePatients([
      for (final snapshot in nestedSnapshots)
        ...snapshot.docs.map((document) => Patient.fromMap({...document.data(), 'id': document.id})),
      ...legacySnapshot.docs.map((document) => Patient.fromMap({...document.data(), 'id': document.id})),
    ]);
  }

  @override
  Future<Patient?> patientForId(String patientId) => fetchPatientById(patientId);

  @override
  Future<Patient> createPatient({required String doctorId, required String name, required String email, required String invitedBy}) async {
    final trimmedEmail = email.trim().toLowerCase();
    final doctor = await _doctorRepository.doctorForId(doctorId);
    if (doctor == null || doctor.organizationId.isEmpty) {
      throw StateError('لم يتم العثور على مؤسسة الطبيب قبل إنشاء سجل المريض.');
    }
    final now = DateTime.now();
    final patient = Patient(
      id: patientIdFor(doctorId, trimmedEmail),
      name: name.trim(),
      email: trimmedEmail,
      doctorId: doctorId,
      organizationId: doctor.organizationId,
      status: AccountStatus.pending,
      accountActivated: false,
      initials: _initials(name),
      firebaseUid: null,
      createdAt: now,
      updatedAt: now,
    );
    await _service.patientDocumentForDoctor(patient.organizationId, patient.doctorId, patient.id).set(patient.toMap());
    return patient;
  }

  String patientIdFor(String doctorId, String email) => '${doctorId}_${email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  Future<Patient?> fetchPatientById(String patientId) async {
    final nestedSnapshot = await _service.firestore.collectionGroup(FirestorePaths.patients).where('id', isEqualTo: patientId).limit(2).get();
    if (nestedSnapshot.docs.isNotEmpty) return Patient.fromMap({...nestedSnapshot.docs.first.data(), 'id': nestedSnapshot.docs.first.id});
    final snapshot = await _service.patientDocument(patientId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Patient.fromMap({...snapshot.data()!, 'id': snapshot.id});
  }

  Future<Patient?> fetchPatientByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final nestedSnapshot = await _service.firestore.collectionGroup(FirestorePaths.patients).where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (nestedSnapshot.docs.length == 1) return Patient.fromMap({...nestedSnapshot.docs.first.data(), 'id': nestedSnapshot.docs.first.id});
    if (nestedSnapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من سجل مريض بنفس البريد الإلكتروني. يتطلب ذلك تصحيحاً إدارياً.');
    }
    final snapshot = await _service.firestore.collection(FirestorePaths.patients).where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) throw StateError('تم العثور على أكثر من سجل مريض بنفس البريد الإلكتروني. يتطلب ذلك تصحيحاً إدارياً.');
    return Patient.fromMap({...snapshot.docs.first.data(), 'id': snapshot.docs.first.id});
  }

  Future<void> savePatient(Patient patient) async {
    await _service.patientDocumentForDoctor(patient.organizationId, patient.doctorId, patient.id).set(patient.toMap(), SetOptions(merge: true));
  }

  Future<void> updatePatientProfile({required String patientId, required String name, required String phone, required String birthDate, required String gender}) async {
    if (patientId.trim().isEmpty) throw StateError('Patient id is required before saving the profile.');
    final patient = await fetchPatientById(patientId);
    if (patient == null) throw StateError('لم يتم العثور على سجل المريض المطلوب.');
    await _service.patientDocumentForDoctor(patient.organizationId, patient.doctorId, patient.id).set({
      'name': name.trim(),
      'phone': phone.trim(),
      'birthDate': birthDate.trim(),
      'gender': gender.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> activatePatient({required String patientId, required String firebaseUid, required String email}) async {
    final patient = await fetchPatientById(patientId);
    if (patient == null) {
      throw StateError('لم يتم العثور على سجل المريض المطلوب.');
    }
    if (patient.email.trim().toLowerCase() != email.trim().toLowerCase()) {
      throw StateError('بريد المريض غير مطابق للسجل الموجود.');
    }
    if (patient.firebaseUid != null && patient.firebaseUid != firebaseUid) {
      throw StateError('هذا الحساب مربوط بالفعل بمستخدم Firebase آخر ولا يمكن نقله.' );
    }
    final now = DateTime.now();
    final updatedPatient = Patient(
      id: patient.id,
      name: patient.name,
      email: patient.email,
      doctorId: patient.doctorId,
      organizationId: patient.organizationId,
      status: patient.status,
      accountActivated: true,
      initials: patient.initials,
      phone: patient.phone,
      birthDate: patient.birthDate,
      gender: patient.gender,
      firebaseUid: firebaseUid,
      createdAt: patient.createdAt ?? now,
      updatedAt: now,
    );
    await _service.patientDocumentForDoctor(updatedPatient.organizationId, updatedPatient.doctorId, updatedPatient.id).set(updatedPatient.toMap(), SetOptions(merge: true));
  }

  List<Patient> _uniquePatients(Iterable<Patient> patients) {
    final unique = <String, Patient>{};
    for (final patient in patients) {
      final key = patient.firebaseUid?.trim().isNotEmpty == true
          ? 'uid:${patient.firebaseUid}'
          : patient.email.trim().isNotEmpty
              ? 'email:${patient.organizationId}:${patient.email.trim().toLowerCase()}'
              : 'id:${patient.id}';
      unique[key] = patient;
    }
    return unique.values.toList();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1).toUpperCase()}${parts.last.substring(0, 1).toUpperCase()}';
  }
}
