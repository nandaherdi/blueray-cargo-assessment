import 'dart:convert';

String addAddressModelToJson(AddAddressModel data) =>
    json.encode(data.toJson());
class AddAddressModel {
  String? name;
  String? phoneNumber;
  String? phoneNumber2;
  int? provinceId;
  int? districtId;
  int? subDistrictId;
  String? postalCode;
  double? long;
  double? lat;
  String? address;
  String? addressMap;
  String? addressLabel;
  String? email;
  String? npwp;
  String? npwpFile;

  AddAddressModel({
    this.name,
    this.phoneNumber,
    this.phoneNumber2,
    this.provinceId,
    this.districtId,
    this.subDistrictId,
    this.postalCode,
    this.long,
    this.lat,
    this.address,
    this.addressMap,
    this.addressLabel,
    this.email,
    this.npwp,
    this.npwpFile,
  });

  AddAddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
    phoneNumber2 = json['phone_number_2'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    subDistrictId = json['sub_district_id'];
    postalCode = json['postal_code'];
    long = json['long'];
    lat = json['lat'];
    address = json['address'];
    addressMap = json['address_map'];
    addressLabel = json['address_label'];
    email = json['email'];
    npwp = json['npwp'];
    npwpFile = json['npwp_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['phone_number_2'] = phoneNumber2;
    data['province_id'] = provinceId;
    data['district_id'] = districtId;
    data['sub_district_id'] = subDistrictId;
    data['postal_code'] = postalCode;
    data['long'] = long;
    data['lat'] = lat;
    data['address'] = address;
    data['address_map'] = addressMap;
    data['address_label'] = addressLabel;
    data['email'] = email;
    data['npwp'] = npwp;
    data['npwp_file'] = npwpFile;
    return data;
  }
}
