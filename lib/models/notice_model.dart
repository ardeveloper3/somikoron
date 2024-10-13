

class Notice {
  int? id;
  String? content;
  DateTime? date;

  Notice({
    this.id,
    this.content,
    this.date,
  });

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    id: json["id"],
    content: json["content"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
  };
}
