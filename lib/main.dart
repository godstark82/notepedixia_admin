import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:notepedixia_admin/firebase_options.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/screens/login/login_screen.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';

bool isLogined = false;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await ItemsClass.init();
  await OrdersClass.init();
  await Hive.openBox('cache');
  isLogined = Hive.box('cache').get('login') ?? false;
  runApp(const Dashboard());
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
