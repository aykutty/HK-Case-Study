class LoginSession {
  final String sessionId;
  final String status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String? approvedByUid;
  final DateTime? approvedAt;

  LoginSession({
    required this.sessionId,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.approvedByUid,
    this.approvedAt,
  });

  factory LoginSession.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return LoginSession(
      sessionId: documentId,
      status: map['status'],
      createdAt: map['createdAt'].toDate(),
      expiresAt: map['expiresAt'].toDate(),
      approvedByUid: map['approvedByUid'],
      approvedAt:
          map['approvedAt'] != null ? map['approvedAt'].toDate() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'approvedByUid': approvedByUid,
      'approvedAt': approvedAt,
    };
  }
}
