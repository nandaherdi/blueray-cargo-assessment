import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/view_models/add_address_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/customer_address_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/get_image_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/auth_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/home_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/maps_view_model.dart';
import 'package:blueray_cargo_assessment/views/home_page.dart';
import 'package:blueray_cargo_assessment/views/login_page.dart';
import 'package:blueray_cargo_assessment/views/maps_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BaseViewModel baseViewModel = BaseViewModel();
  await baseViewModel.onLaunch();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddAddressViewModel()),
        ChangeNotifierProvider(create: (context) => AuthViewModel()),
        ChangeNotifierProvider(create: (context) => BaseViewModel()),
        ChangeNotifierProvider(create: (context) => CustomerAddressViewModel()),
        ChangeNotifierProvider(create: (context) => GetImageViewModel()),
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
        ChangeNotifierProvider(create: (context) => MapsViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget startPage;
    if (isLoggedIn == true) {
      startPage = HomePage();
    } else {
      startPage = LoginPage();
    }
    return MaterialApp(
      title: 'Blueray Cargo App',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      // home: startPage,
      home: MapsPage(),
      navigatorKey: navigatorKey,
    );
  }
}
