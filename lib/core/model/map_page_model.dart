import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:makwa/core/serices/http_api.dart';

class MapModel {
  final BuildContext _context;
  BuildContext get context => _context;
  GoogleMapController _mapController;
  GoogleMapController get mapController => _mapController;
  Set<Marker> markers = {};
  String markerId = 'marker';
  Function state;
  MapModel(this._context, this.state);
  String message = 'searching area...';
  bool granted = false;

  setMapController(GoogleMapController controller) async {
    _mapController = controller;
    // final granted = await RequestPermission().checkPermission(context);
    // this.granted = granted;
    // if (granted) {
    //   Position position = await Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.high);
    //   LatLng latlng = LatLng(position.latitude, position.longitude);
    //   print('mDebug: init current:$latlng');
    //   updateLocation(latlng);
    // }
  }

  void moveCamera(LatLng direction) async {
    if (mapController == null) return;
    double zoom = await mapController.getZoomLevel();
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: direction, zoom: zoom),
      ),
    );
  }

  void drawMark(LatLng latLng) async {
    markers.add(Marker(
      markerId: MarkerId(markerId),
      position: LatLng(latLng.latitude, latLng.longitude),
      // driverMap[userID].lat as double,driverMap[userID].lat as double

      // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));
    // print('mDebug: marked');
  }

  updateLocation(LatLng latLng) async {
    isCovered(latLng);
    moveCamera(latLng);
    drawMark(latLng);

    state();
  }

  isCovered(LatLng latLng) async {
    Response res = await Http().isCovered(context, latLng);
    if (res is Response) {
      if (res.data['success']) {
        message = '${res.data['data']['city']} is covered';
      } else
        message = 'this area not covered';
    } else {
      message = 'something went wrong';
    }

    state();
  }
}
