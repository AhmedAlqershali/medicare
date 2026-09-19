import 'account_status.dart';

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.status,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final AccountStatus status;
}
