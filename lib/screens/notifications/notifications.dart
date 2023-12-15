// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';
import 'package:velocity_x/velocity_x.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                  title: 'Notifications',
                  widget: notifications.isEmpty
                      ? SizedBox()
                      : IconButton(
                          onPressed: () async {
                            notifications = [];
                            await FirebaseFirestore.instance
                                .collection('admin')
                                .doc('notifications')
                                .update({'notifications': notifications});

                            setState(() {});
                          },
                          icon: Icon(Icons.clear_all, color: Colors.red),
                        )),
              goDownItems()
            ],
          ),
        ),
      ),
    );
  }

  Widget goDownItems() {
    return notifications.isEmpty
        ? SizedBox(
            height: context.screenHeight * 0.5,
            child: Center(
              child: Text('No New Notifications'),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(defaultPadding),
            margin: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, idx) {
                return ListTile(
                  leading: Text('${idx + 1}'),
                  title: Text('${notifications[idx]['title']}'),
                );
              },
              itemCount: notifications.length,
            ));
  }
}
