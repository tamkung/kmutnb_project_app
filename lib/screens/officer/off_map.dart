import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OfficerMap extends StatefulWidget {
  static const routeName = '/';

  const OfficerMap({Key? key}) : super(key: key);

  @override
  _OfficerMapState createState() => _OfficerMapState();
}

class _OfficerMapState extends State<OfficerMap> {
  Completer<GoogleMapController> _controller = Completer();
  final dbfirebase = FirebaseDatabase.instance.reference().child('Student');

  late LatLng setCurrentPostion;
  late LocationData currentLocation;
  bool check = false;
  Set<Marker> markers = new Set();

  get txtload => null;

  void _getUserLocation() async {
    var position = await GeolocatorPlatform.instance.getCurrentPosition();

    setState(() {
      setCurrentPostion = LatLng(position.latitude, position.longitude);
      check = true;
    });
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    Future.delayed(Duration(seconds: 5), () {
      print("Executed after 5 seconds");
      var db = FirebaseDatabase.instance.reference().child("Student");

      db.once().then((DataSnapshot snapshot) async {
        final Uint8List pinRed = await getBytesFromAsset(
            path: 'assets/images/pin_red.png', //paste the custom image path
            width: 80 // size of custom image as marker
            );
        final Uint8List pinGreen = await getBytesFromAsset(
            path: 'assets/images/pin_green.png', //paste the custom image path
            width: 80 // size of custom image as marker
            );
        final Uint8List pinBlue = await getBytesFromAsset(
            path: 'assets/images/pin_blue.png', //paste the custom image path
            width: 80 // size of custom image as marker
            );
        final Uint8List pinYellow = await getBytesFromAsset(
            path: 'assets/images/pin_yellow.png', //paste the custom image path
            width: 80 // size of custom image as marker
            );
        final Uint8List pinPurple = await getBytesFromAsset(
            path: 'assets/images/pin_purple.png', //paste the custom image path
            width: 80 // size of custom image as marker
            );

        Map<dynamic, dynamic> values = snapshot.value;
        //print(values.toString());
        values.forEach((k, v) async {
          //var setmarker = chk(v["Status"]) as Uint8List;
          // print("Test1" + '$setmarker');
          // print("Test2" + '$customMarker1');
          setState(() {
            markers.add(
              Marker(
                //add first marker
                markerId: MarkerId(k),
                position: LatLng(
                  double.parse(v["latitude"]),
                  double.parse(v["longitude"]),
                ),
                infoWindow: InfoWindow(
                  //popup info
                  title: v["Name"],
                  snippet: v["Status"],
                ),
                icon: BitmapDescriptor.fromBytes(v["Status"] == 'ปกติ'
                    ? pinGreen
                    : v["Status"] == 'กักตัว'
                        ? pinYellow
                        : v["Status"] == 'ติดเชื้อ'
                            ? pinRed
                            : v["Status"] == 'รอยืนยัน'
                                ? pinBlue
                                : pinBlue), //Icon for Marker
              ),
            );
          });
        });
        //await _order(widget.tableName);
      });
    });

    //setState(() {
/*
      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(29.7099116, 89.3132343), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Second ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(21.7137735, 81.315626), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
*/
    //add more markers here
    // });

    return markers;
  }

  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    _getUserLocation();
    getmarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: check == false
          ? Center(
              child: txtload,
            )
          : GoogleMap(
              // ignore: sdk_version_set_literal
              markers: getmarkers(),
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: setCurrentPostion, //กำหนดพิกัดเริ่มต้นบนแผนที่
                zoom: 16, //กำหนดระยะการซูม สามารถกำหนดค่าได้ 0-20
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
    );
  }

/*
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
  */
}
