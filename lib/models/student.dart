import 'package:firebase_database/firebase_database.dart';

class Locat {
  final String id;
  final String name;
  final String lat;
  final String lon;

  Locat({
    required this.id,
    required this.name,
    required this.lat,
    required this.lon,
  });

  Locat.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.key!,
        name = snapshot.value["Name"],
        lat = snapshot.value["latitude"],
        lon = snapshot.value["longitude"];

  toJson() {
    return {
      "Name": name,
      "latitude": lat,
      "longitude": lon,
    };
  }
}
