import '../../auth/models/account_status.dart';
import '../../auth/models/doctor.dart';
import '../../auth/repositories/doctor_repository.dart';
import '../firestore_service.dart';

class FirestoreDoctorRepository implements DoctorRepository {
  FirestoreDoctorRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  @override
  List<Doctor> doctorsForOrganization(String organizationId) => const [];

  @override
  Doctor? doctorForId(String doctorId) => null;

  @override
  Doctor inviteDoctor({required String organizationId, required String name, required String email, required String specialty, required String invitedBy}) {
    final doctor = Doctor(
      id: doctorIdFor(organizationId, email),
      name: name,
      email: email.trim(),
      organizationId: organizationId,
      specialty: specialty,
      status: AccountStatus.pending,
      initials: _initials(name),
    );
    return doctor;
  }

  String doctorIdFor(String organizationId, String email) => '${organizationId}_${email.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_')}';

  Future<void> saveDoctor({required String organizationId, required Doctor doctor}) async {
    await _service.doctorDocument(organizationId, doctor.id).set(doctor.toMap());
  }

  Future<Doctor?> fetchDoctor(String organizationId, String doctorId) async {
    final snapshot = await _service.doctorDocument(organizationId, doctorId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Doctor.fromMap(snapshot.data()!);
  }

  Future<List<Doctor>> fetchDoctors(String organizationId) async {
    final snapshot = await _service.doctorCollection(organizationId).get();
    return snapshot.docs.map((document) => Doctor.fromMap(document.data())).toList();
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1).toUpperCase()}${parts.last.substring(0, 1).toUpperCase()}';
  }
}
