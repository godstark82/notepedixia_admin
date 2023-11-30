// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/screens/account/account.dart';
import 'package:notepedixia_admin/screens/category/category.dart';
import 'package:notepedixia_admin/screens/dashboard/dashboard_screen.dart';
import 'package:notepedixia_admin/screens/notifications/notifications.dart';
import 'package:notepedixia_admin/screens/orders/orders.dart';
import 'package:notepedixia_admin/screens/settings/settings.dart';
import 'package:notepedixia_admin/screens/shop/shop.dart';

int currentIndex = 1;

List<Widget> screens = [
  const DashboardScreen(),
  const OrdersScreen(),
  const CategoryScreen(),
  const ShopScreen(),
  const Notifications(),
  const AccountScreen(),
  const SettingsScreen(),
];
