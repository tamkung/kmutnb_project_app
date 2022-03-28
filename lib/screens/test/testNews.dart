import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'dart:convert' show utf8;
import 'package:url_launcher/url_launcher.dart';

class TestNews extends StatefulWidget {
  const TestNews({Key? key}) : super(key: key);

  @override
  State<TestNews> createState() => _TestNewsState();
}

class _TestNewsState extends State<TestNews> {
  late DateTime dt;
  bool chk = false;

  dynamic txt_author,
      txt_ittle,
      txt_description,
      txt_url,
      txt_urlToImage,
      txt_publishedAt;

  List _itemsNews = [];
  var urlNews = Uri.parse(
      'https://newsapi.org/v2/top-headlines?country=th&category=health&apiKey=836b325617444516a5700b42904e00c9');

  // Fetch content from the json file
  Future<void> readNews() async {
    final responseNews = await http.get(urlNews);
    final dataNews = await json.decode(utf8.decode(responseNews.bodyBytes));

    setState(() {
      _itemsNews = dataNews["articles"];
    });
    //print(data);
  }

  // Future setdata() async {
  //   dt = DateTime.parse(_items[0]["publishedAt"]);
  //   dynamic outputFormat = DateFormat('dd/MM/yyyy');
  //   //txn_date = outputFormat.format(dt);

  //   txt_author = _items[0]["author"];
  //   txt_ittle = _items[0]["title"];
  //   txt_description = _items[0]["description"];
  //   txt_url = _items[0]["url"];
  //   txt_urlToImage = _items[0]["urlToImage"];
  //   txt_publishedAt = outputFormat.format(dt);
  //   chk = true;
  // }

  @override
  void initState() {
    super.initState();
    readNews();
    //setdata();
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
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              await readNews();
              print(_itemsNews);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _itemsNews.length > 0
                ? Expanded(
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
                          margin: EdgeInsets.all(5),
                          child: ListTile(
                            //leading: Text(_items[index]["title"]),
                            title: Text(txt_ittle),
                            subtitle: Column(
                              children: [
                                txt_urlToImage != null
                                    ? Image.network(txt_urlToImage)
                                    : Text('ไม่มีรูปภาพ'),
                                Text(txt_description ?? ''),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(txt_author),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Text(txt_publishedAt),
                                  ],
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
                  )
                : Container(),
          ],
        ),
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
