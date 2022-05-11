import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kmutnb_app/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'dart:convert' show utf8;

import 'package:url_launcher/url_launcher.dart';

class StudentHome extends StatefulWidget {
  static const routeName = '/';

  const StudentHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentHomeState();
  }
}

class _StudentHomeState extends State<StudentHome> {
  late DateTime dt;
  bool chk = false;
  bool chk2 = false;
  bool view = false;
  dynamic txn_date,
      new_case,
      total_case,
      new_recovered,
      total_recovered,
      new_death,
      total_death;
  dynamic txt_author,
      txt_ittle,
      txt_description,
      txt_url,
      txt_urlToImage,
      txt_publishedAt;

  final nFormat = NumberFormat("#,###");
  List _items = [];
  List _itemsNews = [];

  var url =
      Uri.parse('https://covid19.ddc.moph.go.th/api/Cases/today-cases-all');

  var urlNews = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=th&category=health&apiKey=836b325617444516a5700b42904e00c9');

  Future<void> readJson() async {
    final response = await http.get(url);
    final data = await json.decode(utf8.decode(response.bodyBytes));

    final responseNews = await http.get(urlNews);
    final dataNews = await json.decode(utf8.decode(responseNews.bodyBytes));

    setState(() {
      _items = data!;
      _itemsNews = dataNews["articles"];
    });
    chk2 = true;
    //print(data);
    // print(_items['txn_date']);
  }

  @override
  void initState() {
    super.initState();
    setdata();
    readJson();
  }

  Future setdata() async {
    if (chk2) {
      dt = DateTime.parse(_items[0]["txn_date"]);
      dynamic outputFormat = DateFormat('dd/MM/yyyy');
      //txn_date = outputFormat.format(dt);
      txn_date = outputFormat.format(dt);
      new_case = nFormat.format(_items[0]["new_case"]);
      total_case = nFormat.format(_items[0]["total_case"]);
      new_recovered = nFormat.format(_items[0]["new_recovered"]);
      total_recovered = nFormat.format(_items[0]["total_recovered"]);
      new_death = nFormat.format(_items[0]["new_death"]);
      total_death = nFormat.format(_items[0]["total_death"]);
      chk = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setdata();
    return Scaffold(
      body: Container(
        color: pColor,
        child: chk != false
            ? Column(
                children: [
                  Container(
                    color: pColor,
                    height: size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'สถานการณ์โควิดวันนี้',
                          style: TextStyle(color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            if (view) {
                              setState(() {
                                view = false;
                              });
                            } else if (!view) {
                              setState(() {
                                view = true;
                              });
                            }
                          },
                          icon: view == false
                              ? Icon(Icons.expand_more)
                              : Icon(Icons.expand_less),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  view != false
                      ? Container(
                          margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          //color: pColor,
                          width: size.width,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            width: size.width * 0.42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0XFF1D2366),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0XFF1D2366),
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.center,
                                  //   children: [
                                  //     Text(
                                  //       'สถานการณ์โควิดวันนี้',
                                  //       textAlign: TextAlign.right,
                                  //       style: TextStyle(
                                  //         color: Colors.white,
                                  //         fontSize: size.height * 0.03,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  SizedBox(
                                    height: size.height * 0.015,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: size.width * 0.8,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0XFF765017),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0XFF765017),
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'วันที่ : ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: size.height * 0.025,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        txt('$txn_date'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.005,
                                  ),
                                  row(),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Expanded(
                    // flex: 1,
                    child: Container(
                      //color: pColor,
                      //padding: EdgeInsets.all(5),
                      child: ListView.builder(
                        itemCount: _itemsNews.length,
                        itemBuilder: (context, index) {
                          dt = DateTime.parse(_itemsNews[0]["publishedAt"]);
                          dynamic outputFormat = DateFormat('dd/MM/yyyy');
                          //txn_date = outputFormat.format(dt);

                          txt_author = _itemsNews[index]["author"];
                          txt_ittle = _itemsNews[index]["title"];
                          txt_description = _itemsNews[index]["description"];
                          txt_url = _itemsNews[index]["url"];
                          txt_urlToImage = _itemsNews[index]["urlToImage"];
                          txt_publishedAt = outputFormat.format(dt);
                          chk = true;

                          if (txt_author == null) {
                            txt_author = 'ไม่มีข้อมูล';
                          } else if (txt_ittle == null) {
                            txt_ittle = 'ไม่มีข้อมูล';
                          } else if (txt_description == null) {
                            txt_description = 'ไม่มีข้อมูล';
                          } else if (txt_publishedAt == null) {
                            txt_publishedAt = 'ไม่มีข้อมูล';
                          }
                          return Card(
                            //margin: EdgeInsets.all(5),
                            child: ListTile(
                              //leading: Text(_items[index]["title"]),
                              title: Text(txt_ittle),
                              subtitle: Column(
                                children: [
                                  txt_urlToImage != null
                                      ? Image.network(txt_urlToImage)
                                      : Text('ไม่มีรูปภาพ'),
                                  Text(txt_description ?? ''),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('แหล่งที่มา : ' + txt_author),
                                        SizedBox(
                                          width: size.width * 0.05,
                                        ),
                                        Text('วันที่ : ' + txt_publishedAt),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              //     '\n' +
                              //     _items[index]["mob"].toString()),
                              // trailing: Icon(Icons.more_vert),
                              // isThreeLine: true,
                              onTap: () {
                                _browser(_itemsNews[index]["url"]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: txtload,
              ),
      ),
    );
  }

  Widget row() {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          //width: size.width,
          width: size.width * 0.40,
          //color: pColor,

          child: Column(
            children: [
              contain('ติดเชื้อวันนี้', new_case, Color(0XFFe70000)),
              SizedBox(height: size.height * 0.015),
              contain('ติดเชื้อสะสม', total_case, Color(0XFF9B0000)),
              SizedBox(height: size.height * 0.015),
              contain('เสียชีวิตวันนี้', new_death, Color(0XFF747474)),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(5),
          //width: size.width,
          width: size.width * 0.40,

          child: Column(
            children: [
              contain('หายป่วยวันนี้', new_recovered, Color(0XFF609D02)),
              SizedBox(height: size.height * 0.015),
              contain('หายป่วยสะสม', total_recovered, Color(0XFF447C00)),
              SizedBox(height: size.height * 0.015),
              contain('เสียชีวิตสะสม', total_death, Color(0XFF282828)),
            ],
          ),
        ),
      ],
    );
  }

  Widget contain(name, val, color) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(
                fontSize: size.height * 0.023,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          txt(val),
        ],
      ),
    );
  }

  Widget txt(val) {
    var size = MediaQuery.of(context).size;
    return Text(
      '$val',
      style: TextStyle(
        fontSize: size.height * 0.023,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Future<void> _browser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
}
