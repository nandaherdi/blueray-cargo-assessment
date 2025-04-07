import 'dart:convert';

List<SubDistrictSearchModel> subDistrictSearchModelFromJson(String str) =>
    List<SubDistrictSearchModel>.from(json.decode(str).map((x) => SubDistrictSearchModel.fromJson(x)));

class SubDistrictSearchModel {
  String? address;
  String? province;
  String? district;
  String? subDistrict;
  String? subDistrictCode;
  int? provinceId;
  int? districtId;
  int? subDistrictId;

  SubDistrictSearchModel({
    this.address,
    this.province,
    this.district,
    this.subDistrict,
    this.subDistrictCode,
    this.provinceId,
    this.districtId,
    this.subDistrictId,
  });

  SubDistrictSearchModel.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    province = json['province'];
    district = json['district'];
    subDistrict = json['sub_district'];
    subDistrictCode = json['sub_district_code'];
    provinceId = json['province_id'];
    districtId = json['district_id'];
    subDistrictId = json['sub_district_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['province'] = this.province;
    data['district'] = this.district;
    data['sub_district'] = this.subDistrict;
    data['sub_district_code'] = this.subDistrictCode;
    data['province_id'] = this.provinceId;
    data['district_id'] = this.districtId;
    data['sub_district_id'] = this.subDistrictId;
    return data;
  }
}
