import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nugofficer/utility/dialog.dart';
import 'package:nugofficer/widgets/show_progress.dart';

class Information extends StatefulWidget {
  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  double lat, lng;
  Map<MarkerId, Marker> map = {};

  @override
  void initState() {
    super.initState();
    findPermission();
  }

  void addMarker(LatLng latLng, String id) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: 'You Here !!!', snippet: 'lat = ${latLng.latitude}, lng = ${latLng.longitude}'),
    );
    map[markerId] = marker;
  }

  Future<Null> findPermission() async {
    bool locationServiceEnable = await Geolocator.isLocationServiceEnabled();
    if (locationServiceEnable) {
      LocationPermission locationPermission =
          await Geolocator.checkPermission();

      if (locationPermission == LocationPermission.deniedForever) {
        exitDialog('Permission DeniedForever ? Please Open Permission');
      } else if (locationPermission == LocationPermission.denied) {
        await Geolocator.requestPermission().then((value) {
          if (value == LocationPermission.deniedForever) {
            exitDialog('Permission DeniedForever ? Please Open Permission');
          } else {
            findLatLng();
          }
        });
      } else {
        findLatLng();
      }
    } else {
      exitDialog('Please Open Location Service');
    }
  }

  Future<Null> findLatLng() async {
    print('########## findLatLng Works');
    Position position = await findPosition();
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
      print('##### lat= $lat, lng = $lng');

      addMarker(LatLng(lat, lng), 'idUser');
    });
  }

  Future<Position> findPosition() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Future<Null> exitDialog(String string) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(string),
        children: [
          ElevatedButton(
            onPressed: () {
              exit(0);
            },
            child: Text(
              'Exit App',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: lat == null
          ? ShowProgress()
          : Center(
            child: Container(width: 250,height: 250,
              child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  markers: Set<Marker>.of(map.values),
                ),
            ),
          ),
    );
  }
}
