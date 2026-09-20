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

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'status': status.name,
      };

  static Organization fromMap(Map<String, dynamic> map) => Organization(
        id: map['id'] as String? ?? '',
        name: map['name'] as String? ?? '',
        email: map['email'] as String? ?? '',
        phone: map['phone'] as String? ?? '',
        location: map['location'] as String? ?? '',
        status: AccountStatus.values.firstWhere(
          (item) => item.name == (map['status'] as String? ?? AccountStatus.active.name),
          orElse: () => AccountStatus.active,
        ),
      );
}
