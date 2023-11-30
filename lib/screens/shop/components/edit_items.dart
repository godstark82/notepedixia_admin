// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/responsive.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class EditItemsToAppScreen extends StatefulWidget {
  const EditItemsToAppScreen(
      {super.key,
      required this.category,
      required this.idx,
      required this.longInfo,
      required this.price,
      required this.shortInfo,
      required this.imageLinks,
      required this.title});
  final String title;
  final String shortInfo;
  final String longInfo;
  final String price;
  final String idx;
  final String category;
  final List imageLinks;

  @override
  State<EditItemsToAppScreen> createState() => _EditItemsToAppScreenState();
}

class _EditItemsToAppScreenState extends State<EditItemsToAppScreen> {
  String title = '';
  String shortInfo = '';
  String longInfo = '';
  String price = '';
  String dropDownValue = '';
  List imageLink = [];

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
    imageLink = widget.imageLinks;
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
                if (title.isNotEmptyAndNotNull &&
                    price.isNotEmptyAndNotNull &&
                    imageLink.isNotEmpty &&
                    longInfo.isNotEmptyAndNotNull &&
                    shortInfo.isNotEmptyAndNotNull) {
                  Loader.show(context,
                      overlayColor: Colors.white.withOpacity(0.1));
                  await ItemsClass.editItem(widget.idx.toString(),
                      title: title,
                      price: price,
                      shortInfo: shortInfo,
                      longInfo: longInfo,
                      category: dropDownValue);
                  Loader.hide();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Can not Add'),
                            content: const Text('Kindly Fill all the values'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Ok'))
                            ],
                          ));
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Update Item"),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(defaultPadding + 6)
              .copyWith(left: width * 0.25),
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
                addList(
                    'Images',
                    Row(children: [
                      const Expanded(child: SizedBox()),
                      TextButton(
                          onPressed: () async {
                            await pickImage();
                            setState(() {});
                          },
                          child: "Add Image".text.make())
                    ])),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: imageLink.length,
                    itemBuilder: (context, index) {
                      return imageTile(index);
                    })
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

  // Method to pick image in flutter web
  Future<void> pickImage() async {
    String uniqueName = DateTime.now().toString();
    print(uniqueName);
    // Pick image using image_picker package
    Uint8List? file = await ImagePickerWeb.getImageAsBytes();

    Future<void> uploadImage() async {
      //
      final refRoot = FirebaseStorage.instance.ref().child('images');
      final ref = refRoot.child(uniqueName);
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(file!, metadata);
      final dlLink = await ref.getDownloadURL();
      imageLink.add(dlLink);
      print(imageLink.first);
    }

    Loader.show(context, overlayColor: Colors.white.withOpacity(0.1));
    await uploadImage();
    print('Image uplaodded');
    Loader.hide();
  }

  Widget imageTile(int index) {
    return Container(
      margin: const EdgeInsets.all(defaultPadding + 8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(12)),
      width: context.screenWidth * 0.45,
      height: context.screenHeight * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            imageLink[index],
            errorBuilder: (context, error, stackTrace) {
              return "Error Occur".text.makeCentered();
            },
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextButton.icon(
                onPressed: () {
                  imageLink.removeAt(index);
                  setState(() {});
                },
                icon: const Icon(
                  Icons.delete,
                  color: Vx.red500,
                ),
                label: "Delete".text.red500.makeCentered()),
          )
        ],
      ),
    );
  }
}
