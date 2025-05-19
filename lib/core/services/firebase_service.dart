import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logCallData({
    required String receiverNumber,
    required int durationInMinutes,
    required int callDurationInMinutes,
    required List<String> qualityStrengthList,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('calls').add({
          'userId': user.uid,
          'receiverNumber': receiverNumber,
          'selectedDurationInMinutes': durationInMinutes,
          'callDurationInMinutes': callDurationInMinutes,
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
}
