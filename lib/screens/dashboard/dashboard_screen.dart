import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'components/header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(
              title: "Dashboard",
              widget: Text('data'),
            ),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                     
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
               
              ],
            )
          ],
        ),
      ),
    );
  }
}
