import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final locationProvider = FutureProvider.family((ref, _) async {
  Location location = Location();
  late bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      throw ("service not enabled");
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      throw ("permission not granted");
    }
  }

  _locationData = await location.getLocation();
  location.enableBackgroundMode(enable: true);
  location.onLocationChanged.listen((LocationData currentLocation) {
    print("location.onLocationChanged 発火 $currentLocation");
  });

  return _locationData;
});
