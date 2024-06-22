import 'dart:convert';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
  int? id;
  String? title;
  String? description;
  String? time;
  String? type;
  double? latitude;
  double? longitude;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Reminder({
    this.id,
    this.title,
    this.description,
    this.time,
    this.type,
    this.latitude,
    this.longitude,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        time: json["time"],
        type: json["type"],
        latitude: json["latitude"],
        longitude: json["longitude"],
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
        "time": time ?? '00:01',
        "type": type,
        "latitude": latitude,
        "longitude": longitude,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
