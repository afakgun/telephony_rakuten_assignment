import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/youtube_kpi_model.dart';

class YoutubeService {
  static Future<void> sendKpiToFirebase(YoutubeKpiModel kpi) async {
    await FirebaseFirestore.instance
        .collection('youtube_data')
        .add(kpi.toJson());
  }

  static Future<YoutubeKpiModel?> getLastKpiByUid(String uid) async {
    final query = await FirebaseFirestore.instance
        .collection('youtube_data')
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;
    final data = query.docs.first.data();
    return YoutubeKpiModel(
      averageSpeed: (data['averageSpeed'] ?? 0).toDouble(),
      volumeMb: data['volumeMb'] ?? 0,
      videoUrl: data['videoUrl'] ?? '',
      closeReason: data['closeReason'] ?? '',
      kbSpeeds: (data['kbSpeeds'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [],
      uid: data['uid'] ?? '',
      timestamp: (data['timestamp'] is DateTime)
          ? data['timestamp']
          : (data['timestamp'] != null && data['timestamp'] is Timestamp)
              ? (data['timestamp'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }
}
