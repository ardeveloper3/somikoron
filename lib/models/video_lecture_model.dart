// To parse this JSON data, do
//
//     final videoLectureModel = videoLectureModelFromJson(jsonString);

import 'dart:convert';

List<VideoLectureModel> videoLectureModelFromJson(String str) => List<VideoLectureModel>.from(json.decode(str).map((x) => VideoLectureModel.fromJson(x)));

String videoLectureModelToJson(List<VideoLectureModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoLectureModel {
  int? id;
  String? grade;
  String? subject;
  String? content;
  String? url;
  DateTime? date;

  VideoLectureModel({
    this.id,
    this.grade,
    this.subject,
    this.content,
    this.url,
    this.date,
  });

  factory VideoLectureModel.fromJson(Map<String, dynamic> json) => VideoLectureModel(
    id: json["id"],
    grade: json["grade"],
    subject: json["subject"],
    content: json["content"],
    url: json["url"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "grade": grade,
    "subject": subject,
    "content": content,
    "url": url,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
  };
}
