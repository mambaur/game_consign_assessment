import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  bool? success;
  String? message;

  Response({
    this.success,
    this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        success: json["success"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
      };
}
