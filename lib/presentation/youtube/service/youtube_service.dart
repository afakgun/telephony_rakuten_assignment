import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/youtube_kpi_model.dart';

class YoutubeService {
  static Future<void> sendKpiToFirebase(YoutubeKpiModel kpi) async {
    await FirebaseFirestore.instance
        .collection('youtube_data')
        .add(kpi.toJson());
  }
}
