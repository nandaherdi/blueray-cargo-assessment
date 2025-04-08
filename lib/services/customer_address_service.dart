import 'dart:convert';

import 'package:blueray_cargo_assessment/models/requests/add_address_model.dart';
import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/models/responses/get_customer_address_model.dart';
import 'package:blueray_cargo_assessment/models/responses/sub_district_search_model.dart';
import 'package:blueray_cargo_assessment/services/base_service.dart';
import 'package:blueray_cargo_assessment/utilities/lookup_utility.dart';

class CustomerAddressService extends BaseService {
  static String get _path => "customer";
  // static String get _valueKey => "customer";

  static Future<List<GetCustomerAddressModel>> getCustomerAddress() async {
    var response = await BaseService.get(path: "$_path/address");
    if (ResponseCodeApi.successResponseCode.where((value) => value == response.statusCode).isEmpty) {
      ResponseModel responseBody = responseModelFromJson(response.body, 'value', 'status');
      throw '${responseBody.code}: ${responseBody.message}';
    } else {
      return getCustomerAddressModelFromJson(response.body).toList();
    }
  }

  static Future<List<SubDistrictSearchModel>> subDistrictSearch(String keyword) async {
    var response = await BaseService.get(path: "address/subdistricts/search?q=$keyword");
    ResponseModel responseBody = responseModelFromJson(response.body, 'data', 'status');
    if (ResponseCodeApi.successResponseCode.where((value) => value == response.statusCode).isEmpty) {
      throw '${responseBody.code}: ${responseBody.message}';
    } else {
      return subDistrictSearchModelFromJson(json.encode(responseBody.value)).toList();
    }
  }

  static Future<ResponseModel> validatePostCode(String keyword) async {
    var response = await BaseService.get(path: "address/postalcode/validation?postal_code=$keyword");
    ResponseModel responseBody = responseModelFromJson(response.body, 'data', 'status');
    if (ResponseCodeApi.successResponseCode.where((value) => value == response.statusCode).isEmpty) {
      throw '${responseBody.code}: ${responseBody.message}';
    } else {
      return responseBody;
    }
  }

  static Future<ResponseModel> saveAddress({required AddAddressModel requestData}) async {
    String loginRequest = addAddressModelToJson(requestData);
    var response = await BaseService.post(path: "$_path/address", requestData: loginRequest);
    ResponseModel saveAddressResponse;
    try {
      saveAddressResponse = responseModelFromJson(response.body, '', '');
    } catch (_) {
      throw "${response.statusCode}: ${response.reasonPhrase}";
    }
    if (saveAddressResponse.action) {
      return saveAddressResponse;
    } else {
      throw saveAddressResponse.message;
    }
  }
}
