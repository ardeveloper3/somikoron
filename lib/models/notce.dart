// To parse this JSON data, do
//
//     final notce = notceFromJson(jsonString);

import 'dart:convert';

List<Notce> notceFromJson(String str) => List<Notce>.from(json.decode(str).map((x) => Notce.fromJson(x)));

String notceToJson(List<Notce> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Notce {
  int? id;
  String? grade;
  String? subject;
  String? content;
  String? url;
  String? pdf;
  DateTime? date;

  Notce({
    this.id,
    this.grade,
    this.subject,
    this.content,
    this.url,
    this.pdf,
    this.date,
  });

  factory Notce.fromJson(Map<String, dynamic> json) => Notce(
    id: json["id"],
    grade: json["grade"],
    subject: json["subject"],
    content: json["content"],
    url: json["url"],
    pdf: json["pdf"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "grade": grade,
    "subject": subject,
    "content": content,
    "url": url,
    "pdf": pdf,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
  };
}
