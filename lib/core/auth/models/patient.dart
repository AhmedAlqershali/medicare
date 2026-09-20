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

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'doctorId': doctorId,
        'organizationId': organizationId,
        'status': status.name,
        'accountActivated': accountActivated,
        'initials': initials,
      };

  static Patient fromMap(Map<String, dynamic> map) => Patient(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        doctorId: map['doctorId'] as String? ?? '',
        organizationId: map['organizationId'] as String? ?? '',
        status: AccountStatus.values.firstWhere(
          (item) => item.name == (map['status'] as String? ?? AccountStatus.active.name),
          orElse: () => AccountStatus.active,
        ),
        accountActivated: map['accountActivated'] as bool? ?? false,
        initials: map['initials'] as String? ?? '',
      );
}
