import '../../auth/models/account_status.dart';
import '../../auth/models/patient.dart';
import '../../auth/repositories/patient_repository.dart';
import '../firestore_paths.dart';
import '../firestore_service.dart';

class FirestorePatientRepository implements PatientRepository {
  FirestorePatientRepository._({FirestoreService? service}) : _service = service ?? FirestoreService();

  static final instance = FirestorePatientRepository._();

  final FirestoreService _service;

  @override
  List<Patient> patientsForDoctor(String doctorId) => const [];

  @override
  Patient? patientForId(String patientId) => null;

  @override
  Patient createPatient({required String doctorId, required String name, required String email, required String invitedBy}) {
    final trimmedEmail = email.trim();
    final now = DateTime.now();
    final patient = Patient(
      id: patientIdFor(doctorId, trimmedEmail),
      name: name.trim(),
      email: trimmedEmail,
      doctorId: doctorId,
      organizationId: '',
      status: AccountStatus.pending,
      accountActivated: false,
      initials: _initials(name),
      firebaseUid: null,
      createdAt: now,
      updatedAt: now,
    );
    _service.firestore.collection(FirestorePaths.patients).doc(patient.id).set(patient.toMap());
    return patient;
  }

  String patientIdFor(String doctorId, String email) => '${doctorId}_${email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  Future<Patient?> fetchPatientById(String patientId) async {
    final snapshot = await _service.patientDocument(patientId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Patient.fromMap(snapshot.data()!);
  }

  Future<Patient?> fetchPatientByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final snapshot = await _service.firestore.collection(FirestorePaths.patients).where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من سجل مريض بنفس البريد الإلكتروني. يتطلب ذلك تصحيحاً إدارياً.');
    }
    return Patient.fromMap(snapshot.docs.first.data());
  }

  Future<void> savePatient(Patient patient) async {
    await _service.patientDocument(patient.id).set(patient.toMap(), SetOptions(merge: true));
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
      firebaseUid: firebaseUid,
      createdAt: patient.createdAt ?? now,
      updatedAt: now,
    );
    await _service.patientDocument(patientId).set(updatedPatient.toMap(), SetOptions(merge: true));
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1).toUpperCase()}${parts.last.substring(0, 1).toUpperCase()}';
  }
}
