// ignore_for_file: unused_local_variable, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String cloudId = '';
  String cloudPass = '';

  //
  Future<void> getIdPassword() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final account = await firestore.collection('admin').doc('account').get();
    final mappedAccount = account.data() ?? {};
    cloudId = mappedAccount['id'];
    cloudPass = mappedAccount['pass'];
  }

  Future login() async {
    await getIdPassword();

    if (emailController.text == cloudId && passController.text == cloudPass) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
      Hive.box('cache').put('login', true);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Some Error Occur')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isWeb = width > 700 ? true : false;
    return Container(
      decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.red, Colors.blue, Colors.pink])),
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.4),
        body: Center(
          child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 12),
                BoxShadow(color: Colors.grey, blurRadius: 12),
              ]),
              height: isWeb ? 450 : height * 0.5,
              width: isWeb ? 450 : width * 0.75,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Login',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    // SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusColor: Colors.teal,
                          fillColor: Colors.black,
                          // icon: Icon(Icons.email_rounded),
                          label: Row(
                            children: [
                              Icon(
                                Icons.email,
                                color: Colors.teal,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text('Email').text.black.make(),
                            ],
                          )),
                    ),
                    // SizedBox(height: 20),
                    TextField(
                      controller: passController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          focusColor: Colors.teal,
                          // icon: Icon(Icons.email_rounded),
                          label: Row(
                            children: [
                              Icon(
                                Icons.password_outlined,
                                color: Colors.teal,
                                size: 24,
                              ),
                              SizedBox(width: 10),
                              Text('Password').text.black.make(),
                            ],
                          )),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await login();
                      },
                      child: Container(
                        margin: EdgeInsets.all(2),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        color: Colors.teal,
                        child: Text('Login'),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
