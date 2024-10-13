
// To parse this JSON data, do
//
//     final allTeachers = allTeachersFromJson(jsonString);

import 'dart:convert';

List<AllTeachers> allTeachersFromJson(String str) => List<AllTeachers>.from(json.decode(str).map((x) => AllTeachers.fromJson(x)));

String allTeachersToJson(List<AllTeachers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllTeachers {
  int? id;
  User? user;
  String? name;
  String? phone;
  String? subject;
  String? img;

  AllTeachers({
    this.id,
    this.user,
    this.name,
    this.phone,
    this.subject,
    this.img,
  });

  factory AllTeachers.fromJson(Map<String, dynamic> json) => AllTeachers(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    name: json["name"],
    phone: json["phone"],
    subject: json["subject"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "name": name,
    "phone": phone,
    "subject": subject,
    "img": img,
  };
}

class User {
  int? id;
  String? username;
  DateTime? dateJoined;
  bool? isStudent;
  bool? isActive;

  User({
    this.id,
    this.username,
    this.dateJoined,
    this.isStudent,
    this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    dateJoined: json["date_joined"] == null ? null : DateTime.parse(json["date_joined"]),
    isStudent: json["is_student"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "date_joined": dateJoined?.toIso8601String(),
    "is_student": isStudent,
    "is_active": isActive,
  };
}
