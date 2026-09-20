import '../../auth/models/account_status.dart';
import '../../auth/models/patient.dart';
import '../../auth/repositories/patient_repository.dart';
import '../firestore_service.dart';

class FirestorePatientRepository implements PatientRepository {
  FirestorePatientRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  @override
  List<Patient> patientsForDoctor(String doctorId) => const [];

  @override
  Patient? patientForId(String patientId) => null;

  @override
  Patient createPatient({required String doctorId, required String name, required String email, required String invitedBy}) {
    final patient = Patient(
      id: patientIdFor(doctorId, email),
      name: name,
      email: email.trim(),
      doctorId: doctorId,
      organizationId: '',
      status: AccountStatus.pending,
      accountActivated: false,
      initials: _initials(name),
    );
    return patient;
  }

  String patientIdFor(String doctorId, String email) => '${doctorId}_${email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  Future<void> savePatient({required String organizationId, required String doctorId, required Patient patient}) async {
    await _service.patientDocument(organizationId, doctorId, patient.id).set(patient.toMap());
  }

  Future<Patient?> fetchPatient(String organizationId, String doctorId, String patientId) async {
    final snapshot = await _service.patientDocument(organizationId, doctorId, patientId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Patient.fromMap(snapshot.data()!);
  }

  Future<List<Patient>> fetchPatients(String organizationId, String doctorId) async {
    final snapshot = await _service.patientCollection(organizationId, doctorId).get();
    return snapshot.docs.map((document) => Patient.fromMap(document.data())).toList();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1).toUpperCase()}${parts.last.substring(0, 1).toUpperCase()}';
  }
}
