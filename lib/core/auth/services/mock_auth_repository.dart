import '../data/mock_medicare_store.dart';
import '../models/account_role.dart';
import '../models/account_status.dart';
import '../models/auth_result.dart';
import '../models/auth_session.dart';
import '../models/auth_user.dart';
import '../models/invitation_status.dart';
import '../repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository._(this._store);

  static final instance = MockAuthRepository._(MockMedicareStore.instance);

  final MockMedicareStore _store;
  AuthSession _session = const AuthSession.signedOut();

  @override
  AuthSession get session => _session;

  @override
  bool get isAuthenticated => _session.isAuthenticated;

  @override
  AuthUser? get currentUser => _session.currentUser;

  @override
  AccountRole? get currentRole => _session.currentRole;

  @override
  Future<AuthResult> login({required AccountRole role, required String email, required String password}) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = _store.findUser(role: role, email: email);
    if (user == null) {
      if (role == AccountRole.patient) {
        final patient = _store.patientByEmail(email);
        if (patient != null && !patient.accountActivated) {
          return const AuthResult(success: false, message: 'هذا الحساب غير مفعّل بعد. استخدم تفعيل حساب المريض أولاً.');
        }
      } else {
        final invitation = _store.invitations.where((item) => item.role == role && item.email.toLowerCase() == normalizedEmail).firstOrNull;
        if (invitation != null && invitation.status == InvitationStatus.pending) {
          return const AuthResult(success: false, message: 'هذا الحساب مدعو، يرجى تفعيله أولاً.');
        }
      }
      return const AuthResult(success: false, message: 'لم نجد حساباً نشطاً بهذا البريد لهذا الدور.');
    }

    final isDemoCredential = normalizedEmail == MockMedicareStore.demoEmail.toLowerCase() && password == MockMedicareStore.demoPassword;
    if (!isDemoCredential && _store.passwords[user.id] != password) {
      return const AuthResult(success: false, message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.');
    }

    _session = AuthSession(isAuthenticated: true, currentUser: user, currentRole: role, organizationId: user.organizationId, doctorId: user.doctorId, patientId: user.patientId);
    return AuthResult(success: true, message: 'تم تسجيل الدخول بنجاح.', session: _session);
  }

  @override
  Future<AuthResult> activateInvitation({required AccountRole role, required String email, required String password}) async {
    final invitation = _store.invitations.where((item) => item.role == role && item.email == email.trim()).firstOrNull;
    if (invitation == null) return const AuthResult(success: false, message: 'لم نجد دعوة بهذا البريد الإلكتروني.');
    if (invitation.status != InvitationStatus.pending) return const AuthResult(success: false, message: 'هذه الدعوة لم تعد متاحة.');
    if (password.length < 6) return const AuthResult(success: false, message: 'استخدم ٦ أحرف أو أكثر لكلمة المرور.');
    final organization = _store.organizationById(invitation.organizationId);
    if (organization == null) return const AuthResult(success: false, message: 'المؤسسة المرتبطة بالدعوة غير موجودة.');
    if (organization.status != AccountStatus.active) return const AuthResult(success: false, message: 'المؤسسة المرتبطة بالدعوة غير نشطة.');
    if (role == AccountRole.doctor && invitation.doctorId != null) {
      final doctor = _store.doctorById(invitation.doctorId!);
      if (doctor == null) return const AuthResult(success: false, message: 'الطبيب المرتبط بالدعوة غير موجود.');
      if (doctor.status != AccountStatus.active) return const AuthResult(success: false, message: 'لا يمكن تفعيل الدعوة قبل تفعيل الطبيب.');
    }
    _store.activateInvitation(invitation: invitation, password: password);
    final user = _store.findUser(role: role, email: email);
    if (user == null) return const AuthResult(success: false, message: 'تعذر تفعيل الحساب المحلي.');
    _session = AuthSession(isAuthenticated: true, currentUser: user, currentRole: role, organizationId: user.organizationId, doctorId: user.doctorId, patientId: user.patientId);
    return AuthResult(success: true, message: 'تم تفعيل الحساب المحلي بنجاح.', session: _session);
  }

  @override
  Future<AuthResult> activatePatientAccount({required String email, required String password}) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty) return const AuthResult(success: false, message: 'أدخل البريد الإلكتروني الخاص بالمريض.');
    if (password.length < 6) return const AuthResult(success: false, message: 'استخدم ٦ أحرف أو أكثر لكلمة المرور.');

    final patient = _store.patientByEmail(normalizedEmail);
    if (patient == null) {
      return const AuthResult(success: false, message: 'لا يوجد سجل مريض مطابق لهذا البريد الإلكتروني. استخدم نفس البريد الذي أضافه الطبيب.');
    }
    if (patient.accountActivated) {
      return const AuthResult(success: false, message: 'هذا الحساب مفعّل بالفعل. استخدم تسجيل الدخول العادي.');
    }

    final doctor = _store.doctorById(patient.doctorId);
    if (doctor == null) return const AuthResult(success: false, message: 'الطبيب المرتبط بهذا المريض غير موجود.');
    if (doctor.status != AccountStatus.active) return const AuthResult(success: false, message: 'الطبيب المرتبط بهذا المريض غير نشط.');

    final organization = _store.organizationById(patient.organizationId);
    if (organization == null) return const AuthResult(success: false, message: 'المؤسسة المرتبطة بهذا المريض غير موجودة.');
    if (organization.status != AccountStatus.active) return const AuthResult(success: false, message: 'المؤسسة المرتبطة بهذا المريض غير نشطة.');

    _store.activatePatientAccount(patientId: patient.id, password: password);
    final user = _store.findUser(role: AccountRole.patient, email: patient.email);
    if (user == null) return const AuthResult(success: false, message: 'تعذر تفعيل حساب المريض في الجلسة المحلية.');

    _session = AuthSession(isAuthenticated: true, currentUser: user, currentRole: AccountRole.patient, organizationId: user.organizationId, doctorId: user.doctorId, patientId: user.patientId);
    return AuthResult(success: true, message: 'تم تفعيل حساب المريض بنجاح.', session: _session);
  }

  @override
  void logout() => _session = const AuthSession.signedOut();
}
