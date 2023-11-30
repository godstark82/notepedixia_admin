import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? username;
  Future<void> getUserName() async {
    var data = await FirebaseFirestore.instance
        .collection('admin')
        .doc('account')
        .get();
    var map = data.data() ?? {};
    username = map['id'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [details('Username', username ?? 'not found')],
        ),
      ),
    );
  }

  Widget details(String title, String data) {
    return Row(
      children: [
        Text(title),
        Container(
          height: 50,
          width: context.screenWidth * 0.5,
          padding: const EdgeInsets.all(8),
          // color: Colors.grey,
          child: Text(data),
        )
      ],
    );
  }
}
