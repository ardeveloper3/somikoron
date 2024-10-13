import 'dart:convert';

Rutin rutinFromJson(String str) => Rutin.fromJson(json.decode(str));

String rutinToJson(Rutin data) => json.encode(data.toJson());

class Rutin {
  List<Day>? sunday;
  List<Day>? monday;
  List<Day>? tuesday;
  List<Day>? wednesday;
  List<Day>? thursday;

  Rutin({
    this.sunday,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
  });

  factory Rutin.fromJson(Map<String, dynamic> json) => Rutin(
    sunday: json["sunday"] == null
        ? []
        : List<Day>.from(json["sunday"].map((x) => Day.fromJson(x))),
    monday: json["monday"] == null
        ? []
        : List<Day>.from(json["monday"].map((x) => Day.fromJson(x))),
    tuesday: json["tuesday"] == null
        ? []
        : List<Day>.from(json["tuesday"].map((x) => Day.fromJson(x))),
    wednesday: json["wednesday"] == null
        ? []
        : List<Day>.from(json["wednesday"].map((x) => Day.fromJson(x))),
    thursday: json["thursday"] == null
        ? []
        : List<Day>.from(json["thursday"].map((x) => Day.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sunday": sunday == null ? [] : List<dynamic>.from(sunday!.map((x) => x.toJson())),
    "monday": monday == null ? [] : List<dynamic>.from(monday!.map((x) => x.toJson())),
    "tuesday": tuesday == null ? [] : List<dynamic>.from(tuesday!.map((x) => x.toJson())),
    "wednesday": wednesday == null ? [] : List<dynamic>.from(wednesday!.map((x) => x.toJson())),
    "thursday": thursday == null ? [] : List<dynamic>.from(thursday!.map((x) => x.toJson())),
  };
}

class Day {
  int? period;
  String? start; // Changed from enum to String
  String? end; // Changed from enum to String
  String? day;
  String? subject;
  String? teacher; // Changed from enum to String
  String? grade;

  Day({
    this.period,
    this.start,
    this.end,
    this.day,
    this.subject,
    this.teacher,
    this.grade,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
    period: json["period"],
    start: json["start"], // Now it accepts any time string
    end: json["end"], // Now it accepts any time string
    day: json["day"],
    subject: json["subject"],
    teacher: json["teacher"], // Now it accepts any teacher name
    grade: json["grade"],
  );

  Map<String, dynamic> toJson() => {
    "period": period,
    "start": start,
    "end": end,
    "day": day,
    "subject": subject,
    "teacher": teacher,
    "grade": grade,
  };
}
