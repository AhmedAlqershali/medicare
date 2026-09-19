import '../data/mock_medicare_store.dart';
import '../models/account_status.dart';
import '../models/patient.dart';
import '../repositories/patient_repository.dart';
import 'mock_auth_repository.dart';

class MockPatientRepository implements PatientRepository {
  MockPatientRepository._(this._store, this._auth);

  static final instance = MockPatientRepository._(MockMedicareStore.instance, MockAuthRepository.instance);

  final MockMedicareStore _store;
  final MockAuthRepository _auth;

  String? get currentDoctorId => _auth.session.doctorId;

  String get currentInviterId => _auth.session.currentUser?.id ?? '';

  @override
  List<Patient> patientsForDoctor(String doctorId) {
    if (_auth.session.doctorId != doctorId) return const [];
    return _store.patients.where((patient) => patient.doctorId == doctorId && patient.organizationId == _auth.session.organizationId).toList();
  }

  @override
  Patient? patientForId(String patientId) {
    if (_auth.session.patientId != patientId) return null;
    return _store.patientById(patientId);
  }

  @override
  Patient createPatient({required String doctorId, required String name, required String email, required String invitedBy}) {
    if (_auth.session.doctorId != doctorId) throw StateError('غير مصرح للطبيب الحالي بإضافة هذا المريض.');
    final doctor = _store.doctorById(doctorId);
    if (doctor == null || doctor.organizationId != _auth.session.organizationId) throw StateError('الطبيب أو المؤسسة غير موجودة.');
    if (doctor.status != AccountStatus.active) throw StateError('الطبيب غير نشط.');
    if (_store.patients.any((patient) => patient.email.toLowerCase() == email.trim().toLowerCase())) throw StateError('يوجد حساب بهذا البريد الإلكتروني.');
    return _store.addPatient(doctorId: doctorId, name: name, email: email.trim());
  }
}
