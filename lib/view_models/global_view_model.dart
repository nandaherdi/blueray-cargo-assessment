import 'package:flutter/material.dart';

class GlobalViewModel with ChangeNotifier {
  String? _authToken;
  final String _accessToken = "fe17d6c84394e37f804b614871f7fdf60b71f3685df902ee2b5cf59ba5b7da887158ce2702a0f7b2a9ad44e357af6c678bf1";

  String? get authToken => _authToken;
  String get accessToken => _accessToken;

  void setAuthToken(String authToken) {
    _authToken = authToken;
    notifyListeners();
  }
}