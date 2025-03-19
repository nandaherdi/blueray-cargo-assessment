import 'dart:convert';

List<RegisterVerifyCodeModel> registerVerifyCodeModelFromJson(
        String str) =>
    List<RegisterVerifyCodeModel>.from(json
        .decode(str)
        .map((x) => RegisterVerifyCodeModel.fromJson(x)));

String registerVerifyCodeModelToJson(
        RegisterVerifyCodeModel data) =>
    json.encode(data.toJson());

class RegisterVerifyCodeModel {
  RegisterVerifyCodeModel({
    required this.userId,
    required this.code
  });

  String userId;
  String code;

  factory RegisterVerifyCodeModel.fromJson(
          Map<String, dynamic> json) =>
      RegisterVerifyCodeModel(
        userId: json["user_id"],
        code: json["code"]
      );

  Map<String, Object> toJson() => {
        "user_id": userId,
        "code": code
      };
}
