import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'fonctions/dates.dart';

Future<String> getCurrentCountryName() async {
  PermissionStatus geolocationStatus = await getLocationPermission();

  while (!geolocationStatus.isGranted) {
    geolocationStatus = await getLocationPermission();
  }

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  String? country;
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    country = placemarks[0].isoCountryCode;
  } catch (err) {}

  return country ?? "US"; // this will return country name
}

Future<PermissionStatus> getLocationPermission() async {
  var status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    final result = await Permission.locationWhenInUse.request();
    if (result.isPermanentlyDenied) {
      await openAppSettings();
      await wait();
      return await Permission.locationWhenInUse.request();
    } else {
      return result;
    }
  } else {
    return status;
  }
}

Future<PermissionStatus> getCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    final result = await Permission.camera.request();
    if (result.isPermanentlyDenied) {
      await openAppSettings();
      await wait();
      return await Permission.camera.request();
    } else {
      return result;
    }
  } else {
    return status;
  }
}

Future<PermissionStatus> getStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    final result = await Permission.camera.request();
    return result;
  } else {
    return status;
  }
}
