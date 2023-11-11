// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/screens/category/category.dart';
import 'package:notepedixia_admin/screens/dashboard/dashboard_screen.dart';
import 'package:notepedixia_admin/screens/shop/shop.dart';


int currentIndex = 1;

List<Widget> screens = [
  const DashboardScreen(),
  const ShopScreen(),
  const CategoryScreen(),
  const ShopScreen(),
  const ShopScreen(),
  const ShopScreen(),
  const ShopScreen(),
];
