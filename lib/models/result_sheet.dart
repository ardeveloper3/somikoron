// To parse this JSON data, do
//
//     final resultSheet = resultSheetFromJson(jsonString);

import 'dart:convert';

List<ResultSheet> resultSheetFromJson(String str) => List<ResultSheet>.from(json.decode(str).map((x) => ResultSheet.fromJson(x)));

String resultSheetToJson(List<ResultSheet> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResultSheet {
  int? id;
  Exam? exam;
  Student? student;
  int? examMarks;
  int? position;
  String? symbol;
  int? highestExamMarks;

  ResultSheet({
    this.id,
    this.exam,
    this.student,
    this.examMarks,
    this.position,
    this.symbol,
    this.highestExamMarks,
  });

  factory ResultSheet.fromJson(Map<String, dynamic> json) => ResultSheet(
    id: json["id"],
    exam: json["exam"] == null ? null : Exam.fromJson(json["exam"]),
    student: json["student"] == null ? null : Student.fromJson(json["student"]),
    examMarks: json["exam_marks"],
    position: json["position"],
    symbol: json["symbol"],
    highestExamMarks: json["highest_exam_marks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "exam": exam?.toJson(),
    "student": student?.toJson(),
    "exam_marks": examMarks,
    "position": position,
    "symbol": symbol,
    "highest_exam_marks": highestExamMarks,
  };
}

class Exam {
  int? id;
  String? name;
  DateTime? date;
  String? grade;
  String? subject;
  int? totalMarks;

  Exam({
    this.id,
    this.name,
    this.date,
    this.grade,
    this.subject,
    this.totalMarks,
  });

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    id: json["id"],
    name: json["name"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    grade: json["grade"],
    subject: json["subject"],
    totalMarks: json["total_marks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "grade": grade,
    "subject": subject,
    "total_marks": totalMarks,
  };
}

class Student {
  int? id;
  User? user;
  String? name;
  String? phone;
  String? roll;
  String? grade;
  String? img;

  Student({
    this.id,
    this.user,
    this.name,
    this.phone,
    this.roll,
    this.grade,
    this.img,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json["id"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    name: json["name"],
    phone: json["phone"],
    roll: json["roll"],
    grade: json["grade"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user?.toJson(),
    "name": name,
    "phone": phone,
    "roll": roll,
    "grade": grade,
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
