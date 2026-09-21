import '../models/account_role.dart';
import '../models/invitation.dart';

abstract class InvitationRepository {
  Future<List<Invitation>> invitationsFor({required String organizationId, AccountRole? role});
  Future<Invitation?> pendingInvitation({required AccountRole role, required String email});
}
