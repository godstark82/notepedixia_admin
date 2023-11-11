// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:notepedixia_admin/const/const.dart';
import 'package:notepedixia_admin/constants.dart';
import 'package:notepedixia_admin/func/items_fun.dart';
import 'package:notepedixia_admin/responsive.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(
                  title: 'Categories',
                  widget: ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding * 1.5,
                        vertical: defaultPadding /
                            (Responsive.isMobile(context) ? 2 : 1),
                      ),
                    ),
                    onPressed: () {
                      String categoryString = '';
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Category name'),
                              content: TextField(
                                onChanged: (value) {
                                  categoryString = value;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder()),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () async {
                                      await ItemsClassForGoDown.createCategory(
                                          categoryString);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Add'))
                              ],
                            );
                          });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add New"),
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        const SizedBox(height: defaultPadding),
                        categories(),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget categories() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: SizedBox(
          width: double.infinity,
          child: ListView.builder(
            itemBuilder: (context, idx) {
              return ListTile(
                leading: Text('${idx + 1}'),
                title: Text(category[idx]),
                trailing: IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                    'Are you sure you want to delete ${category[idx]}'),
                                title: const Text('Confirm'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('No')),
                                  TextButton(
                                      onPressed: () async {
                                        await ItemsClassForGoDown
                                                .deleteCategory(idx)
                                            .then((value) {
                                          setState(() {});
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Delete ${category.elementAt(idx)}')));
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      )),
                                ],
                              ));
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              );
            },
            itemCount: category.length,
            shrinkWrap: true,
          )),
    );
  }
}
