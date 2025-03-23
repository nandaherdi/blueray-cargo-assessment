import 'dart:convert';

ResponseModel responseModelFromJson(String str, String valueKey, String statusCodeKey) => ResponseModel.fromJson(json.decode(str), valueKey, statusCodeKey);

class ResponseModel {
  ResponseModel({
    this.code,
    required this.action,
    required this.message,
    this.value
  });

  int? code;
  bool action;
  String message;
  Object? value;

  factory ResponseModel.fromJson(
          Map<String, dynamic> json, String valueKey, String statusCodeKey) =>
      ResponseModel(
        code: json[statusCodeKey],
        action: json["action"],
        message: json["message"],
        value: json[valueKey]
      );
}
