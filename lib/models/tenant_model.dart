class TenantModel {
  final String id;
  final String roomId;
  final String kosId;
  final String name;
  final String phone;
  final String? email;
  final String? idCardNumber;
  final DateTime startDate;
  final DateTime? endDate;
  final String status;
  final DateTime createdAt;

  TenantModel({
    required this.id,
    required this.roomId,
    required this.kosId,
    required this.name,
    required this.phone,
    this.email,
    this.idCardNumber,
    required this.startDate,
    this.endDate,
    this.status = 'active',
    required this.createdAt,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    return TenantModel(
      id: json['id'] as String? ?? '',
      roomId: json['room_id'] as String? ?? '',
      kosId: json['kos_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String?,
      idCardNumber: json['id_card_number'] as String?,
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      endDate: json['end_date'] != null ? DateTime.tryParse(json['end_date'].toString()) : null,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'kos_id': kosId,
      'name': name,
      'phone': phone,
      'email': email,
      'id_card_number': idCardNumber,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  TenantModel copyWith({
    String? id,
    String? roomId,
    String? kosId,
    String? name,
    String? phone,
    String? email,
    String? idCardNumber,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    DateTime? createdAt,
  }) {
    return TenantModel(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      kosId: kosId ?? this.kosId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
