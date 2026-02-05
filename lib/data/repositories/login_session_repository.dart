import 'package:cloud_firestore/cloud_firestore.dart';

class LoginSessionRepository {
  final _sessions = FirebaseFirestore.instance.collection('login_sessions');

  Future<String> createSession() async {
    final doc = _sessions.doc();

    final now = DateTime.now();

    await doc.set({
      'status': 'pending',
      'createdAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(now.add(const Duration(minutes: 3))),
      'approvedBy': null,
      'approvedAt': null,
    });

    return doc.id;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchSession(
    String sessionId,
  ) {
    return _sessions.doc(sessionId).snapshots();
  }

  Future<void> approveSession({
    required String sessionId,
    required String userId,
  }) async {
    final ref = _sessions.doc(sessionId);
    final snap = await ref.get();

    if (!snap.exists) {
      throw Exception('Session bulunamadı');
    }

    final data = snap.data()!;
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();

    if (DateTime.now().isAfter(expiresAt)) {
      throw Exception('Session süresi dolmuş');
    }

    if (data['status'] != 'pending') {
      throw Exception('Session zaten kullanılmış');
    }

    await ref.update({
      'status': 'approved',
      'approvedBy': userId,
      'approvedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getSession(String id) {
    return FirebaseFirestore.instance
        .collection('login_sessions')
        .doc(id)
        .get();
  }
}
