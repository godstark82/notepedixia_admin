// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class EditItemsToAppScreen extends StatefulWidget {
  const EditItemsToAppScreen(
      {super.key,
      required this.category,
      required this.idx,
      required this.description,
      required this.price,
      required this.condition,
      required this.cover,
      required this.pages,
      required this.language,
      required this.imageLinks,
      required this.tags,
      required this.isNotes,
      required this.title});
  final String title;
  final String description;
  final String cover;
  final String pages;
  final String language;
  final String condition;
  final List tags;
  final String price;
  final String idx;
  final String category;
  final List imageLinks;
  final bool isNotes;

  @override
  State<EditItemsToAppScreen> createState() => _EditItemsToAppScreenState();
}

class _EditItemsToAppScreenState extends State<EditItemsToAppScreen> {
  String title = '';
  String description = '';
  String cover = '';
  String pages = '';
  String condition = '';
  String language = '';
  String price = '';
  String dropDownValue = '';
  List imageLink = [];
  String currentTag = '';
  List selectedTags = [];
  List<DropdownMenuItem>? categories;
  List<DropdownMenuItem>? tags;
  String pdfFile = '';
  String notesUrl = '';

  @override
  void initState() {
    title = widget.title;
    price = widget.price;
    condition = widget.condition;
    cover = widget.cover;
    description = widget.description;
    pages = widget.pages;
    language = widget.language;
    selectedTags = widget.tags;
    dropDownValue = widget.category;
    imageLink = widget.imageLinks;
    super.initState();
    categories = List.generate(
        categoryName.length,
        (index) => DropdownMenuItem(
              value: categoryName[index].toString(),
              child: Text(categoryName[index].toString()),
            ));
    tags = List.generate(
        widget.isNotes == true
            ? (localData.value['notes-filters'] as List).length
            : (localData.value['all-filters'] as List).length,
        (index) => DropdownMenuItem(
              value: widget.isNotes == true
                  ? (localData.value['notes-filters'] as List)[index].toString()
                  : (localData.value['all-filters'] as List)[index].toString(),
              child: Text(widget.isNotes == true
                  ? (localData.value['notes-filters'] as List)[index]
                  : (localData.value['all-filters'] as List)[index]),
            ));
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
                    description.isNotEmptyAndNotNull) {
                  Loader.show(context,
                      overlayColor: Colors.white.withOpacity(0.1));
                  await ItemsClass.editItem(widget.idx.toString(),
                      title: title,
                      tags: tags,
                      price: price,
                      condition: condition,
                      cover: cover,
                      description: description,
                      language: language,
                      pages: pages,
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
                        items: categories,
                        onChanged: (value) {
                          dropDownValue = value;
                          setState(() {});
                        },
                      ),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'description',
                    TextField(
                      onChanged: (value) {
                        description = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Short Description')),
                    )),
                addList(
                    'Pages',
                    TextField(
                      onChanged: (value) {
                        pages = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Short Description')),
                    )),
                addList(
                    'Condition',
                    TextField(
                      onChanged: (value) {
                        condition = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Short Description')),
                    )),
                addList(
                    'language',
                    TextField(
                      onChanged: (value) {
                        language = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Short Description')),
                    )),
                addList(
                    'Cover',
                    TextField(
                      onChanged: (value) {
                        cover = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Short Description')),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'Tags',
                    Row(
                      children: [
                        Expanded(
                          child: Container(
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
                              value: currentTag != ''
                                  ? currentTag
                                  : tags?.first.value,
                              items: tags,
                              onChanged: (value) {
                                currentTag = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              if (selectedTags.contains(currentTag) == false) {
                                selectedTags.add(currentTag);
                                setState(() {});
                              } else {
                                Get.snackbar('Error', 'Duplicate Item');
                              }
                            },
                            child: const Text('Add Tag'))
                      ],
                    )),
                if (widget.isNotes)
                  ExpansionTile(
                    title: const Text('PDF FILE'),
                    subtitle: const Text('Click to View PDF Link'),
                    trailing: IconButton(
                        onPressed: () async {
                          final dlLink = await ItemsClass.pickPdf(title);
                          pdfFile = dlLink;
                          Get.snackbar('UPLOADED', 'PDF SUCCESSFULLY UPLOADED');
                          setState(() {});
                        },
                        icon: const Icon(Icons.upload)),
                    children: [
                      ListTile(
                        isThreeLine: true,
                        leading: const Text('Name'),
                        title: Text(title),
                        subtitle: Text(pdfFile),
                      ),
                    ],
                  ),
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
