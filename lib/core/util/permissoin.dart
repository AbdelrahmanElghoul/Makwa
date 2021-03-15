import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermission {
  // Future<bool> requestLocationPermission() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   return Future.value(permission == LocationPermission.always);
  // }

  // Future<bool> checkPermissino() async {
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.deniedForever)
  //     await Geolocator.openLocationSettings();
  //   else if (permission == LocationPermission.always) {
  //     return Future.value(true);
  //   } else
  //    return requestLocationPermission();

  //   return Future.value(false);
  // }

  Future<bool> checkPermission(context) async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      return requestPermission(context);
    }

    return Future.value(status == PermissionStatus.granted);
  }

  Future<bool> requestPermission(context) async {
    var status = await Permission.location.status;
    if (!status.isGranted && !status.isPermanentlyDenied) {
      Map<Permission, dynamic> statuses = await [
        Permission.location,
      ].request();
      print('mDebug: ${statuses[Permission.location]}');
      // var status = await Permission.location.status;
      bool granted = statuses[Permission.location] == PermissionStatus.granted;
      if (!granted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('permission not granted'),
            duration: Duration(seconds: 1),
          ),
        );
      return Future.value(granted);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('permission not granted'),
             duration: Duration(seconds: 1),
        ),
      );
      return Future.value(false);
    }
  }
}
