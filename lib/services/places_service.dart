import 'package:kmutnb_app/models/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlacesService {
  final key = 'AIzaSyCxMhD4_xki3jdLIAnovYoWjrxj8bWauHg';
  final keyword = 'hospital';

  Future<List<Place>> getPlaces(
      double lat, double lng, BitmapDescriptor icon) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=$keyword&rankby=distance&key=$key');
    var response = await http.get(url);
    var json = await convert.jsonDecode(response.body);
    var jsonResults = await json['results'] as List;
    return jsonResults.map((place) => Place.fromJson(place, icon)).toList();
  }
}
