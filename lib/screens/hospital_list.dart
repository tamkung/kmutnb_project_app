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
  List<String> _province = [
    'กรุงเทพมหานคร',
    'กระบี่',
    'กาญจนบุรี',
    'กาฬสินธุ์',
    'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่',
    'พะเยา',
    'ภูเก็ต',
    'มหาสารคาม',
    'มุกดาหาร',
    'แม่ฮ่องสอน',
    'ยะลา',
    'ยโสธร',
    'ร้อยเอ็ด',
    'ระนอง',
    'ระยอง',
    'ราชบุรี',
    'ลพบุรี',
    'ลำปาง',
    'ลำพูน',
    'เลย',
    'ศรีสะเกษ',
    'สกลนคร',
    'สงขลา',
    'สตูล',
    'สมุทรปราการ',
    'สมุทรสงคราม',
    'สมุทรสาคร',
    'สระแก้ว',
    'สระบุรี',
    'สิงห์บุรี',
    'สุโขทัย',
    'สุพรรณบุรี',
    'สุราษฎร์ธานี',
    'สุรินทร์',
    'หนองคาย',
    'หนองบัวลำภู',
    'อ่างทอง',
    'อุดรธานี',
    'อุทัยธานี',
    'อุตรดิตถ์',
    'อุบลราชธานี',
    'อำนาจเจริญ',
  ];
  String? _selectedProvince;

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
    var size = MediaQuery.of(context).size;
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    spreadRadius: 3,
                  ),
                ],
              ),
              padding: EdgeInsets.only(
                left: size.width * 0.1,
                right: size.width * 0.1,
              ),
              margin: EdgeInsets.only(
                bottom: size.width * 0.03,
              ),
              child: DropdownButton(
                iconEnabledColor: Colors.white,
                hint: Text(
                  'กรุณาเลือกจังหวัด',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                value: _selectedProvince,
                onChanged: (newValue) {
                  setState(() {
                    _selectedProvince = newValue.toString();
                  });
                },
                items: _province.map((type) {
                  return DropdownMenuItem(
                    child: new Text(type),
                    value: type,
                  );
                }).toList(),
              ),
            ),
            _items.length > 0
                ? Expanded(
                    child: _selectedProvince != null
                        ? ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              var sta = "";
                              if (_items[index]["at"] == true) {
                                sta = "เปิด";
                              } else {
                                sta = "ปิด";
                              }
                              return _items[index]["p"] == _selectedProvince
                                  ? Card(
                                      margin: EdgeInsets.all(5),
                                      child: ListTile(
                                        //leading: Text(_items[index]["t"]),
                                        title: Text(_items[index]["n"]),
                                        subtitle: Container(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(_items[index]["p"]),
                                              Text(_items[index]["mob"]
                                                  .toString()),
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
                                    )
                                  : Container();
                            },
                          )
                        : ListView.builder(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
