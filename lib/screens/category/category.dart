// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/const/constants.dart';
import 'package:notepedixia_admin/const/helper/empty_screen.dart';
import 'package:notepedixia_admin/func/functions.dart';
import 'package:notepedixia_admin/const/responsive.dart';
import 'package:notepedixia_admin/screens/dashboard/components/header.dart';
import 'package:velocity_x/velocity_x.dart';

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
                      String categoryName = '';
                      String cateogoryImg = '';
                      bool showImg = false;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder: (context, ststate) {
                              return AlertDialog(
                                title: const Text('Category name'),
                                content: SizedBox(
                                  height: context.screenHeight * 0.3,
                                  child: Column(
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          categoryName = value;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Category Name',
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      FilledButton.icon(
                                          onPressed: () async {
                                            Loader.show(context);
                                            cateogoryImg =
                                                await ItemsClass.uploadImage();
                                            Loader.hide();
                                            showImg = true;
                                            ststate(() {});
                                          },
                                          icon: Icon(Icons.add),
                                          label: Text('Add Image')),
                                      SizedBox(height: 10),
                                      Visibility(
                                        visible: showImg,
                                        child: Image.network(cateogoryImg,
                                            height: context.screenHeight * 0.15,
                                            width: context.screenWidth * 0.15),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () async {
                                        if (categoryName.isNotEmptyAndNotNull &&
                                            cateogoryImg.isNotEmptyAndNotNull) {
                                          await ItemsClass.createCategory(
                                              categoryName, cateogoryImg);
                                          ststate(() {});
                                          Navigator.pop(context);
                                          await Future.delayed(
                                              Duration(seconds: 1));
                                          setState(() {});
                                        }
                                      },
                                      child: const Text('Add'))
                                ],
                              );
                            });
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
          child: categoryName.isEmpty
              ? EmptyScreen()
              : ListView.separated(
                separatorBuilder: (context,index){
                  return Divider();
                },
                  itemBuilder: (context, idx) {
                    return ExpansionTile(
                      leading: Text('${idx + 1}'),
                      subtitle: Text('Click to show Image'),
                      title: Text(categoryName[idx]),
                      trailing:categoryName[idx] == 'Notes' ? SizedBox(): IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text(
                                          'Are you sure you want to delete ${categoryName[idx]}'),
                                      title: const Text('Confirm'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('No')),
                                        TextButton(
                                            onPressed: () async {
                                              await ItemsClass.deleteCategory(
                                                      idx)
                                                  .then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Delete ${categoryName.elementAt(idx)}')));
                                              });
                                              Navigator.pop(context);
                                              Future.delayed(
                                                  Duration(seconds: 1));
                                              setState(() {});
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                      ],
                                    ));
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      children: [
                        Image.network(
                          categoryImg[idx],
                          height: context.screenHeight * 0.3,
                        )
                      ],
                    );
                  },
                  itemCount: categoryName.length,
                  shrinkWrap: true,
                )),
    );
  }
}
