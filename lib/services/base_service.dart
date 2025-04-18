import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/utilities/api_utility.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BaseService {
  static Future<http.Response> post({
    required String path,
    // required String valueKey,
    // required String statusCodeKey,
    required Object requestData,
  }) async {
    // final authToken = navigatorKey.currentContext!.read<BaseViewModel>().authToken;
    final accessToken = navigatorKey.currentContext!.read<BaseViewModel>().accessToken;
    var url = Uri.parse("$dataServiceRoot/$path");
    if (path.contains('login')) {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
        body: requestData,
      );
      return response;
    } else {
      var response = await http.post(
        url,
        headers: {
          "Authorization": "Token $authToken" ?? "",
          "AccessToken": accessToken,
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
        body: requestData,
      );
      return response;
    }
    
  }

  static Future<http.Response> get({
    required String path,
    // required String valueKey,
    // required String statusCodeKey,
  }) async {
    // final accessToken = navigatorKey.currentContext!.read<BaseViewModel>().accessToken;
    var url = Uri.parse("$dataServiceRoot/$path");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "Token $authToken",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
      },
    );
    return response;
  }

  static Future<ResponseModel> postData({
    required String path,
    required String valueKey,
    required String statusCodeKey,
    required Object requestData,
  }) async {
    final authToken = navigatorKey.currentContext!.read<BaseViewModel>().authToken;
    final accessToken = navigatorKey.currentContext!.read<BaseViewModel>().accessToken;
    try {
      var url = Uri.parse("$dataServiceRoot/$path");
      var response = await http.post(
        url,
        headers: {
          "Authorization": authToken ?? "",
          "AccessToken": accessToken,
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
        body: requestData,
      );
      // var responseBody = responseModelFromJson(response.body, valueKey);
      var responseBody = responseModelFromJson(response.body, valueKey, statusCodeKey);
      // if (ResponseCodeApi.successResponCode.contains(response.statusCode)) {
      responseBody.code = responseBody.code ?? response.statusCode;
      return responseBody;
      // return ResponseModel(code: response.statusCode, action: responseBody.first.action, message: responseBody.first.message, value: responseBody.first.value);
      // }
      // return ResponseModel(code: response.statusCode, isResponseFailure: true, responseMessage: response.reasonPhrase ?? "Unknown Error Response");
    } on SocketException catch (e) {
      return ResponseModel(code: 000, action: false, message: e.message);
    }
  }

  // static Future<ResponseModel2> postData2({required String path, required String valueKey, required Object requestData}) async {
  //   final authToken = navigatorKey.currentContext!.read<BaseViewModel>().authToken;
  //   final accessToken = navigatorKey.currentContext!.read<BaseViewModel>().accessToken;
  //   try {
  //     var url = Uri.parse("$dataServiceRoot/$path");
  //     var response = await http.post(url, headers: {"Authorization": authToken ?? "", "AccessToken": accessToken, "Content-Type": "application/json; charset=UTF-8", "Accept": "application/json"}, body: requestData);
  //     // var responseBody = responseModelFromJson(response.body, valueKey);
  //     var responseBody = responseModel2FromJson(response.body);
  //     // if (ResponseCodeApi.successResponCode.contains(response.statusCode)) {
  //       responseBody.status = response.statusCode;
  //       return responseBody;
  //       // return ResponseModel(code: response.statusCode, action: responseBody.first.action, message: responseBody.first.message, value: responseBody.first.value);
  //     // }
  //     // return ResponseModel(code: response.statusCode, isResponseFailure: true, responseMessage: response.reasonPhrase ?? "Unknown Error Response");
  //   } on SocketException catch (e) {
  //     return ResponseModel2(status: 000, action: false, message: e.message);
  //   }
  // }

  static Future<ResponseModel> uploadImage(File image) async {
    try {
      var url = Uri.parse("$dataServiceRoot/image/upload");
      var files = await http.MultipartFile.fromPath('image_file', image.path);
      var request = http.MultipartRequest('POST', url);
      // request.headers['authorization'] = Global.UserAuthorization;
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files.add(files);
      var response = await request.send();

      var streamResponse = await http.Response.fromStream(response);

      var responseBody = responseModelFromJson(streamResponse.body, "image_url", "");
      responseBody.code = responseBody.code ?? response.statusCode;
      return responseBody;
      // if (response.statusCode == ResponseCodeAPI.SuccessResponCode) {
      //   return ResponsePost(code: response.statusCode, isResponseFailure: false, msgResponse: 'Upload Success !!!');
      // }
      // return ResponsePost(code: response.statusCode, isResponseFailure: true, msgResponse: response.reasonPhrase ?? "Unknown Error Response");
    } on SocketException catch (e) {
      return ResponseModel(code: 000, action: false, message: e.message);
    }
  }
}
