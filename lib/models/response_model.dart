import 'dart:convert';

List<ResponseModel> responseModelFromJson(
        String str, String valueKey) =>
    List<ResponseModel>.from(json
        .decode(str)
        .map((x) => ResponseModel.fromJson(x, valueKey)));

String responseModelToJson(
        ResponseModel data, String valueKey) =>
    json.encode(data.toJson(valueKey));

class ResponseModel {
  ResponseModel({
    required this.code,
    required this.action,
    required this.message,
    this.value
  });

  int code;
  bool action;
  String message;
  Object? value;

  factory ResponseModel.fromJson(
          Map<String, dynamic> json, String valueKey) =>
      ResponseModel(
        code: json["code"],
        action: json["action"],
        message: json["message"],
        value: json[valueKey]
      );

  Map<String, dynamic> toJson(String valueKey) => {
        "code": code,
        "action": action,
        "message": message,
        valueKey: value
      };
}
