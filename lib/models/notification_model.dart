class NotificationModel {
  final String id;
  final String ownerId;
  final String tenantId;
  final String title;
  final String message;
  final String type;
  final String sentVia;
  final bool isSent;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.ownerId,
    required this.tenantId,
    required this.title,
    required this.message,
    required this.type,
    required this.sentVia,
    this.isSent = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      ownerId: json['owner_id'] as String? ?? '',
      tenantId: json['tenant_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? '',
      sentVia: json['sent_via'] as String? ?? '',
      isSent: json['is_sent'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'tenant_id': tenantId,
      'title': title,
      'message': message,
      'type': type,
      'sent_via': sentVia,
      'is_sent': isSent,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? ownerId,
    String? tenantId,
    String? title,
    String? message,
    String? type,
    String? sentVia,
    bool? isSent,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      tenantId: tenantId ?? this.tenantId,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      sentVia: sentVia ?? this.sentVia,
      isSent: isSent ?? this.isSent,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
