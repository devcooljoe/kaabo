class TenantModel {
  final String id;
  final String userId;
  final String propertyId;
  final String landlordId;
  final double monthlyRent;
  final DateTime leaseStart;
  final DateTime leaseEnd;
  final DateTime nextPaymentDue;
  final TenantStatus status;
  final List<PaymentRecord> paymentHistory;
  final DateTime createdAt;

  TenantModel({
    required this.id,
    required this.userId,
    required this.propertyId,
    required this.landlordId,
    required this.monthlyRent,
    required this.leaseStart,
    required this.leaseEnd,
    required this.nextPaymentDue,
    required this.status,
    required this.paymentHistory,
    required this.createdAt,
  });

  factory TenantModel.fromMap(Map<String, dynamic> map) {
    return TenantModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      propertyId: map['propertyId'] ?? '',
      landlordId: map['landlordId'] ?? '',
      monthlyRent: (map['monthlyRent'] ?? 0).toDouble(),
      leaseStart: DateTime.parse(map['leaseStart']),
      leaseEnd: DateTime.parse(map['leaseEnd']),
      nextPaymentDue: DateTime.parse(map['nextPaymentDue']),
      status: TenantStatus.values.firstWhere(
        (e) => e.toString() == 'TenantStatus.${map['status']}',
        orElse: () => TenantStatus.active,
      ),
      paymentHistory:
          (map['paymentHistory'] as List? ?? [])
              .map((p) => PaymentRecord.fromMap(p))
              .toList(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'propertyId': propertyId,
      'landlordId': landlordId,
      'monthlyRent': monthlyRent,
      'leaseStart': leaseStart.toIso8601String(),
      'leaseEnd': leaseEnd.toIso8601String(),
      'nextPaymentDue': nextPaymentDue.toIso8601String(),
      'status': status.name,
      'paymentHistory': paymentHistory.map((p) => p.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class PaymentRecord {
  final String id;
  final double amount;
  final DateTime paidDate;
  final PaymentStatus status;
  final String? reference;

  PaymentRecord({
    required this.id,
    required this.amount,
    required this.paidDate,
    required this.status,
    this.reference,
  });

  factory PaymentRecord.fromMap(Map<String, dynamic> map) {
    return PaymentRecord(
      id: map['id'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      paidDate: DateTime.parse(map['paidDate']),
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${map['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      reference: map['reference'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'paidDate': paidDate.toIso8601String(),
      'status': status.name,
      'reference': reference,
    };
  }
}

enum TenantStatus { active, overdue, terminated }

enum PaymentStatus { paid, pending, overdue }
