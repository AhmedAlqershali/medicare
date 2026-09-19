import '../models/account_role.dart';
import '../models/invitation.dart';

abstract class InvitationRepository {
  List<Invitation> invitationsFor({required String organizationId, AccountRole? role});
  Invitation? pendingInvitation({required AccountRole role, required String email});
}
