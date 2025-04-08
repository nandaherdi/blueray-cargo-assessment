import 'package:blueray_cargo_assessment/models/requests/login_request_model.dart';
import 'package:blueray_cargo_assessment/models/responses/login_response_model.dart';
import 'package:blueray_cargo_assessment/services/base_service.dart';

class AuthService extends BaseService {
  static String get _path => "customer";

  static Future<LoginResponseModel> login({required LoginRequestModel requestData}) async {
    String loginRequest = loginRequestModelToJson(requestData);
    var response = await BaseService.post(path: "$_path/login", requestData: loginRequest);
    LoginResponseModel loginResponse;
    try {
      loginResponse = loginResponseModelFromJson(response.body);
    } catch (_) {
      throw "${response.statusCode}: ${response.reasonPhrase}";
    }
    if (loginResponse.login) {
      return loginResponse;
    } else {
      throw loginResponse.message!;
    }
  }

  // static Future<ResponseModel> registerVerifyCode({required RegisterVerifyCodeModel requestData}) async {
  //   var response = await BaseService.postData(
  //     path: "$_path/verify-code",
  //     valueKey: "",
  //     requestData: registerVerifyCodeModelToJson(requestData),
  //     statusCodeKey: "",
  //   );
  //   return response;
  // }

  // static Future<ResponseModel> registerMandatory({required RegisterMandatoryModel requestData}) async {
  //   var response = await BaseService.postData(
  //     path: "$_path/mandatory",
  //     valueKey: _valueKey,
  //     requestData: registerMandatoryModelToJson(requestData),
  //     statusCodeKey: "",
  //   );
  //   response.value = customerModelFromJson(response.value.toString());
  //   return response;
  // }

  // static Future<ResponseModel> registerResendCode({required RegisterResendCodeModel requestData}) async {
  //   var response = await BaseService.postData(
  //     path: "$_path/resend-code",
  //     valueKey: "",
  //     requestData: registerResendCodeModelToJson(requestData),
  //     statusCodeKey: "",
  //   );
  //   return response;
  // }
}
