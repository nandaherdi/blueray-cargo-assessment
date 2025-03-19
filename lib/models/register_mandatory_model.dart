import 'dart:convert';

List<RegisterMandatoryModel> registerMandatoryModelFromJson(
        String str) =>
    List<RegisterMandatoryModel>.from(json
        .decode(str)
        .map((x) => RegisterMandatoryModel.fromJson(x)));

String registerMandatoryModelToJson(
        RegisterMandatoryModel data) =>
    json.encode(data.toJson());

class RegisterMandatoryModel {
  RegisterMandatoryModel({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.secondUserId,
    required this.password,
    required this.idCardNumber,
    required this.idCardImage,
    required this.idCardAddress,
    required this.idCardName
  });

  String userId;
  String firstName;
  String lastName;
  String secondUserId;
  String password;
  String idCardNumber;
  String idCardImage;
  String idCardAddress;
  String idCardName;

  factory RegisterMandatoryModel.fromJson(
          Map<String, dynamic> json) =>
      RegisterMandatoryModel(
        userId: json["user_id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        secondUserId: json["secondUserId"],
        password: json["password"],
        idCardNumber: json["idCardNumber"],
        idCardImage: json["idCardImage"],
        idCardAddress: json["idCardAddress"],
        idCardName: json["idCardName"]
      );

  Map<String, Object> toJson() => {
        "user_id": userId,
        "firstName": firstName,
        "lastName": lastName,
        "secondUserId": secondUserId,
        "password": password,
        "idCardNumber": idCardNumber,
        "idCardImage": idCardImage,
        "idCardAddress": idCardAddress,
        "idCardName": idCardName
      };
}
