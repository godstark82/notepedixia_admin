// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/screens/main/main_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class AddItemsToAppScreen extends StatefulWidget {
  const AddItemsToAppScreen({super.key});

  @override
  State<AddItemsToAppScreen> createState() => _AddItemsToAppScreenState();
}

class _AddItemsToAppScreenState extends State<AddItemsToAppScreen> {
  String title = '';
  String description = '';
  String pages = '';
  String condition = '';
  String cover = '';
  String language = '';
  String price = '';
  String dropDownValue = '';
  List<String> tags = [];
  List<String> imagesLinks = [];

  List<DropdownMenuItem> createCategories() {
    return List.generate(
        categoryName.length,
        (index) => DropdownMenuItem(
              value: categoryName[index].toString(),
              child: Text(categoryName[index].toString()),
            ));
  }

  @override
  void initState() {
    super.initState();
    createCategories();
  }

  @override
  Widget build(BuildContext context) {
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
                    imagesLinks.isNotEmpty &&
                    description.isNotEmptyAndNotNull &&
                    pages.isNotEmptyAndNotNull &&
                    condition.isNotEmptyAndNotNull &&
                    language.isNotEmptyAndNotNull &&
                    cover.isNotEmptyAndNotNull) {
                  Loader.show(context,
                      overlayColor: Colors.white.withOpacity(0.1));
                  await ItemsClass.createItem(
                    imagesLinks,
                    tags: tags,
                    ordertitle: title,
                    cover: cover,
                    language: language,
                    condition: condition,
                    pages: pages,
                    price: price,
                    description: description,
                    category: dropDownValue != ''
                        ? dropDownValue
                        : createCategories().first.value,
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                  Loader.hide();
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
              label: const Text("Add item to Godown"),
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
                    child: TextField(
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
                    child: TextField(
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
                        value: dropDownValue != ''
                            ? dropDownValue
                            : createCategories().first.value,
                        items: createCategories(),
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
                          label: Text('Description')),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'Pages',
                    TextField(
                      onChanged: (value) {
                        pages = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text('Pages')),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'Condition',
                    TextField(
                      onChanged: (value) {
                        condition = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Condition')),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'language',
                    TextField(
                      onChanged: (value) {
                        language = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('Language')),
                    )),
                const SizedBox(height: defaultPadding),
                addList(
                    'Cover',
                    TextField(
                      onChanged: (value) {
                        cover = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text('Cover')),
                    )),
                if (tags.isNotEmpty) const SizedBox(height: defaultPadding),
                if (tags.isNotEmpty)
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        itemCount: tags.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(
                                label: Text(tags[index]),
                                deleteButtonTooltipMessage: 'Delete',
                                deleteIcon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onDeleted: () {
                                  tags.removeAt(index);
                                  setState(() {});
                                },
                              ),
                            )),
                  ),
                const SizedBox(height: defaultPadding),
                addList(
                  'Tags',
                  Row(children: [
                    Expanded(
                        child: TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text('Tags')),
                      controller: _tagController,
                    )),
                    TextButton(
                        onPressed: () async {
                          tags.add(_tagController.text);
                          _tagController.clear();
                          setState(() {});
                        },
                        child: "Add Tag".text.make())
                  ]),
                ),
                const SizedBox(height: defaultPadding),
                addList(
                    'Images',
                    Row(children: [
                      const Expanded(child: SizedBox()),
                      TextButton(
                          onPressed: () async {
                            Loader.show(context);
                            imagesLinks.add(await ItemsClass.uploadImage());
                            Loader.hide();
                            setState(() {});
                          },
                          child: "Add Image".text.make())
                    ])),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: imagesLinks.length,
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

  final TextEditingController _tagController = TextEditingController();

  Widget addList(String heading, Widget widget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
            child:
                Text(heading, style: const TextStyle(color: Colors.white54))),
        const SizedBox(width: defaultPadding),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.40, child: widget),
      ],
    );
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
            imagesLinks[index],
            errorBuilder: (context, error, stackTrace) {
              return "Error Occur".text.makeCentered();
            },
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextButton.icon(
                onPressed: () {
                  imagesLinks.removeAt(index);
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
