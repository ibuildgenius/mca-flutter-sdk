import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/dialogs.dart';

determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  Map<String, dynamic> data = {};

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Dialogs.showNoticeSnackBar('Kindly enable your location setting');
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    return Future.error('Location permissions are denied');
  }

  if (permission == LocationPermission.deniedForever) {
    openAppSettings();
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  data['lon'] = position.longitude;
  data['lat'] = position.latitude;
  data['alt'] = position.altitude;
  return data;
  // return await Geolocator.getCurrentPosition();
}

getLocationData() async {
  Map<String, dynamic> data = {};
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  data['lon'] = position.longitude;
  data['lat'] = position.latitude;
  data['alt'] = position.altitude;
  return data;
}
