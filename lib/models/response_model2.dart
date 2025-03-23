import 'dart:convert';

ResponseModel2 responseModel2FromJson(String str) => ResponseModel2.fromJson(json.decode(str));

class ResponseModel2 {
  ResponseModel2({
    required this.status,
    required this.action,
    required this.message,
    // this.value
  });

  int status;
  bool action;
  String message;
  // Object? value;

  factory ResponseModel2.fromJson(
          Map<String, dynamic> json) =>
      ResponseModel2(
        status: json["status"],
        action: json["action"],
        message: json["message"],
        // value: json[valueKey]
      );
}
