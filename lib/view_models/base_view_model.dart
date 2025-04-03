import 'dart:io';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/dialog_foreground_process_model.dart';
import 'package:blueray_cargo_assessment/utilities/lookup_utility.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseViewModel with ChangeNotifier {
  String? _authToken;
  final String _accessToken =
      "fe17d6c84394e37f804b614871f7fdf60b71f3685df902ee2b5cf59ba5b7da887158ce2702a0f7b2a9ad44e357af6c678bf1";

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
      builder: (context) {
        return AlertDialog(title: Text("Oops"), content: Text(errorMessage));
      },
    );
  }

  showSingleActionDialog({
    required String title,
    required String message,
    required Function action,
    required String buttonText,
  }) {
    showDialog(
      barrierDismissible: true,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [ElevatedButton(onPressed: () => action(), child: Text(buttonText))],
        );
      },
    );
  }

  void showInfoSnackBar(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message), backgroundColor: Colors.blue);

    ScaffoldMessenger.of(navigatorKey.currentContext!)
      ..hideCurrentSnackBar()
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  void showErrorSnackBar(String message) {
    final SnackBar snackBar = SnackBar(content: Text(message), backgroundColor: Colors.red);

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

  dialogForegroundProcess(Function process, DialogForegroundProcessModel dialogData) {
    showLoadingDialog();
    try {
      process;
      Navigator.of(navigatorKey.currentContext!).pop();
      showSingleActionDialog(
        title: dialogData.title,
        message: dialogData.message,
        action: dialogData.action,
        buttonText: dialogData.buttonText,
      );
    } catch (e) {
      Navigator.of(navigatorKey.currentContext!).pop();
      showErrorDialog(e.toString());
    }
  }

  navigateForegroundProcess(Function process, Widget nextPage) async {
    showLoadingDialog();
    try {
      await process();
      Navigator.of(navigatorKey.currentContext!).pop();
      Navigator.pushReplacement(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (BuildContext context) => nextPage),
      );
    } catch (e) {
      Navigator.of(navigatorKey.currentContext!).pop();
      showErrorDialog(e.toString());
    }
  }

  showLoadingDialog() {
    showDialog(
      barrierDismissible: false,
      context: navigatorKey.currentContext!,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            child: Container(
              height: 200,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 15), Text("mohon tunggu")],
              ),
            ),
          ),
        );
      },
    );
  }
}
