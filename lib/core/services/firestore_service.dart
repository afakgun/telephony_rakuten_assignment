import 'package:cloud_firestore/cloud_firestore.dart';
import '../../presentation/home/model/sms_message_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addSmsMessage(SmsMessageModel message) async {
    await _db.collection('sms_messages').add(message.toMap());
  }
}
