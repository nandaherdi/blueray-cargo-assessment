import 'package:blueray_cargo_assessment/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart' as places;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsViewModel with ChangeNotifier {
  places.AutocompletePrediction? _selectedPrediction;
  LatLng? _selectedCoordinate = LatLng(32, 104.9);
  Placemark? _selectedPlacemark;
  bool _isMarkMoving = true;

  places.AutocompletePrediction? get selectedPrediction => _selectedPrediction;
  LatLng? get selectedCoordinate => _selectedCoordinate;
  Placemark? get selectedPlacemark => _selectedPlacemark;
  bool get isMarkMoving => _isMarkMoving;

  set selectedPrediction(places.AutocompletePrediction? newValue) {
    _selectedPrediction = newValue;
    notifyListeners();
  }

  set selectedCoordinate(LatLng? newValue) {
    _selectedCoordinate = newValue;
    notifyListeners();
  }

  set selectedPlacemark(Placemark? newValue) {
    _selectedPlacemark = newValue;
    notifyListeners();
  }

  set isMarkMoving(bool newValue) {
    _isMarkMoving = newValue;
    notifyListeners();
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
    selectedPlacemark = placemarks.first;
    selectedCoordinate = LatLng(locations.first.latitude, locations.first.longitude);

    await mapController.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: selectedCoordinate!, zoom: 18)),
    );
  }

  void onMapDrag(double latitude, longitude) async {
    selectedCoordinate = LatLng(latitude, longitude);
  }

  Future<void> onMapIdle() async {
    isMarkMoving = false;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      selectedCoordinate!.latitude,
      selectedCoordinate!.latitude,
    );
    selectedPlacemark = placemarks.first;
  }
}
