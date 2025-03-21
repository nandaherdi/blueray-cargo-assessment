import 'package:blueray_cargo_assessment/models/customer_model.dart';
import 'package:blueray_cargo_assessment/models/register_mandatory_model.dart';
import 'package:blueray_cargo_assessment/models/register_mini_model.dart';
import 'package:blueray_cargo_assessment/models/register_resend_code_model.dart';
import 'package:blueray_cargo_assessment/models/register_verify_code_model.dart';
import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/services/base_service.dart';

class RegisterService extends BaseService {
  static String get _path => "/register";
  static String get _valueKey => "customer";
  
  static Future<ResponseModel> registerMini({required RegisterMiniModel requestData}) async {
    var response = await BaseService.postData(path: "$_path/mini", valueKey: "", requestData: requestData);
    return response;
  }

  static Future<ResponseModel> registerVerifyCode({required RegisterVerifyCodeModel requestData}) async {
    var response = await BaseService.postData(path: "$_path/verify-code", valueKey: "", requestData: requestData);
    return response;
  }

  static Future<ResponseModel> registerMandatory({required RegisterMandatoryModel requestData}) async {
    var response = await BaseService.postData(path: "$_path/mandatory", valueKey: _valueKey, requestData: requestData);
    response.value = customerModelFromJson(response.value.toString());
    return response;
  }

  static Future<ResponseModel> registerResendCode({required RegisterResendCodeModel requestData}) async {
    var response = await BaseService.postData(path: "$_path/resend-code", valueKey: "", requestData: requestData);
    return response;
  }
}