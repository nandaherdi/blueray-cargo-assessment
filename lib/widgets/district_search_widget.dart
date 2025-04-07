import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/view_models/add_address_view_model.dart';
import 'package:blueray_cargo_assessment/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DistrictSearchWidget extends StatefulWidget {
  const DistrictSearchWidget({super.key});

  @override
  State<DistrictSearchWidget> createState() => _DistrictSearchWidgetState();
}

class _DistrictSearchWidgetState extends State<DistrictSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final FocusNode _districtFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.text = '';
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _districtFocusNode,
      controller: _districtController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_city),
        labelText: 'Kota/Kecamatan',
      ),
      autovalidateMode: AutovalidateMode.onUnfocus,
      validator: (value) {
        var error = context.read<AddAddressViewModel>().validateDistrict();
        context.read<AddAddressViewModel>().validateAddressForm();
        return error;
      },
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                    ),
                  ),
                  Consumer<AddAddressViewModel>(
                    builder: (_, addAddressProvider, _) {
                      return SearchBar(
                        controller: _searchController,
                        hintText: "cari kota atau kecamatan",
                        leading: Icon(Icons.search),
                        trailing: [
                          _searchController.text != ''
                              ? IconButton(
                                onPressed: () {
                                  _searchController.text = '';
                                  addAddressProvider.searchResult = [];
                                },
                                icon: Icon(Icons.close),
                              )
                              : SizedBox(),
                        ],
                        onChanged:
                            (value) =>
                                value == ''
                                    ? addAddressProvider.searchResult = []
                                    : navigatorKey.currentContext!.read<BaseViewModel>().shimmerForegroundProcess(
                                      () => navigatorKey.currentContext!.read<AddAddressViewModel>().doSearch(value),
                                    ),
                      );
                    },
                  ),
                  Expanded(
                    child: Consumer<AddAddressViewModel>(
                      builder: (_, addAddressProvider, _) {
                        if (addAddressProvider.searchResult == null) {
                          return Center(child: CircularProgressIndicator());
                        } else if (addAddressProvider.searchResult!.isEmpty) {
                          return Center(child: Text('tidak ada hasil'));
                        } else {
                          return ListView.builder(
                            itemCount: addAddressProvider.searchResult!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  _districtController.text =
                                      '${addAddressProvider.searchResult![index].subDistrict!}, ${addAddressProvider.searchResult![index].district!}';
                                  addAddressProvider.onSelectedSubDistrict(index);
                                },
                                title: Text(
                                  '${addAddressProvider.searchResult![index].subDistrict!}, ${addAddressProvider.searchResult![index].district!}',
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ).whenComplete(() {
          _districtFocusNode.unfocus();
          _searchController.text = '';
          context.read<AddAddressViewModel>().searchResult = [];
        });
      },
    );
  }
}
