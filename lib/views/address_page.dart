import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/customer_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    Future.microtask(
      () => navigatorKey.currentContext!.read<BaseViewModel>().shimmerForegroundProcess(
        () => navigatorKey.currentContext!.read<CustomerAddressViewModel>().onInit(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Address'), actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))]),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Consumer<CustomerAddressViewModel>(
          builder: (_, customerAddressProvider, _) {
            if (customerAddressProvider.customerAddresses == null) {
              return ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Skeletonizer(
                    enabled: true,
                    child: ListTile(
                      title: Text('getting title text'),
                      subtitle: Text('getting subtitle text'),
                      trailing: CircleAvatar(radius: 25),
                    ),
                  );
                },
              );
            } else if (customerAddressProvider.customerAddresses!.isEmpty) {
              return Center(child: Text('belum ada alamat'));
            } else {
              return ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return ListTile(
                    title: Text(customerAddressProvider.customerAddresses![index].name),
                    subtitle: Text(customerAddressProvider.customerAddresses![index].npwpFile),
                    trailing: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(customerAddressProvider.customerAddresses![index].npwpFile),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
