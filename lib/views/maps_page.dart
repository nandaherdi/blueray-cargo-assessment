import 'dart:async';

import 'package:blueray_cargo_assessment/view_models/maps_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart' as places;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  late GoogleMapController mapController;
  static const CameraPosition _kGooglePlex = CameraPosition(target: LatLng(32, 104.9), zoom: 1);

  // LatLng initPosition = LatLng(37.42796133580664, -122.085749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Location'), automaticallyImplyLeading: true, centerTitle: true),
      body: Stack(
        children: [
          Consumer<MapsViewModel>(
            builder: (context, mapsProvider, _) {
              return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) async {
                  _mapController.complete(controller);
                  mapController = await _mapController.future;
                },
                onCameraMove: (position) async {
                  context.read<MapsViewModel>().onMapDrag(position.target.latitude, position.target.longitude);
                },
                onCameraIdle: () async {
                  context.read<MapsViewModel>().onMapIdle();
                },
                onCameraMoveStarted: () {
                  context.read<MapsViewModel>().isMarkMoving = true;
                },
                markers: {Marker(markerId: MarkerId('selected_location'), position: mapsProvider.selectedCoordinate!)},
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor.bar(
              suggestionsBuilder: (context, controller) async {
                return context.read<MapsViewModel>().getPrediction(controller.text, controller, mapController);
              },
            ),
          ),
          Consumer<MapsViewModel>(
            builder: (context, mapsProvider, _) {
              if (!mapsProvider.isMarkMoving && mapsProvider.selectedPlacemark != null) {
                return Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 20,
                      children: [
                        Text(
                          mapsProvider.selectedPlacemark!.name!,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                        Text(
                          '${mapsProvider.selectedPlacemark!.street!}, ${mapsProvider.selectedPlacemark!.locality!}, ${mapsProvider.selectedPlacemark!.country!}',
                        ),
                        Text(mapsProvider.selectedPlacemark!.postalCode!),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
