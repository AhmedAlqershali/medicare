import 'account_role.dart';
import 'auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.isAuthenticated,
    this.currentUser,
    this.currentRole,
    this.organizationId,
    this.doctorId,
    this.patientId,
  });

  const AuthSession.signedOut() : this(isAuthenticated: false);

  final bool isAuthenticated;
  final AuthUser? currentUser;
  final AccountRole? currentRole;
  final String? organizationId;
  final String? doctorId;
  final String? patientId;
}
