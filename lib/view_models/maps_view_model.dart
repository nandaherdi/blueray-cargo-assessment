import 'dart:async';

import 'package:blueray_cargo_assessment/global.dart';
import 'package:blueray_cargo_assessment/models/place_model.dart';
import 'package:blueray_cargo_assessment/view_models/add_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart' as places;
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MapsViewModel with ChangeNotifier {
  places.AutocompletePrediction? _selectedPrediction;
  LatLng? _selectedCoordinate = LatLng(32, 104.9);
  PlaceModel? _selectedPlacemark;
  bool _isMarkMoving = true;

  places.AutocompletePrediction? get selectedPrediction => _selectedPrediction;
  LatLng? get selectedCoordinate => _selectedCoordinate;
  PlaceModel? get selectedPlacemark => _selectedPlacemark;
  bool get isMarkMoving => _isMarkMoving;

  set selectedPrediction(places.AutocompletePrediction? newValue) {
    _selectedPrediction = newValue;
    notifyListeners();
  }

  set selectedCoordinate(LatLng? newValue) {
    _selectedCoordinate = newValue;
    notifyListeners();
  }

  set selectedPlacemark(PlaceModel? newValue) {
    _selectedPlacemark = newValue;
    notifyListeners();
  }

  set isMarkMoving(bool newValue) {
    _isMarkMoving = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    selectedPrediction = null;
    selectedCoordinate = LatLng(32, 104.9);
    selectedPlacemark = null;
    isMarkMoving = true;
    super.dispose();
  }

  Future<Iterable<Widget>> getPrediction(
    String keyword,
    TextEditingController searchController,
    GoogleMapController mapController,
  ) async {
    if (keyword != '') {
      final gplace = places.FlutterGooglePlacesSdk('apikey');
      final result = await gplace.findAutocompletePredictions(keyword);
      return result.predictions.map((prediction) {
        return ListTile(
          subtitle: Text(prediction.fullText),
          isThreeLine: true,
          onTap: () => onSelectedPrediction(prediction, searchController, mapController),
        );
      });
    } else {
      return [
        ListTile(title: Text(''), subtitle: Text(''), trailing: Text('')),
        ListTile(title: Text(''), subtitle: Text(''), trailing: Text('')),
      ];
    }
  }

  void onSelectedPrediction(
    places.AutocompletePrediction prediction,
    TextEditingController searchController,
    GoogleMapController mapController,
  ) async {
    Navigator.of(navigatorKey.currentContext!).pop();
    selectedPrediction = prediction;
    searchController.text = prediction.fullText;
    List<Location> locations = await locationFromAddress(prediction.fullText);
    List<Placemark> placemarks = await placemarkFromCoordinates(locations.first.latitude, locations.first.longitude);
    setPlacemark(placemarks);
    // selectedPlacemark = placemarks.first;
    selectedCoordinate = LatLng(locations.first.latitude, locations.first.longitude);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: selectedCoordinate!, zoom: 18)),
    );
    FocusScope.of(navigatorKey.currentContext!).unfocus();
  }

  void onMapDrag(double latitude, longitude) async {
    selectedCoordinate = LatLng(latitude, longitude);
  }

  Future<void> onMapIdle() async {
    try{
      isMarkMoving = false;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedCoordinate!.latitude,
      selectedCoordinate!.longitude,
    );
    
    setPlacemark(placemarks);

    } catch(e){
      print(e);
    }
    
  }

  setPlacemark(List<Placemark> placemarks) {
    PlaceModel newPlacemark = PlaceModel();
    String street = '';
    String locality = '';
    String subAdministrativeArea = '';
    String administrativeArea = '';
    String country = '';
    String postalCode = '';

    for (Placemark placemark in placemarks) {
      newPlacemark.name = placemark.name;
      street = street.contains(placemark.street!) || placemark.street!.isEmpty ? street : '$street, ${placemark.street}';
      locality = locality.contains(placemark.locality!) || placemark.locality!.isEmpty ? locality : '$locality, ${placemark.locality}';
      subAdministrativeArea = subAdministrativeArea.contains(placemark.subAdministrativeArea!) || placemark.subAdministrativeArea!.isEmpty ? subAdministrativeArea : '$subAdministrativeArea, ${placemark.subAdministrativeArea}';
      administrativeArea = administrativeArea.contains(placemark.administrativeArea!) || placemark.administrativeArea!.isEmpty ? administrativeArea : '$administrativeArea, ${placemark.administrativeArea}';
      country = country.contains(placemark.country!) || placemark.country!.isEmpty ? country : '$country, ${placemark.country}';
      postalCode = postalCode.contains(placemark.postalCode!) || placemark.postalCode!.isEmpty ? postalCode : '$postalCode, ${placemark.postalCode}';
    }

    newPlacemark.street = '${street.substring(1).trim()}$locality$subAdministrativeArea$administrativeArea$country$postalCode';

    selectedPlacemark = newPlacemark;
  }

  onCurrentLocationTap(GoogleMapController mapController,) async {
    var position = await getUserCurrentPosition();
    selectedCoordinate = LatLng(position!.latitude, position.latitude);
    await onMapIdle();
    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: selectedCoordinate!, zoom: 18)),
    );
    FocusScope.of(navigatorKey.currentContext!).unfocus();
  }

  Future<Position?> getUserCurrentPosition() async {
    BuildContext context = navigatorKey.currentContext!;
    showModalBottomSheet(
        enableDrag: false,
        context: context,
        builder: (context) {
          return const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Checking location permission and service..."),
                SizedBox(
                  height: 15,
                ),
                LinearProgressIndicator(),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          );
        });
    bool locationPermissionGranted;
    PermissionStatus locationPermissionStatus = await Permission.location.status;
    if (locationPermissionStatus == PermissionStatus.denied) {
      PermissionStatus status = await Permission.location.request();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.restricted) {
        locationPermissionGranted = false;
      } else {
        locationPermissionGranted = true;
      }
    } else if (locationPermissionStatus == PermissionStatus.permanentlyDenied) {
      locationPermissionGranted = false;
    } else if (locationPermissionStatus == PermissionStatus.restricted) {
      PermissionStatus status = await Permission.location.request();
      if (status == PermissionStatus.denied ||
          status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.restricted) {
        locationPermissionGranted = false;
      } else {
        locationPermissionGranted = true;
      }
    } else {
      locationPermissionGranted = true;
    }
    if (locationPermissionGranted) {
      bool serviceEnable = await Geolocator.isLocationServiceEnabled();
      loc.Location location = loc.Location();
      if (!serviceEnable) {
        serviceEnable = await location.requestService();
        if (!serviceEnable) {
          Navigator.of(context).pop();
          await showOpenLocationServiceSettingsDialog();
          return null;
        } else {
          Position? position;
          try {
            position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.bestForNavigation, forceAndroidLocationManager: true)
                .timeout(Duration(seconds: 5));
          } on TimeoutException catch (e) {
            position = await Geolocator.getLastKnownPosition();
          }
          Navigator.of(context).pop();
          return position;
        }
      } else {
        Position? position;
        try {
          position = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.bestForNavigation, forceAndroidLocationManager: true)
              .timeout(Duration(seconds: 5));
        } on TimeoutException catch (e) {
          position = await Geolocator.getLastKnownPosition();
        }
        if (position == null) {
          Navigator.of(context).pop();
          await showLocationNullDialog();
          return null;
        } else {
          Navigator.of(context).pop();
          return position;
        }
      }
    } else {
      Navigator.of(context).pop();
      await showOpenAppPermissionSettingsDialog();
      return null;
    }
  }

  showOpenLocationServiceSettingsDialog() {
    BuildContext context = navigatorKey.currentContext!;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Location Service is Disable"),
            content: const Text(
                "App needs to access your location. If you want to continue to use this feature, please enable location service in settings."),
            actions: [
              TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Go to Location Settings"))
            ],
          );
        });
  }

  showLocationNullDialog() {
    BuildContext context = navigatorKey.currentContext!;
    showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            title: Text("Cannot Retrieve User Location"),
            content: Text("Getting user location is failed. There's a problem with device gps or location service."),
          );
        });
  }

  showOpenAppPermissionSettingsDialog() {
    BuildContext context = navigatorKey.currentContext!;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Access to Location is Needed"),
            content: const Text(
                "App needs to access your location. If you want to continue to use this feature, please allow this app location permission in settings."),
            actions: [
              TextButton(
                  onPressed: () async {
                    await openAppSettings();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Go to Settings"))
            ],
          );
        });
  }

  onDone() {
    var addAddressProvider = navigatorKey.currentContext!.read<AddAddressViewModel>();

    addAddressProvider.mapsAddress = selectedPlacemark?.street;
    addAddressProvider.mapsCoordinate = selectedCoordinate;
    addAddressProvider.addressFormValidation.addressMap = true;
    addAddressProvider.addressFormValidation.lat = true;
    addAddressProvider.addressFormValidation.long = true;

    Navigator.of(navigatorKey.currentContext!).pop();
  }
}
