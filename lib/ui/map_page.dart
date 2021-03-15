import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:makwa/core/model/map_page_model.dart';
import 'package:makwa/core/util/permissoin.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapModel model;
  GoogleMapController mapController;
  @override
  void initState() {
    model = MapModel(context, () {
      setState(() {});
    });
    super.initState();
    RequestPermission().checkPermission(context).then((granted) {
      if (granted)
        Geolocator.getPositionStream(
                desiredAccuracy: LocationAccuracy.best,
                intervalDuration: Duration(seconds: 1)) //refresh each 1 second
            .listen((Position position) {
          print('mDebug: position=$position');
          model.updateLocation(LatLng(position.latitude, position.longitude));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              // onTap: (latLng) {
              //   // getLocation(latLng);
              //   print('mDebug: map pressed:${latLng}');
              // },
              onMapCreated: (GoogleMapController controller) {
                print('mDebug:controller $controller');
                model.setMapController(controller);
              },
              markers: model.markers,

              mapToolbarEnabled: true,
              minMaxZoomPreference: MinMaxZoomPreference(0, 10000),
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              padding:
                  EdgeInsets.symmetric(vertical: mediaQuery.size.height * .15),
              initialCameraPosition: CameraPosition(
                bearing: 30,
                zoom: 15,
                // target: LatLng(30.0409126, 31.209564))),
                target: LatLng(30.0409126, 31.209564),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(15),
                height: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.height * .10
                    : mediaQuery.size.height * .2,
                width: mediaQuery.orientation == Orientation.portrait
                    ? mediaQuery.size.width
                    : mediaQuery.size.width * .5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                  ),
                ),
                child: Center(
                    child: Text(
                  model.message,
                  textAlign: TextAlign.center,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
