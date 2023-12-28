// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/screens/account/account.dart';
import 'package:notepedixia_admin/screens/carousel/carousel.dart';
import 'package:notepedixia_admin/screens/category/category.dart';
import 'package:notepedixia_admin/screens/dashboard/dashboard_screen.dart';
import 'package:notepedixia_admin/screens/filters/filters_screen.dart';
import 'package:notepedixia_admin/screens/notifications/notifications.dart';
import 'package:notepedixia_admin/screens/orders/completed_orders.dart';
import 'package:notepedixia_admin/screens/orders/pending_orders.dart';
import 'package:notepedixia_admin/screens/orders/rejected_orders.dart';
import 'package:notepedixia_admin/screens/settings/settings.dart';
import 'package:notepedixia_admin/screens/shop/notes.dart';
import 'package:notepedixia_admin/screens/shop/shop.dart';

int currentIndex = 1;

List<Widget> screens = [
  const DashboardScreen(),
  const PendingOrdersScreen(),
  const CompletedOrdersScreen(),
  const RejectedOrdersScreen(),
  const CarouselScreen(),
  const CategoryScreen(),
  const FiltersScreen(),
  const ShopScreen(),
  const NotesScreen(),
  const Notifications(),
  const AccountScreen(),
  const SettingsScreen(),
];
