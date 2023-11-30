// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String oldPass = '';
    String newPass = '';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.password),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Change Password'),
                          content: SizedBox(
                            height: context.screenHeight * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    label: Text('Old Password'),
                                  ),
                                  onChanged: (value) {
                                    oldPass = value;
                                  },
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    label: Text('New Password'),
                                  ),
                                  onChanged: (value) {
                                    newPass = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  final account = FirebaseFirestore.instance
                                      .collection('admin')
                                      .doc('account');
                                  final get = await account.get();
                                  final mappedAccount = get.data() ?? {};
                                  final String cloudPass = mappedAccount['pass'];
                                  if (cloudPass == oldPass) {
                                    //
                                    account.update({'pass': newPass});
                                    Navigator.pop(context);
                                    context.showToast(msg: 'Password Changed');
                                  } else {
                                    context.showToast(msg: 'Wrong Old Password');
                                  }
                                },
                                child: const Text('Confirm Change'))
                          ],
                        ));
              },
            )
          ],
        ),
      ),
    );
  }
}
