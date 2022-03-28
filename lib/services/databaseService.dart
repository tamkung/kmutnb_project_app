import 'package:firebase_database/firebase_database.dart';
import 'package:kmutnb_app/models/student.dart';
/*
class DatabaseService {
  static Future<List<Locat>> getNeeds() async {
    Query needsSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("Student")
        .orderByKey();

    print(needsSnapshot); // to debug and see if data is returned

    List<Locat> needs;

    Map<dynamic, dynamic> values = needsSnapshot.value;
    values.forEach((key, values) {
      needs.add(Locat.fromSnapshot(values));
    });

    return needs;
  }
}
*/