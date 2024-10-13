

class Attendens {
  int? id;
  Student? student;
  DateTime? date;
  String? status;

  Attendens({
    this.id,
    this.student,
    this.date,
    this.status,
  });

  factory Attendens.fromJson(Map<String, dynamic> json) => Attendens(
    id: json["id"],
    student: json["student"] == null ? null : Student.fromJson(json["student"]),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student": student?.toJson(),
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "status": status,
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
