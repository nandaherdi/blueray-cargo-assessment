import 'dart:convert';

List<CustomerModel> customerModelFromJson(
        String str) =>
    List<CustomerModel>.from(json
        .decode(str)
        .map((x) => CustomerModel.fromJson(x)));

String customerModelToJson(
        CustomerModel data) =>
    json.encode(data.toJson());

class CustomerModel {
  CustomerModel({
    required this.customerId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.gender,
    this.birthPlace,
    this.birthday
  });

  int customerId;
  String email;
  String firstName;
  String lastName;
  String phoneNumber;
  String? gender;
  String? birthPlace;
  String? birthday;

  factory CustomerModel.fromJson(
          Map<String, dynamic> json) =>
      CustomerModel(
        customerId: json["customerId"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        phoneNumber: json["phoneNumber"],
        gender: json["gender"],
        birthPlace: json["birthPlace"],
        birthday: json["birthday"]
      );

  Map<String, dynamic> toJson() => {
        "customerId": customerId,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "birthPlace": birthPlace,
        "birthday": birthday
      };
}
