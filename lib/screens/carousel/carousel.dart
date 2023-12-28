// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/models/itemforsell_model.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/screens/carousel/components/widgets.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';
import 'package:velocity_x/velocity_x.dart';

class CarouselScreen extends StatefulWidget {
  const CarouselScreen({super.key});

  @override
  State<CarouselScreen> createState() => _CarouselScreenState();
}

class _CarouselScreenState extends State<CarouselScreen> {
  String dropDownValue = '';
  List<String> imagesLinks = [];
  Future<List<DropdownMenuItem>> allOrders() async {
    final item = shopItems.value.isEmpty
        ? <DropdownMenuItem>[
            const DropdownMenuItem(
              value: 'd',
              child: Text('No Data Found'),
            )
          ]
        : List.generate(
            shopItems.value.length,
            (index) => DropdownMenuItem(
                  value: shopItems.value[index].id.toString(),
                  child: Text(shopItems.value[index].title.toString()),
                ));
    return item;
  }

  // initState
  @override
  void initState() {
    super.initState();
    // allOrders();
  }

  // dispose
  @override
  void dispose() {
    super.dispose();
    imagesLinks = [];
  }

  @override
  Widget build(BuildContext context) {
    // allOrders();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(children: [
            Header(
                title: "Carousel Items",
                widget: ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () async {
                    await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        constraints: const BoxConstraints.expand(),
                        builder: (context) => addCarouselItem());
                    setState(() {});
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add New"),
                )),
            carouselItems()
          ]),
        ),
      ),
    );
  }

  Widget carouselItems() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      margin: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ValueListenableBuilder(
        valueListenable: localData,
        builder: (_, value, child) {
          final data = value['carousel'];
          return ListView.builder(
            itemBuilder: (context, idx) {
              return ExpansionTile(
                subtitle: const Text(
                  'click to expand',
                  style: TextStyle(color: Colors.grey),
                ),
                initiallyExpanded: false,
                onExpansionChanged: (isExpanded) {
                  setState(() {});
                },
                title: Text('${data?[idx]['title']}'),
                leading: Text('${idx + 1}'),
                trailing: SizedBox(
                  width: Responsive.isDesktop(context) ? 175 : 125,
                  child: Row(
                    children: [
                      MaterialButton(
                          onPressed: () async {
                            await ItemsClass.deleteCarouselItem(
                                data?[idx]['id']);
                            setState(() {});
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ],
                  ),
                ),
                children: [
                  Image.network(
                    data?[idx]['img'],
                    height: context.screenHeight * 0.5,
                    width: context.screenWidth * 0.5,
                  )
                ],
              );
            },
            itemCount: data?.length,
            shrinkWrap: true,
            primary: false,
          );
        },
      ),
    );
  }

  Widget addCarouselItem() {
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
                if (dropDownValue.isNotEmptyAndNotNull &&
                    imagesLinks.isNotEmpty) {
                  Loader.show(context);
                  //
                  // function to add this item in the carousel
                  // will be here
                  final index = shopItems.value
                      .indexWhere((element) => dropDownValue == element.id);
                  final item = shopItems.value[index];
                  ItemsClass.createCarouselItems(
                      ItemForSaleModel(
                          tags: item.tags,
                          time: item.time,
                          bgColor: item.bgColor,
                          title: item.title,
                          description: item.description,
                          pages: item.pages,
                          condition: item.condition,
                          cover: item.cover,
                          language: item.language,
                          price: item.price,
                          id: dropDownValue,
                          category: item.category,
                          images: item.images),
                      dropDownValue,
                      imagesLinks[0]);

                  Navigator.pop(context);
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
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
      body: shopItems.value.isEmpty
          ? const Center(child: Text('Add Items in Shop First'))
          : StatefulBuilder(builder: (context, ststate) {
              return Container(
                margin: Responsive.isDesktop(context)
                    ? const EdgeInsets.all(defaultPadding + 6)
                        .copyWith(left: width * 0.25)
                    : const EdgeInsets.all(0),
                padding: const EdgeInsets.all(16),
                width: width * 0.5,
                decoration: const BoxDecoration(color: secondaryColor),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: defaultPadding),
                      FutureBuilder(
                          future: allOrders(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return addList(
                                  context,
                                  'Product',
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.white),
                                    child: DropdownButton(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      iconEnabledColor: Colors.black,
                                      dropdownColor: Colors.white,
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      underline: const Divider(
                                        color: Colors.transparent,
                                      ),
                                      value: dropDownValue != ''
                                          ? dropDownValue
                                          // : allOrders().first.value,
                                          : snapshot.data?.first.value,
                                      items: snapshot.data,
                                      onChanged: (value) {
                                        dropDownValue = value;
                                        ststate(() {});
                                      },
                                    ),
                                  ));
                            } else if (snapshot.hasError) {
                              return const Center(
                                  child: Text('Some Error Occur'));
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                      const SizedBox(height: defaultPadding),
                      addList(
                          context,
                          'Images',
                          Row(children: [
                            const Expanded(child: SizedBox()),
                            if (imagesLinks.isEmpty)
                              TextButton(
                                  onPressed: () async {
                                    Loader.show(context);
                                    imagesLinks
                                        .add(await ItemsClass.uploadImage());
                                    ststate(() {});
                                    Loader.hide();
                                  },
                                  child: "Add Image".text.make())
                          ])),
                      if (imagesLinks.isNotEmpty) imageTile()
                    ],
                  ),
                ),
              );
            }),
    );
  }

  Widget imageTile() {
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
            imagesLinks[0],
            errorBuilder: (context, error, stackTrace) {
              return "Error Occur".text.makeCentered();
            },
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextButton.icon(
                onPressed: () {
                  imagesLinks.removeAt(0);
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
