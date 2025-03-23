import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/register_view_model.dart';
import 'package:blueray_cargo_assessment/views/register_form_page.dart';
import 'package:blueray_cargo_assessment/views/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BaseViewModel()),
        ChangeNotifierProvider(create: (context) => GetImageViewModel()),
        ChangeNotifierProvider(create: (context) => RegisterViewModel())
      ],
      child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const RegisterFormPage(email: 'maselon@space.com',),
      // home: const RegisterPage(),
      navigatorKey: navigatorKey,
    );
  }
}
