import 'dart:convert';

class LastCallModel {
  int callDurationInSeconds;
  String receiverNumber;
  int selectedDurationInMinutes;
  List<int> qualityStrengthList;
  String userId;
  DateTime timestamp;

  LastCallModel({
    required this.callDurationInSeconds,
    required this.receiverNumber,
    required this.selectedDurationInMinutes,
    required this.qualityStrengthList,
    required this.userId,
    required this.timestamp,
  });

  factory LastCallModel.fromJson(Map<String, dynamic> json) => LastCallModel(
        callDurationInSeconds: json["callDurationInSeconds"],
        receiverNumber: json["receiverNumber"],
        selectedDurationInMinutes: json["selectedDurationInMinutes"],
        qualityStrengthList: List<int>.from(json["qualityStrengthList"].map((x) => x)),
        userId: json["userId"],
        timestamp: DateTime.fromMillisecondsSinceEpoch(json["timestamp"] * 1000),
      );

  Map<String, dynamic> toJson() => {
        "callDurationInSeconds": callDurationInSeconds,
        "receiverNumber": receiverNumber,
        "selectedDurationInMinutes": selectedDurationInMinutes,
        "qualityStrengthList": List<dynamic>.from(qualityStrengthList.map((x) => x)),
        "userId": userId,
        "timestamp": timestamp.toIso8601String(),
      };

  LastCallModel welcomeFromJson(String str) => LastCallModel.fromJson(json.decode(str));

  String welcomeToJson(LastCallModel data) => json.encode(data.toJson());
}
