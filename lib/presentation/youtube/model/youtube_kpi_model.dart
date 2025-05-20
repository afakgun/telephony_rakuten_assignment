class YoutubeKpiModel {
  final double averageSpeed; // Mbps cinsinden ortalama hız
  final int volumeMb; // Kullanıcının belirlediği MB
  final String videoUrl; // İzlenen video URL'i
  final String closeReason; // Kapanma nedeni
  final List<double> kbSpeeds; // Anlık KB/s hızları
  final String uid;
  final DateTime timestamp;

  YoutubeKpiModel({
    required this.averageSpeed,
    required this.volumeMb,
    required this.videoUrl,
    required this.closeReason,
    required this.kbSpeeds,
    required this.uid,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'averageSpeed': averageSpeed,
      'volumeMb': volumeMb,
      'videoUrl': videoUrl,
      'closeReason': closeReason,
      'kbSpeeds': kbSpeeds,
      'uid': uid,
      'timestamp': timestamp,
    };
  }
}
