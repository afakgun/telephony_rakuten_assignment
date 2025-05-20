import 'package:cloud_firestore/cloud_firestore.dart';

class SmsKpiModel {
  final bool sent;
  final String message;
  final String receiverNumber;
  final DateTime timestamp;
  final String uid;

  SmsKpiModel({
    required this.sent,
    required this.message,
    required this.receiverNumber,
    required this.timestamp,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'isSent': sent,
      'messageBody': message,
      'receiverNumber': receiverNumber,
      'timestamp': timestamp,
      'uid': uid,
    };
  }

  factory SmsKpiModel.fromJson(Map<String, dynamic> data) {
    return SmsKpiModel(
      sent: data['isSent'] ?? false,
      message: data['messageBody'] ?? '',
      receiverNumber: data['receiverNumber'] ?? '',
      timestamp: data['timestamp'] is DateTime
          ? data['timestamp']
          : (data['timestamp'] != null && data['timestamp'] is Timestamp)
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
      uid: data['uid'] ?? '',
    );
  }
}
