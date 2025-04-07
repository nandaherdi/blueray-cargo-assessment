import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/models/responses/get_customer_address_model.dart';
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
}
