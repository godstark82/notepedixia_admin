import 'package:flutter/material.dart';
import 'package:notepedixia_admin/controllers/MenuAppController.dart';
import 'package:notepedixia_admin/responsive.dart';

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
            title: "Orders",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () {
              currentIndex = 1;
              setState(() {});
            },
          ),
          DrawerListTile(
            index: 2,
            title: "Categories",
            svgSrc: "assets/icons/menu_task.svg",
            press: () {
              currentIndex = 2;
              setState(() {});
            },
          ),
          DrawerListTile(
            index: 3,
            title: "Store",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              currentIndex = 3;
              setState(() {});
            },
          ),
          DrawerListTile(
            index: 4,
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {
              currentIndex = 4;
              setState(() {});
            },
          ),
          DrawerListTile(
            index: 5,
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {
              currentIndex = 5;
              setState(() {});
            },
          ),
          DrawerListTile(
            index: 6,
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {
              currentIndex = 6;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
