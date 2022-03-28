import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double lon;
  final String name;
  final String p;

  const MapScreen(
      {required this.lat,
      required this.lon,
      required this.name,
      required this.p})
      : super();

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationData currentLocation;

  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: pColor,
          title: Text(
            widget.name,
            style: TextStyle(),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => _goToHospital(widget.lat, widget.lon),
              icon: Icon(Icons.local_hospital),
            )
          ]),
      body: GoogleMap(
        // ignore: sdk_version_set_literal
        markers: {
          Marker(
              markerId: MarkerId("1"),
              position: LatLng(widget.lat, widget.lon),
              infoWindow: InfoWindow(title: widget.name, snippet: widget.p),
              onTap: () => _openOnGoogleMapApp(widget.lat, widget.lon)),
        },
        myLocationEnabled: true,
        zoomControlsEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.lat, widget.lon), //กำหนดพิกัดเริ่มต้นบนแผนที่
          zoom: 18, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      /*
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToMe,
        label: Text('My location'),
        icon: Icon(Icons.near_me),
      ),*/
    );
  }

  _openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      // Could not open the map.
    }
  }

  Future _zoomOutToNakhonSiThammarat() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = (await getCurrentLocation());
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(8.436427409373387, 99.96291472609138), 12));
  }

  Future _goToHospital(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = (await getCurrentLocation());
    controller.animateCamera(
      /*
      CameraUpdate.newLatLng(
        LatLng(latitude, longitude),
      ),*/
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16,
        ),
      ),
    );
  }

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    try {
      return await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        // Permission denied
      }
      return null!;
    }
  }

  Future _goToMe() async {
    final GoogleMapController controller = await _controller.future;
    currentLocation = (await getCurrentLocation());
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 16,
        ),
      ),
    );
  }
}
