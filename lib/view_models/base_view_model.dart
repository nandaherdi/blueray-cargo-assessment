import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseViewModel with ChangeNotifier {
  String? _authToken;
  final String _accessToken = "fe17d6c84394e37f804b614871f7fdf60b71f3685df902ee2b5cf59ba5b7da887158ce2702a0f7b2a9ad44e357af6c678bf1";

  String? get authToken => _authToken;
  String get accessToken => _accessToken;

  set authToken(String? newValue) {
    _authToken = newValue;
    notifyListeners();
  }

  showErrorDialog(String errorMessage) {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context){
        return AlertDialog(
          title: Text("Oops"),
          content: Text(errorMessage),
        );
      });
  }

  showSingleActionDialog({required String title, required String message, required Function action, required String buttonText}) {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => action(),
              child: Text(buttonText)
            )
          ],
        );
      });
  }

  void showInfoSnackBar(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message), backgroundColor: Colors.blue,);

    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void showErrorSnackBar(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red,);

    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  bool isImageExists() {
    var getImageProvider = navigatorKey.currentContext!.read<GetImageViewModel>();
    if (getImageProvider.tempImage != null && File(getImageProvider.tempImage!).existsSync()) {
      return true;
    }
    return false;
  }
}