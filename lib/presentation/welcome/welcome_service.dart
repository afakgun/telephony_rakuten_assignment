import 'welcome_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveForm(WelcomeFormModel model) async {
    // Örnek: form verilerini kaydet
    await Future.delayed(Duration(milliseconds: 300));
    // Şu an için sadece simülasyon
  }

  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: onError,
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
        print('Verification ID: $verificationId');
        print('Resend Token: $resendToken');
        // Burada SMS kodu gönderildiğinde yapılacak işlemler
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<void> saveUserToFirestore({
    required String uid,
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required String countryCode,
  }) async {
   final result = await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'lastName': lastName,
      'countryCode': countryCode,
      'createdAt': FieldValue.serverTimestamp(),
    });

  }

  Future<Map<String, dynamic>?> getUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      return data;
    } else {
      return null;
    }
  }
}
