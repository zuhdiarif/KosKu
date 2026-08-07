class RoomModel {
  final String id;
  final String kosId;
  final String roomNumber;
  final int? floor;
  final double price;
  final String status;
  final Map<String, dynamic>? facilities;
  final DateTime createdAt;

  RoomModel({
    required this.id,
    required this.kosId,
    required this.roomNumber,
    this.floor,
    required this.price,
    this.status = 'available',
    this.facilities,
    required this.createdAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] as String? ?? '',
      kosId: json['kos_id'] as String? ?? '',
      roomNumber: json['room_number'] as String? ?? '',
      floor: json['floor'] as int?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'available',
      facilities: json['facilities'] as Map<String, dynamic>?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kos_id': kosId,
      'room_number': roomNumber,
      'floor': floor,
      'price': price,
      'status': status,
      'facilities': facilities,
      'created_at': createdAt.toIso8601String(),
    };
  }

  RoomModel copyWith({
    String? id,
    String? kosId,
    String? roomNumber,
    int? floor,
    double? price,
    String? status,
    Map<String, dynamic>? facilities,
    DateTime? createdAt,
  }) {
    return RoomModel(
      id: id ?? this.id,
      kosId: kosId ?? this.kosId,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      price: price ?? this.price,
      status: status ?? this.status,
      facilities: facilities ?? this.facilities,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
