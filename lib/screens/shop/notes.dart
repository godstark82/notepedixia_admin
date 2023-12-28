// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/const/helper/empty_screen.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';
import 'package:notepedixia_admin/screens/shop/components/add_item.dart';
import 'package:notepedixia_admin/screens/shop/components/edit_items.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(children: [
            Header(
                title: "Notes",
                widget: ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical: defaultPadding /
                          (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddItemsToAppScreen(
                                  isNotes: true,
                                )));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add New"),
                )),
            goDownItems()
          ]),
        ),
      ),
    );
  }

  Widget goDownItems() {
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
          final item = notesItems.value;

          return value.isEmpty
              ? const EmptyScreen()
              : ListView.separated(
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemBuilder: (context, idx) {
                    return ListTile(
                      title: Text(item[idx].title.toString()),
                      leading: Text('${idx + 1}'),
                      trailing: SizedBox(
                        width: Responsive.isDesktop(context) ? 175 : 125,
                        child: Row(
                          children: [
                            MaterialButton(
                                onPressed: () async {
                                  await ItemsClass.deleteItem(idx, true);
                                  setState(() {});
                                },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            MaterialButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditItemsToAppScreen(
                                                isNotes: true,
                                                tags: value[idx].tags,
                                                idx: value[idx].id!,
                                                imageLinks: value[idx].images,
                                                price: value[idx].price!,
                                                title: value[idx].title!,
                                                description:
                                                    value[idx].description!,
                                                condition:
                                                    value[idx].condition!,
                                                cover: value[idx].cover!,
                                                language: value[idx].language!,
                                                pages: value[idx].pages!,
                                                category: categoryName[idx],
                                              )));
                                },
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: item.length,
                  shrinkWrap: true,
                  primary: false,
                );
        },
      ),
    );
  }
}
