class RentalApplicationModel {
  final String id;
  final String propertyId;
  final String tenantId;
  final String landlordId;
  final String tenantName;
  final String tenantEmail;
  final String tenantPhone;
  final String occupation;
  final double monthlyIncome;
  final String employerName;
  final String previousAddress;
  final String emergencyContact;
  final ApplicationStatus status;
  final String? landlordNotes;
  final DateTime appliedAt;

  RentalApplicationModel({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.landlordId,
    required this.tenantName,
    required this.tenantEmail,
    required this.tenantPhone,
    required this.occupation,
    required this.monthlyIncome,
    required this.employerName,
    required this.previousAddress,
    required this.emergencyContact,
    required this.status,
    this.landlordNotes,
    required this.appliedAt,
  });

  factory RentalApplicationModel.fromMap(Map<String, dynamic> map) {
    return RentalApplicationModel(
      id: map['id'] ?? '',
      propertyId: map['propertyId'] ?? '',
      tenantId: map['tenantId'] ?? '',
      landlordId: map['landlordId'] ?? '',
      tenantName: map['tenantName'] ?? '',
      tenantEmail: map['tenantEmail'] ?? '',
      tenantPhone: map['tenantPhone'] ?? '',
      occupation: map['occupation'] ?? '',
      monthlyIncome: (map['monthlyIncome'] ?? 0).toDouble(),
      employerName: map['employerName'] ?? '',
      previousAddress: map['previousAddress'] ?? '',
      emergencyContact: map['emergencyContact'] ?? '',
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString() == 'ApplicationStatus.${map['status']}',
        orElse: () => ApplicationStatus.pending,
      ),
      landlordNotes: map['landlordNotes'],
      appliedAt: DateTime.parse(map['appliedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyId': propertyId,
      'tenantId': tenantId,
      'landlordId': landlordId,
      'tenantName': tenantName,
      'tenantEmail': tenantEmail,
      'tenantPhone': tenantPhone,
      'occupation': occupation,
      'monthlyIncome': monthlyIncome,
      'employerName': employerName,
      'previousAddress': previousAddress,
      'emergencyContact': emergencyContact,
      'status': status.name,
      'landlordNotes': landlordNotes,
      'appliedAt': appliedAt.toIso8601String(),
    };
  }
}

enum ApplicationStatus { pending, approved, rejected }