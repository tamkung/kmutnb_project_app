import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'dart:convert' show utf8;
import 'package:kmutnb_app/screens/map.dart';

class LocationList extends StatefulWidget {
  @override
  _LocationLState createState() => _LocationLState();
}

class _LocationLState extends State<LocationList> {
  List _items = [];
  var url = Uri.parse('https://covid-lab-data.pages.dev/latest.json');

  // Fetch content from the json file
  Future<void> readJson() async {
    final response = await http.get(url);
    final data = await json.decode(utf8.decode(response.bodyBytes));

    setState(() {
      _items = data["items"];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    //readJson();
    return Scaffold(
      backgroundColor: pColor,
      appBar: AppBar(
        backgroundColor: pColor,
        centerTitle: true,
        title: Text(
          'สถานที่ตรวจเชื้อ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.refresh),
          //   onPressed: () {
          //     readJson();
          //   },
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _items.length > 0
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        var sta = "";
                        if (_items[index]["at"] == true) {
                          sta = "เปิด";
                        } else {
                          sta = "ปิด";
                        }
                        return Card(
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            //leading: Text(_items[index]["t"]),
                            title: Text(_items[index]["n"]),
                            subtitle: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_items[index]["p"]),
                                  Text(_items[index]["mob"].toString()),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.directions,
                                color: Colors.amber.shade800,
                              ),
                              onPressed: () {
                                _openMap(
                                    _items[index]["lat"],
                                    _items[index]["lng"],
                                    _items[index]["n"],
                                    _items[index]["p"]);
                              },
                            ),
                            //isThreeLine: true,
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future _openMap(
      double latitude, double longitude, String name, String p) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapScreen(
          lat: latitude,
          lon: longitude,
          name: name,
          p: p,
        ),
      ),
    );
  }
}
