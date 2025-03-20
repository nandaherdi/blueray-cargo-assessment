import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/response_model.dart';
import 'package:blueray_cargo_assessment/utilities/api_utility.dart';
import 'package:blueray_cargo_assessment/utilities/lookup_utility.dart';
import 'package:blueray_cargo_assessment/view_models/global_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BaseService {
  static Future<ResponseModel> postData({required String dataPath, required String valueKey, required Object data}) async {
    final authToken = navigatorKey.currentContext!.read<GlobalViewModel>().authToken;
    final accessToken = navigatorKey.currentContext!.read<GlobalViewModel>().accessToken;
    try {
      var url = Uri.parse("$dataServiceRoot/$dataPath");
      var response = await http.post(url, headers: {"Authorization": authToken!, "AccessToken": accessToken, "Content-Type": "application/json; charset=UTF-8", "Accept": "application/json"}, body: data);
      var responesBody = responseModelFromJson(response.body, valueKey);
      if (ResponseCodeApi.successResponCode.contains(response.statusCode)) {
        return ResponseModel(code: response.statusCode, isResponseFailure: false, responseMessage: response.body);
      }
      return ResponseModel(code: response.statusCode, isResponseFailure: true, responseMessage: response.reasonPhrase ?? "Unknown Error Response");
    } on SocketException catch (e) {
      return ResponseModel(code: 000, isResponseFailure: true, responseMessage: e.message);
    }
  }
}