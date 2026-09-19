import '../data/mock_medicare_store.dart';
import '../models/account_role.dart';
import '../models/invitation.dart';
import '../models/invitation_status.dart';
import '../repositories/invitation_repository.dart';
import 'mock_auth_repository.dart';

class MockInvitationRepository implements InvitationRepository {
  MockInvitationRepository._(this._store, this._auth);

  static final instance = MockInvitationRepository._(MockMedicareStore.instance, MockAuthRepository.instance);

  final MockMedicareStore _store;
  final MockAuthRepository _auth;

  @override
  List<Invitation> invitationsFor({required String organizationId, AccountRole? role}) {
    if (_auth.session.organizationId != organizationId) return const [];
    return _store.invitations.where((invitation) => invitation.organizationId == organizationId && (role == null || invitation.role == role)).toList();
  }

  @override
  Invitation? pendingInvitation({required AccountRole role, required String email}) => _store.invitations.where((invitation) => invitation.role == role && invitation.email == email.trim() && invitation.status == InvitationStatus.pending).firstOrNull;
}
