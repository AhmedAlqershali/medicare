import 'account_status.dart';

class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.organizationId,
    required this.specialty,
    required this.status,
    required this.initials,
  });

  final String id;
  final String name;
  final String email;
  final String organizationId;
  final String specialty;
  final AccountStatus status;
  final String initials;
}
