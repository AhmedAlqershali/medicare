import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthSession _session = const AuthSession.signedOut();

  @override
  AuthSession get session => _session;

  @override
  bool get isAuthenticated => _session.isAuthenticated;

  @override
  AuthUser? get currentUser => _session.currentUser;

  @override
  AccountRole? get currentRole => _session.currentRole;

  bool _isDemoCredential({required String email, required String password}) => email.trim().toLowerCase() == MockMedicareStore.demoEmail.toLowerCase() && password == MockMedicareStore.demoPassword;

  AuthUser? _findLocalUser({required AccountRole role, required String email}) => _store.findUser(role: role, email: email);

  String _mapFirebaseAuthError(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح.';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب.';
      case 'user-not-found':
        return 'لا يوجد حساب مسجّل بهذا البريد.';
      case 'wrong-password':
        return 'البريد الإلكتروني أو كلمة المرور غير صحيحة.';
      case 'email-already-in-use':
        return 'هذا البريد مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة. استخدم ٦ أحرف أو أكثر.';
      case 'too-many-requests':
        return 'محاولات تسجيل الدخول كثيرة. حاول لاحقاً.';
      case 'network-request-failed':
        return 'فشل الاتصال. تأكد من اتصال الإنترنت.';
      default:
        return exception.message ?? 'حدث خطأ في المصادقة.';
    }
  }

  Future<AuthResult> _createFirebaseAccountIfNeeded({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email.trim(), password: password);
      return const AuthResult(success: true, message: 'تم إنشاء الحساب بنجاح.');
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'email-already-in-use') {
        try {
          await _firebaseAuth.signInWithEmailAndPassword(email: email.trim(), password: password);
          return const AuthResult(success: true, message: 'الحساب موجود بالفعل وتم تسجيل الدخول بنجاح.');
        } on FirebaseAuthException catch (signInException) {
          return AuthResult(success: false, message: _mapFirebaseAuthError(signInException));
        }
      }
      return AuthResult(success: false, message: _mapFirebaseAuthError(exception));
    }
  }

  @override
  Future<AuthResult> login({required AccountRole role, required String email, required String password}) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      return const AuthResult(success: false, message: 'أدخل البريد الإلكتروني وكلمة المرور.');
    }

    if (_isDemoCredential(email: normalizedEmail, password: password)) {
      final user = _findLocalUser(role: role, email: normalizedEmail);
      if (user == null) {
        return const AuthResult(success: false, message: 'لم نجد حساباً نشطاً بهذا البريد لهذا الدور.');
      }
      _session = AuthSession(isAuthenticated: true, currentUser: user, currentRole: role, organizationId: user.organizationId, doctorId: user.doctorId, patientId: user.patientId);
      return AuthResult(success: true, message: 'تم تسجيل الدخول بنجاح.', session: _session);
    }

    final localUser = _findLocalUser(role: role, email: normalizedEmail);
    if (localUser == null) {
      if (role == AccountRole.patient) {
        final patient = _store.patientByEmail(normalizedEmail);
        if (patient != null && !patient.accountActivated) {
          return const AuthResult(success: false, message: 'هذا الحساب غير مفعّل بعد. استخدم تفعيل حساب المريض أولاً.');
        }
      } else {
        final invitation = _store.invitations.where((item) => item.role == role && item.email.toLowerCase() == normalizedEmail.toLowerCase()).firstOrNull;
        if (invitation != null && invitation.status == InvitationStatus.pending) {
          return const AuthResult(success: false, message: 'هذا الحساب مدعو، يرجى تفعيله أولاً.');
        }
      }
      return const AuthResult(success: false, message: 'لم نجد حساباً نشطاً بهذا البريد لهذا الدور.');
    }

    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: normalizedEmail, password: password);
      _session = AuthSession(isAuthenticated: true, currentUser: localUser, currentRole: role, organizationId: localUser.organizationId, doctorId: localUser.doctorId, patientId: localUser.patientId);
      return AuthResult(success: true, message: 'تم تسجيل الدخول بنجاح.', session: _session);
    } on FirebaseAuthException catch (exception) {
      return AuthResult(success: false, message: _mapFirebaseAuthError(exception));
    }
  }

  @override
  Future<AuthResult> activateInvitation({required AccountRole role, required String email, required String password}) async {
    final normalizedEmail = email.trim();
    final invitation = _store.invitations.where((item) => item.role == role && item.email.toLowerCase() == normalizedEmail.toLowerCase()).firstOrNull;
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

    final firebaseResult = await _createFirebaseAccountIfNeeded(email: normalizedEmail, password: password);
    if (!firebaseResult.success) {
      return firebaseResult;
    }

    _store.activateInvitation(invitation: invitation, password: password);
    final user = _store.findUser(role: role, email: normalizedEmail);
    if (user == null) return const AuthResult(success: false, message: 'تعذر تفعيل الحساب المحلي.');
    _session = AuthSession(isAuthenticated: true, currentUser: user, currentRole: role, organizationId: user.organizationId, doctorId: user.doctorId, patientId: user.patientId);
    return AuthResult(success: true, message: 'تم تفعيل الحساب بنجاح.', session: _session);
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

    final firebaseResult = await _createFirebaseAccountIfNeeded(email: normalizedEmail, password: password);
    if (!firebaseResult.success) {
      return firebaseResult;
    }

    _store.activatePatientAccount(patientId: patient.id, password: password);
    final user = _store.findUser(role: AccountRole.patient, email: patient.email);
    if (user == null) return const AuthResult(success: false, message: 'تعذر تفعيل حساب المريض في الجلسة المحلية.');

    _session = AuthSession(isAuthenticated: true, currentUser: user, currentRole: AccountRole.patient, organizationId: user.organizationId, doctorId: user.doctorId, patientId: user.patientId);
    return AuthResult(success: true, message: 'تم تفعيل حساب المريض بنجاح.', session: _session);
  }

  @override
  void logout() {
    _firebaseAuth.signOut();
    _session = const AuthSession.signedOut();
  }
}
