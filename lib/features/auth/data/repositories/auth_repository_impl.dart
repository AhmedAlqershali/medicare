import '../../../../core/auth/models/account_role.dart';
import '../../domain/entities/user_account.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl._({FirebaseAuthDataSource? dataSource}) : _dataSource = dataSource ?? FirebaseAuthDataSource();

  static final instance = AuthRepositoryImpl._();

  final FirebaseAuthDataSource _dataSource;

  @override
  UserAccount? get currentUser => _dataSource.currentUser == null ? null : UserAccount(
        id: _dataSource.currentUser!.id,
        name: _dataSource.currentUser!.name,
        email: _dataSource.currentUser!.email,
        role: _dataSource.currentUser!.role,
        organizationId: _dataSource.currentUser!.organizationId,
        doctorId: _dataSource.currentUser!.doctorId,
        patientId: _dataSource.currentUser!.patientId,
      );

  @override
  AccountRole? get currentRole => _dataSource.currentRole;

  @override
  bool get isAuthenticated => _dataSource.isAuthenticated;

  @override
  Future<AuthResult> login({required AccountRole role, required String email, required String password}) async {
    final result = await _dataSource.login(role: role, email: email, password: password);
    return AuthResult(success: result.success, message: result.message, user: result.user);
  }

  @override
  Future<AuthResult> activateInvitation({required AccountRole role, required String email, required String password}) async {
    final result = await _dataSource.activateInvitation(role: role, email: email, password: password);
    return AuthResult(success: result.success, message: result.message, user: result.user);
  }

  @override
  Future<AuthResult> activatePatientAccount({required String email, required String password}) async {
    final result = await _dataSource.activatePatientAccount(email: email, password: password);
    return AuthResult(success: result.success, message: result.message, user: result.user);
  }

  @override
  void logout() {
    _dataSource.logout();
  }
}
