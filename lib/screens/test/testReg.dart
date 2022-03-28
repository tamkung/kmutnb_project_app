import 'dart:math';
import 'package:intl/intl.dart';

void main(List<String> args) {
  //var date = new DateTime(2018, 1, 5);
  var date = new DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd').format(date);
  // var newDate = new DateTime(date.year, date.month - 1, date.day - 14);
  // var newDate = new DateTime.now();

  for (int i = 0; i < 10; i++) {
    var newDate = new DateTime(date.year, date.month, date.day - i);
    String formattedDate = DateFormat('dd-MM-yyyy').format(newDate);
    print(formattedDate);

    //print('${newDate.day - i} / ${newDate.month} / ${newDate.year}');
    //chooseDate();

  }
  //print(newDate);

  /*////////////////Reg
  var mail1 = "s6302041520121@email.kmutnb.ac.th";
  var mail2 = "hm82529@gmail.com";
  var mail3 = "waragorn.t@tct.kmutnb.ac.th";

  bool emailValid1 =
      RegExp(r"^[a-zA-Z0-9]+@email+\.+kmutnb+\.ac+\.th").hasMatch(mail1);
  bool emailValid2 =
      RegExp(r"^[a-zA-Z0-9]+.[a-zA-z]+@[a-zA-z]+\.+kmutnb+\.ac+\.th")
          .hasMatch(mail1);
  if (emailValid1) {
    print('Student');
  } else if (emailValid2) {
    print('Officer');
  } else {
    print('None');
  }*/

  // [a-zA-Z0-9]+@email+\.+kmutnb+\.ac+\.th
  // [a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.+kmutnb+\.ac+\.th email1
  // [a-zA-Z0-9]+.[a-zA-z]+@[a-zA-z]+\.+kmutnb+\.ac+\.th email Officer

  /*
  String email = "s6302041520121@gmail.kmutnb.ac.th";
  var emailValid = RegExp(r"^[\d]+[0-9]");

  // RegExp(r"^[a-zA-Z0-9]+.[a-zA-z]+@[a-zA-z]+\.+kmutnb+\.ac+\.th email")
  //     .(email);

  //String r = email.splitMapJoin(emailValid);
  List<int> id = [];
  int n;
  print(email.length);
  for (var i = 1; i <= 13; i++) {
    print(email[i]);
    n = int.parse(email[i]);
    id.add(n);
  }
  print(id.join());
  //String s = "s6302041520121@gmail.kmutnb.ac.th";
  //int idx = s.indexOf(":");
  // List parts = [s.substring(0, idx).trim(), s.substring(idx + 1).trim()];
  //print(emailValid);
  int timestamp = DateTime.now().millisecondsSinceEpoch;
  DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
  String datetime = tsdate.day.toString() +
      "/" +
      tsdate.month.toString() +
      "/" +
      tsdate.year.toString();
  print(datetime);
  //output: 2021/12/4/output: 1638592424384
  //print("current phone data is: $myDateTime");
  */
}
//[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.+kmutnb+\.ac+\.th    Mail kmutnb