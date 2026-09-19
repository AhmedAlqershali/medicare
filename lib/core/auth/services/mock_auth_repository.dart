import '../data/mock_medicare_store.dart';
import '../models/account_role.dart';
import '../models/account_status.dart';
import '../models/auth_result.dart';
import '../models/auth_session.dart';
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
    final user = _store.findUser(role: role, email: email);
    if (user == null) {
      final invitation = _store.invitations.where((item) => item.role == role && item.email.toLowerCase() == email.trim().toLowerCase()).firstOrNull;
      if (invitation != null && invitation.status == InvitationStatus.pending) {
        return const AuthResult(success: false, message: 'هذا الحساب مدعو، يرجى تفعيله أولاً.');
      }
      return const AuthResult(success: false, message: 'لم نجد حساباً نشطاً بهذا البريد لهذا الدور.');
    }
    if (_store.passwords[user.id] != password) return const AuthResult(success: false, message: 'البريد الإلكتروني أو كلمة المرور غير صحيحة.');
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
    if (role == AccountRole.patient && invitation.doctorId != null) {
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
  void logout() => _session = const AuthSession.signedOut();
}
