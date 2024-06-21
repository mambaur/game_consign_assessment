import 'dart:convert';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
  int? id;
  String? title;
  String? description;
  String? time;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Reminder({
    this.id,
    this.title,
    this.description,
    this.time,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        time: json["time"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "time": time,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
