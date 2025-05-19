import 'package:cloud_firestore/cloud_firestore.dart';

class SmsMessageModel {
  final String receiverNumber;
  final String messageBody;
  final String uid; // Assuming a user ID is available
  final bool isSent;
  final Timestamp timestamp;

  SmsMessageModel({
    required this.receiverNumber,
    required this.messageBody,
    required this.uid,
    required this.isSent,
    required this.timestamp,
  });

  factory SmsMessageModel.fromMap(Map<String, dynamic> map) {
    return SmsMessageModel(
      receiverNumber: map['receiverNumber'] ?? '',
      messageBody: map['messageBody'] ?? '',
      uid: map['uid'] ?? '',
      isSent: map['isSent'] ?? false,
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'receiverNumber': receiverNumber,
      'messageBody': messageBody,
      'uid': uid,
      'isSent': isSent,
      'timestamp': timestamp,
    };
  }
}
