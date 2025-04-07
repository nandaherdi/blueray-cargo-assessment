import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/customer_model.dart';
import 'package:blueray_cargo_assessment/view_models/home_view_model.dart';
import 'package:blueray_cargo_assessment/views/address_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.microtask(
      () => Future.delayed(Duration(seconds: 5), () => navigatorKey.currentContext!.read<HomeViewModel>().onInit()),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(15),
        child: Consumer<HomeViewModel>(
          builder: (_, homeProvider, _) {
            return Skeletonizer(
              enabled: homeProvider.customer == null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Container(
                  //   height: 50,
                  //   width: 50,
                  //   decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),
                  //   child:
                  //       homeProvider.customer == null
                  //           ? SizedBox()
                  //           : Image.network(
                  //             homeProvider.customer!.avatar,
                  //             errorBuilder: (context, error, stackTrace) {
                  //               return Icon(Icons.person);
                  //             },
                  //           ),
                  // ),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: homeProvider.customer == null ? null : NetworkImage(homeProvider.customer!.avatar),
                  ),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.email),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.firstName),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.lastName),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.birthPlace),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.birthday),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.gender),
                  Text(homeProvider.customer == null ? "getting data to show" : homeProvider.customer!.phoneNumber),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        navigatorKey.currentContext!,
                        MaterialPageRoute(builder: (BuildContext context) => AddressPage()),
                      );
                    },
                    icon: Icon(Icons.map_sharp),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
