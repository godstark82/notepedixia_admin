// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/const.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:notepedixia_admin/func/items_fun.dart';
import 'package:notepedixia_admin/responsive.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';

class EditItemsToAppScreen extends StatefulWidget {
  const EditItemsToAppScreen(
      {super.key,
      required this.category,
      required this.idx,
      required this.longInfo,
      required this.price,
      required this.shortInfo,
      required this.title});
  final String title;
  final String shortInfo;
  final String longInfo;
  final String price;
  final String idx;
  final String category;

  @override
  State<EditItemsToAppScreen> createState() => _EditItemsToAppScreenState();
}

class _EditItemsToAppScreenState extends State<EditItemsToAppScreen> {
  String title = '';
  String shortInfo = '';
  String longInfo = '';
  String price = '';
  String dropDownValue = '';

  List<DropdownMenuItem> createCategories() {
    return List.generate(
        category.length,
        (index) => DropdownMenuItem(
              value: category[index].toString(),
              child: Text(category[index].toString()),
            ));
  }

  @override
  void initState() {
    title = widget.title;
    price = widget.price;
    shortInfo = widget.shortInfo;
    longInfo = widget.longInfo;
    dropDownValue = widget.category;
    super.initState();
    createCategories();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Add Item'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () async {
                await ItemsClassForGoDown.editItem(widget.idx.toString(),
                    title: title,
                    price: price,
                    shortInfo: shortInfo,
                    longInfo: longInfo,
                    category: dropDownValue);

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainScreen()));
              },
              icon: const Icon(Icons.add),
              label: const Text("Add item to Godown"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.all(defaultPadding + 6).copyWith(left: width * 0.25),
          padding: const EdgeInsets.all(6),
          width: width * 0.5,
          decoration: const BoxDecoration(color: secondaryColor),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addList(
                  'Name',
                  SizedBox(
                    width: width * 0.7,
                    child: TextFormField(
                      initialValue: title,
                      onChanged: (value) {
                        title = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Item Name')),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                addList(
                  'Price',
                  SizedBox(
                    width: width * 0.25,
                    child: TextFormField(
                      initialValue: price,
                      onChanged: (value) {
                        price = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Price in Rs')),
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
                addList(
                    'Category',
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: DropdownButton(
                        style: const TextStyle(color: Colors.black),
                        iconEnabledColor: Colors.black,
                        dropdownColor: Colors.white,
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        underline: const Divider(
                          color: Colors.transparent,
                        ),
                        value: widget.category,
                        items: createCategories(),
                        onChanged: (value) {
                          dropDownValue = value;
                          setState(() {});
                        },
                      ),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'Shortinfo',
                    TextFormField(
                      initialValue: shortInfo,
                      onChanged: (value) {
                        shortInfo = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Short Description')),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'Long Info',
                    TextFormField(
                      initialValue: longInfo,
                      onChanged: (value) {
                        longInfo = value;
                      },
                      maxLines: 6,
                      dragStartBehavior: DragStartBehavior.down,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Long Description')),
                    )),
                const SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addList(String data, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            child: Text(data, style: const TextStyle(color: Colors.white54))),
        const SizedBox(width: defaultPadding),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.40, child: widget),
      ],
    );
  }
}
