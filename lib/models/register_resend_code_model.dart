import 'dart:convert';

List<RegisterResendCodeModel> registerResendCodeModelFromJson(
        String str) =>
    List<RegisterResendCodeModel>.from(json
        .decode(str)
        .map((x) => RegisterResendCodeModel.fromJson(x)));

String registerResendCodeModelToJson(
        RegisterResendCodeModel data) =>
    json.encode(data.toJson());

class RegisterResendCodeModel {
  RegisterResendCodeModel({
    required this.userId
  });

  String userId;

  factory RegisterResendCodeModel.fromJson(
          Map<String, dynamic> json) =>
      RegisterResendCodeModel(
        userId: json["user_id"]
      );

  Map<String, Object> toJson() => {
        "user_id": userId
      };
}
