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
    this.firebaseUid,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String organizationId;
  final String specialty;
  final AccountStatus status;
  final String initials;
  final String? firebaseUid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'organizationId': organizationId,
      'specialty': specialty,
      'status': status.name,
      'initials': initials,
    };
    if (firebaseUid != null) map['firebaseUid'] = firebaseUid;
    if (createdAt != null) map['createdAt'] = createdAt!.toUtc().toIso8601String();
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toUtc().toIso8601String();
    return map;
  }

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
        firebaseUid: map['firebaseUid'] as String?,
        createdAt: map['createdAt'] is String ? DateTime.tryParse(map['createdAt'] as String) : null,
        updatedAt: map['updatedAt'] is String ? DateTime.tryParse(map['updatedAt'] as String) : null,
      );
}
