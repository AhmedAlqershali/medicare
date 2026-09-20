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

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'organizationId': organizationId,
        'specialty': specialty,
        'status': status.name,
        'initials': initials,
      };

  static Doctor fromMap(Map<String, dynamic> map) => Doctor(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        organizationId: map['organizationId'] as String? ?? '',
        specialty: map['specialty'] as String? ?? '',
        status: AccountStatus.values.firstWhere(
          (item) => item.name == (map['status'] as String? ?? AccountStatus.active.name),
          orElse: () => AccountStatus.active,
        ),
        initials: map['initials'] as String? ?? '',
      );
}
