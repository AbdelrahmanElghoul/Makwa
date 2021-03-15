import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class Http {
  Future<dynamic> isCovered(BuildContext context, LatLng latLng) async {
    String url =
        'https://dev.makwaapp.com/api/V1/locations/check-location?latitude=${latLng.latitude}&longitude=${latLng.longitude}';
    try {
      Response response = await Dio().post(url);
      // print('mDebug: $response');

      return response;
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       e.toString(),
      //     ),
      //     duration: Duration(seconds: 1),
      //   ),
      // );
      print('isCovered error: $e');
      return Future.value(null);
    }
  }
}
