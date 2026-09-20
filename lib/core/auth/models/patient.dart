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
    this.firebaseUid,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String email;
  final String doctorId;
  final String organizationId;
  final AccountStatus status;
  final bool accountActivated;
  final String initials;
  final String? firebaseUid;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'doctorId': doctorId,
      'organizationId': organizationId,
      'status': status.name,
      'accountActivated': accountActivated,
      'initials': initials,
    };
    if (firebaseUid != null) map['firebaseUid'] = firebaseUid;
    if (createdAt != null) map['createdAt'] = createdAt!.toUtc().toIso8601String();
    if (updatedAt != null) map['updatedAt'] = updatedAt!.toUtc().toIso8601String();
    return map;
  }

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
        firebaseUid: map['firebaseUid'] as String?,
        createdAt: map['createdAt'] is String ? DateTime.tryParse(map['createdAt'] as String) : null,
        updatedAt: map['updatedAt'] is String ? DateTime.tryParse(map['updatedAt'] as String) : null,
      );
}
