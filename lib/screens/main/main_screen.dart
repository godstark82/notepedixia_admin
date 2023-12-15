// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/controllers/screens.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/screens/account/account.dart';
import 'package:notepedixia_admin/screens/settings/settings.dart';

import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sideMenu(),
      appBar: Responsive.isDesktop(context)
          ? AppBar(
              leading: const SizedBox(),
              title: const Text('Notepediax Admin Panel'),
              actions: [
                IconButton(
                    tooltip: 'Profile',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AccountScreen()));
                    },
                    icon: const Icon(Icons.person)),
                IconButton(
                    tooltip: 'Settings',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsScreen()));
                    },
                    icon: const Icon(Icons.settings)),
              ],
            )
          : AppBar(
              title: const Text('Notepediax'),
            ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: sideMenu()),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: screens[currentIndex],
            ),
          ],
        ),
      ),
    );
  }

  Widget sideMenu() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            index: 0,
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () {
              currentIndex = 0;
              setState(() {});
           
            },
          ),
          DrawerListTile(
            index: 1,
            title: "Pending Orders",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              currentIndex = 1;
              setState(() {});
              

            },
          ),
          DrawerListTile(
            index: 2,
            title: "Completed Orders",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              currentIndex = 2;
              setState(() {});
           

            },
          ),
          DrawerListTile(
            index: 3,
            title: "Rejected Orders",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              currentIndex = 3;
              setState(() {});
             

            },
          ),
          DrawerListTile(
            index: 4,
            title: "Carousel",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              currentIndex = 4;
              setState(() {});
          

            },
          ),
          DrawerListTile(
            index: 5,
            title: "Categories",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              currentIndex = 5;
              setState(() {});
           

            },
          ),
          DrawerListTile(
            index: 6,
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              currentIndex = 6;
              setState(() {});
            

            },
          ),
          DrawerListTile(
            index: 7,
            title: "Notifications",
            badge: notifications.isNotEmpty
                ? Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: Colors.red),
                    child: Center(child: Text(notifications.length.toString())))
                : const SizedBox(),
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              currentIndex = 7;
              setState(() {});
            

            },
          ),
          DrawerListTile(
            index: 8,
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              currentIndex = 8;
              setState(() {});
             

            },
          ),
          DrawerListTile(
            index: 9,
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              currentIndex = 9;
              setState(() {});
             

            },
          ),
        ],
      ),
    );
  }
}
