import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:case_study/data/models/app_user.dart';

class UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<AppUser?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();

    if (!doc.exists) return null;

    return AppUser.fromMap(doc.data()!);
  }

  Future<void> onUserLogin({
    required String uid,
    required String phoneNumber,
  }) async {
    final docRef = _users.doc(uid);
    final now = Timestamp.now();
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': uid,
        'phoneNumber': phoneNumber,
        'createdAt': now,
        'lastLoginAt': now,
      });
    } else {
      await docRef.update({
        'lastLoginAt': now,
      });
    }
  }
}
