// ignore_for_file: avoid_print, unused_local_variable

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notepedixia_admin/const/const.dart';
import 'package:notepedixia_admin/models/itemforsell_model.dart';


class ItemsClassForGoDown {
  static final firestore = FirebaseFirestore.instance;

  //update counter first
  static updateCounter() async {
    final itemdoc = await firestore.collection('admin').doc('counter').get();
    final itemdocMap = itemdoc.data() ?? {};
    final orderId = itemdocMap['counter'];
    counter = orderId.toString();
  }

  // this function create order for app database with a specific orderID
  static Future<void> createItem(
    List<String>? imageLinks, {
    String? ordertitle,
    String? price,
    String? category,
    String? shortInfo,
    String? longInfo,
  }) async {
    final itemdoc = await firestore.collection('admin').doc('counter').get();
    final itemdocMap = itemdoc.data() ?? {};
    final orderId = itemdocMap['counter'];
    await firestore.collection('items').doc('$orderId').set({
      'title': ordertitle,
      'price': price,
      'images': imageLinks,
      'category': category,
      'longInfo': longInfo,
      'shortInfo': shortInfo,
      'id': orderId.toString()
    }).then((value) async {
      await firestore
          .collection('admin')
          .doc('counter')
          .update({'counter': orderId + 1});
    });
    await getItems();
  }

  static Future<void> editItem(String id,
      {String? price,
      String? category,
      String? longInfo,
      String? shortInfo,
      String? title}) async {
    final itemdoc = await firestore.collection('items').doc(id).update({
      'title': title,
      'price': price,
      'category': category,
      'longInfo': longInfo,
      'shortInfo': shortInfo,
      'id': id
    });
    await getItems();
  }

  static Future getItems() async {
    items.value.clear();
    final data = await firestore.collection('items').get();
    final documents = data.docs;
    final List<ItemForSaleModel> listmodel = [];
    for (int i = 0; i < documents.length; i++) {
      final item = documents[i].data();
      final model = ItemForSaleModel(
          title: item['title'],
          id: item['id'],
          shortInfo: item['shortInfo'],
          longInfo: item['longInfo'],
          price: item['price'],
          category: item['category']);

      listmodel.add(model);
    }
    listmodel.sort(
      (a, b) => int.parse(b.id!).compareTo(int.parse(a.id!)),
    );
    items.value.addAll(listmodel);
    print('Total Items: ${items.value.length}');
  }

  static Future<void> deleteItem(int index) async {
    String id = items.value[index].id!;
    print(id);
    items.value.removeAt(index);
    firestore.collection('items').doc(id).delete();
  }

  // CATEGORY SECTION
  //
  // get categories from Firestore
  //

  static Future getCategories() async {
    var cat = await firestore.collection('admin').doc('category').get();
    var mappedCategory = cat.data();
    category =
        (mappedCategory?['category'] as List).map((e) => e as String).toList();
  }

  // create a new Category
  static Future createCategory(String newCategory) async {
    category.add(newCategory);
    await firestore.collection('admin').doc('category').update({
      'category': category,
    });
  }

  //
  static Future deleteCategory(int index) async {
    category.removeAt(index);
    await firestore
        .collection('admin')
        .doc('category')
        .update({'category': category});
  }

  //
  //
  // IMage UPLOADING TO FIREBASE STORAGE
  static Future<void> uploadImage(String id, Uint8List data) async {}
}
