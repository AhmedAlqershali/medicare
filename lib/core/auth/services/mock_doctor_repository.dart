import '../data/mock_medicare_store.dart';
import '../models/account_status.dart';
import '../models/doctor.dart';
import '../repositories/doctor_repository.dart';
import 'mock_auth_repository.dart';

class MockDoctorRepository implements DoctorRepository {
  MockDoctorRepository._(this._store, this._auth);

  static final instance = MockDoctorRepository._(MockMedicareStore.instance, MockAuthRepository.instance);

  final MockMedicareStore _store;
  final MockAuthRepository _auth;

  String? get currentOrganizationId => _auth.session.organizationId;

  String get currentInviterId => _auth.session.currentUser?.id ?? '';

  @override
  List<Doctor> doctorsForOrganization(String organizationId) {
    if (_auth.session.organizationId != organizationId) return const [];
    return _store.doctors.where((doctor) => doctor.organizationId == organizationId).toList();
  }

  @override
  Doctor? doctorForId(String doctorId) {
    if (_auth.session.doctorId != doctorId) return null;
    return _store.doctorById(doctorId);
  }

  @override
  Doctor inviteDoctor({required String organizationId, required String name, required String email, required String specialty, required String invitedBy}) {
    if (_auth.session.organizationId != organizationId) throw StateError('غير مصرح للمؤسسة الحالية بإضافة هذا الطبيب.');
    if (_store.organizationById(organizationId)?.status != AccountStatus.active) throw StateError('المؤسسة غير نشطة.');
    if (_store.doctors.any((doctor) => doctor.email.toLowerCase() == email.trim().toLowerCase())) throw StateError('يوجد حساب بهذا البريد الإلكتروني.');
    return _store.addDoctor(organizationId: organizationId, name: name, email: email.trim(), specialty: specialty, invitedBy: invitedBy);
  }
}
