import '../../auth/models/account_role.dart';
import '../../auth/models/invitation.dart';
import '../../auth/repositories/invitation_repository.dart';
import '../firestore_service.dart';

class FirestoreInvitationRepository implements InvitationRepository {
  FirestoreInvitationRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  @override
  List<Invitation> invitationsFor({required String organizationId, AccountRole? role}) => const [];

  @override
  Invitation? pendingInvitation({required AccountRole role, required String email}) => null;

  Future<void> saveInvitation({required String organizationId, required Invitation invitation}) async {
    await _service.organizationDocument(organizationId).collection('invitations').doc(invitation.id).set(invitation.toMap());
  }
}
