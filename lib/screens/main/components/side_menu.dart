// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:notepedixia_admin/controllers/MenuAppController.dart';

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.index,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      tileColor:
          index == currentIndex ? bgColor.withOpacity(1) : Colors.transparent,
      hoverColor: Colors.white30,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        height: 16,
        color: Colors.white54,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: index != currentIndex ? Colors.white54 : Colors.white),
      ),
    );
  }
}
