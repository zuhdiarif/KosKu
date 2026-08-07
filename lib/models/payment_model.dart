class PaymentModel {
  final String id;
  final String tenantId;
  final String roomId;
  final double amount;
  final DateTime? paymentDate;
  final DateTime dueDate;
  final String status;
  final String? proofUrl;
  final String? notes;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.tenantId,
    required this.roomId,
    required this.amount,
    this.paymentDate,
    required this.dueDate,
    this.status = 'pending',
    this.proofUrl,
    this.notes,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String? ?? '',
      tenantId: json['tenant_id'] as String? ?? '',
      roomId: json['room_id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      paymentDate: json['payment_date'] != null ? DateTime.tryParse(json['payment_date'].toString()) : null,
      dueDate: DateTime.tryParse(json['due_date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status'] as String? ?? 'pending',
      proofUrl: json['proof_url'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tenant_id': tenantId,
      'room_id': roomId,
      'amount': amount,
      'payment_date': paymentDate?.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'proof_url': proofUrl,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  PaymentModel copyWith({
    String? id,
    String? tenantId,
    String? roomId,
    double? amount,
    DateTime? paymentDate,
    DateTime? dueDate,
    String? status,
    String? proofUrl,
    String? notes,
    DateTime? createdAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      roomId: roomId ?? this.roomId,
      amount: amount ?? this.amount,
      paymentDate: paymentDate ?? this.paymentDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      proofUrl: proofUrl ?? this.proofUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
