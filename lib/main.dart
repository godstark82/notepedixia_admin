import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/firebase_options.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/screens/login/login_screen.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';

bool isLogined = false;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.openBox('cache');
  isLogined = Hive.box('cache').get('login') ?? false;
  await MainClass.init().whenComplete(() => runApp(const Dashboard()));
}

class MainClass {
  static Future<void> init() async {
    ItemsClass.init();
    OrdersClass.init();
    debugPrint('initialization completed');
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notepedixia Admin',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: isLogined ? const MainScreen() : const LoginScreen(),
    );
  }
}
