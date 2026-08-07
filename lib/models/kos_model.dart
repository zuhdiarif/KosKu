class KosModel {
  final String id;
  final String ownerId;
  final String name;
  final String address;
  final String? description;
  final int totalRooms;
  final DateTime createdAt;

  KosModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.address,
    this.description,
    required this.totalRooms,
    required this.createdAt,
  });

  factory KosModel.fromJson(Map<String, dynamic> json) {
    return KosModel(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String?,
      totalRooms: json['total_rooms'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'address': address,
      'description': description,
      'total_rooms': totalRooms,
      'created_at': createdAt.toIso8601String(),
    };
  }

  KosModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? address,
    String? description,
    int? totalRooms,
    DateTime? createdAt,
  }) {
    return KosModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      totalRooms: totalRooms ?? this.totalRooms,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
