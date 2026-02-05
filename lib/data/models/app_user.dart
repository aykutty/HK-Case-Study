import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  AppUser({
    required this.uid,
    required this.phoneNumber,
    required this.createdAt,
    required this.lastLoginAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      phoneNumber: map['phoneNumber'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
    };
  }
}
