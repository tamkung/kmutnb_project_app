// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:kmutnb_app/config/constant.dart';
import 'package:kmutnb_app/models/place.dart';
import 'package:kmutnb_app/screens/covid_manual_1.dart';
import 'package:kmutnb_app/screens/covid_manual_2.dart';
import 'package:kmutnb_app/screens/home.dart';
import 'package:kmutnb_app/screens/hospital_list.dart';
import 'package:kmutnb_app/screens/login/login.dart';
import 'package:kmutnb_app/screens/map.dart';
import 'package:kmutnb_app/screens/map2.dart';
import 'package:kmutnb_app/screens/notlogin/covid_manual_1_not.dart';
import 'package:kmutnb_app/screens/notlogin/pr_kmutnb_not.dart';
import 'package:kmutnb_app/screens/officer/off_launcher.dart';
import 'package:kmutnb_app/screens/officer/off_login.dart';
import 'package:kmutnb_app/screens/officer/view_timeline.dart';
import 'package:kmutnb_app/screens/pr_kmutnb.dart';
import 'package:kmutnb_app/screens/search.dart';
import 'package:kmutnb_app/screens/student/help/contact.dart';
import 'package:kmutnb_app/screens/student/help/keep.dart';
import 'package:kmutnb_app/screens/student/std_launcher.dart';
import 'package:kmutnb_app/screens/student/st_home.dart';
import 'package:kmutnb_app/services/geolocator_service.dart';
import 'package:kmutnb_app/services/places_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'screens/notlogin/covid_manual_2.dart';
import 'screens/student/help/change_status.dart';
import 'screens/student/help/help_food.dart';
import 'screens/student/help/help_menu.dart';
import 'screens/student/help/help_pill.dart';
import 'screens/student/help/help_tool.dart';
import 'screens/student/help/rate_infect.dart';
import 'screens/student/help/rate_keep.dart';
import 'screens/student/notifirebase.dart';
import 'screens/admin/superAdminHome.dart';
import 'screens/login/login_screen.dart';
import 'screens/officer/uploadFile.dart';
import 'screens/student/std_timeline.dart';
import 'package:intl/intl.dart';

import 'screens/telhotline.dart';
import 'screens/test/testNews.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification.body}');
}

Future<void> main() async {
  //Intl.defaultLocale = 'th';

  //initializeDateFormatting('th_TH', 'th_TH');
  //เปิด Connection Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();
  final placesService = PlacesService();
  bool login = true;
  //dynamic user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(
          create: (context) => locatorService.getLocation(),
        ),
        FutureProvider(create: (context) {
          ImageConfiguration configuration =
              createLocalImageConfiguration(context);
          return BitmapDescriptor.fromAssetImage(
              configuration, 'assets/images/hospital1.png');
        }),
        ProxyProvider2<Position, BitmapDescriptor, Future<List<Place>>>(
          update: (context, position, icon, places) {
            return (position != null)
                ? placesService.getPlaces(
                    position.latitude, position.longitude, icon)
                : null;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Covid App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: pColor,
          // textTheme: GoogleFonts.latoTextTheme(
          //   Theme.of(context)
          //       .textTheme, // ถ้าไม่ใส่ มันจะตั้งค่า Default ทุกอย่างตาม ThemeData.light().textTheme
          // ),
        ),
        //home: LocationList(),
        home: HomeScreen(),
        //home: HomeScreen(),
        /*
        home: FirebaseAuth.instance.currentUser == null
            
            : Launcher(),
            */
        routes: {
          //NotLogin
          'Manual1Not': (context) => CovidManual1Not(),
          'Manual2Not': (context) => CovidManual2Not(),
          'PRNot': (context) => PRkmutnbNot(),
          //Launcher.routeName: (context) => Launcher(),
          'Map': (context) => MapScreen2(),
          'Hospital': (context) => LocationList(),
          'Login': (context) => LoginScreen(),
          'Manual1': (context) => CovidManual1(),
          'Manual2': (context) => CovidManual2(),
          'PR': (context) => PRkmutnb(),
          'Tel': (context) => TelHotline(),
          //
          'Launcher': (context) => Launcher(),
          'OfficerLaun': (context) => OfficerLauncher(),
          'StudentPage': (context) => TestLogin(),
          'OfficerLogin': (context) => OfficerLogin(),
          //std
          'StdKeep': (context) => StdKeep(),

          'ChangeStatus': (context) => StdChangeStatus(),
          'StdRateKeep': (context) => StdRateKeep(),
          'StdRateInfect': (context) => StdRateInfect(),
          'HelpMenu': (context) => HelpMenu(),
          'HelpTool': (context) => HelpTool(),
          'HelpPill': (context) => HelpPill(),
          'HelpFood': (context) => HelpFood(),
          'HelpTel': (context) => Contact(),
          'Timeline': (context) => Timeline(),
          //
          //'NotiFire': (context) => NotiFire(),
          'Upload': (context) => UploadFire(),
          'ViewTimeline': (context) => ViewTimeline(),

          //
          'SuperAdmin': (context) => SuperAdminHome(),
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
