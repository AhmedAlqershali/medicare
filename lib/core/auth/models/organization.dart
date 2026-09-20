import 'account_status.dart';

class Organization {
  const Organization({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.status,
    this.firebaseUid,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final AccountStatus status;
  final String? firebaseUid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'status': status.name,
    };
    if (firebaseUid != null) map['firebaseUid'] = firebaseUid;
    if (createdAt != null) map['createdAt'] = createdAt!.toUtc().toIso8601String();
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toUtc().toIso8601String();
    return map;
  }

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
        firebaseUid: map['firebaseUid'] as String?,
        createdAt: map['createdAt'] is String ? DateTime.tryParse(map['createdAt'] as String) : null,
        updatedAt: map['updatedAt'] is String ? DateTime.tryParse(map['updatedAt'] as String) : null,
      );
}
