import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:telephony/telephony.dart';
import '../../models/sms_message_model.dart';
import '../../core/services/firestore_service.dart';

class HomeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Telephony telephony = Telephony.instance;

  Future<void> logCallData({
    required String receiverNumber,
    required int selectedDurationInMinutes,
    required int callDurationInSeconds,
    required List<int> qualityStrengthList,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('calls').add({
          'userId': user.uid,
          'receiverNumber': receiverNumber,
          'selectedDurationInMinutes': selectedDurationInMinutes,
          'callDurationInSeconds': callDurationInSeconds,
          'qualityStrengthList': qualityStrengthList,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print('Call data logged successfully for user: ${user.uid}');
      } else {
        print('User not logged in. Cannot log call data.');
      }
    } catch (e) {
      print('Error logging call data: $e');
    }
  }

  Future<Object?> getLastCallDataOfUser(String uid) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('calls').where('userId', isEqualTo: uid).orderBy('timestamp', descending: true).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot lastCallDoc = querySnapshot.docs.first;
        return lastCallDoc.data();
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching last call data: $e');
      return null;
    }
  }

  Future<void> sendSms(String receiverNumber, String messageBody, bool isSent, String uid) async {
    try {
      SmsMessageModel smsMessage = SmsMessageModel(
        receiverNumber: receiverNumber,
        messageBody: messageBody,
        uid: uid,
        isSent: isSent,
        timestamp: Timestamp.now(),
      );
      FirestoreService firestoreService = FirestoreService();
      await firestoreService.addSmsMessage(smsMessage);
      print('SMS data logged to Firestore');
    } catch (e) {
      print('Error logging SMS data to Firestore: $e');
    }
  }
}
