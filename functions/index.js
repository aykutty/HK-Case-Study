const admin = require("firebase-admin");
admin.initializeApp();

const { onCall, HttpsError } = require("firebase-functions/v2/https");


exports.createWebLoginToken = onCall(async (request) => {
  const { sessionId } = request.data;
  console.log("createWebLoginToken called, sessionId:", sessionId);

  if (!sessionId) {
    throw new HttpsError("invalid-argument", "sessionId zorunlu");
  }

  const ref = admin.firestore().collection("login_sessions").doc(sessionId);
  const snap = await ref.get();

  if (!snap.exists) {
    throw new HttpsError("not-found", "Session bulunamadı");
  }

  const session = snap.data();
  console.log("Session status:", session.status, "approvedBy:", session.approvedBy);

  if (session.status !== "approved") {
    throw new HttpsError("failed-precondition", "Session henüz onaylanmadı");
  }

  const uid = session.approvedBy;
  if (!uid) {
    throw new HttpsError("failed-precondition", "approvedBy yok");
  }

  const token = await admin.auth().createCustomToken(uid);
  console.log("Custom token created for uid:", uid);

  return { token };
});

