import 'account_status.dart';

class Patient {
  const Patient({
    required this.id,
    required this.name,
    required this.email,
    required this.doctorId,
    required this.organizationId,
    required this.status,
    required this.accountActivated,
    required this.initials,
  });

  final String id;
  final String name;
  final String email;
  final String doctorId;
  final String organizationId;
  final AccountStatus status;
  final bool accountActivated;
  final String initials;
}
