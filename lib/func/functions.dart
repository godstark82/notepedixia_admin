///
///  Two Classes in this file 1.[ItemsClass], and [OrdersClass] :
///
///  1. [ItemsClass] has following functions -
///     - [ItemsClass.init] : To initialize the init function for this class these are - [getItems] and [getCategories]
///     - [ItemsClass.updateCounter] : This function will create a unique id for every order and increase it by 1 when order added.
///     - [ItemsClass.createItem] : This will add given order and upload to firebase
///     - [ItemsClass.editItem] : This fn will update the order details in firebase
///     - [ItemsClass.getItems] : This function will get the firestore items in [items] variable, should be used in init.
///     - [ItemsClass.deleteItem] : For deleting item from local as well as Firebase.
///     - [ItemsClass.createCategory] : For creating category on firebase and local.
///     - [ItemsClass.getCategories] : For Fetching categories and storing in local variable, should be used in init.
///     - [ItemsClass.deleteCategory] : For deleting cateogry with index
///
///
///  2. [OrdersClass] has following functions -
///     - [OrdersClass.init] : Main Init Functions to use all init functions inside it.
///     - [OrdersClass.getPendingOrders] : This fetch any new Order from User, [init] function.
///     - [OrdersClass.getNotifications] : To Fetch Notification when a new Order is there, [init] function.
///
///
////.
library;
// ignore_for_file: avoid_print, unused_local_variable

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/models/itemforsell_model.dart';

// ItemsClass to fetch items in goDown
class ItemsClass {
  //firestore variable to use in all functions to access firestore instance
  static final firestore = FirebaseFirestore.instance;

  // initializing all init functions
  static init() async {
    await getItems();

    await getCategories();
    await getCarouselItems();
    debugPrint('ItemsClass initialized');
  }

  // to update counter after adding a new Item in Garage
  static updateCounter() async {
    // getting snapshot data from firestore > admin > counter
    final itemdoc = await firestore.collection('admin').doc('counter').get();
    // converting snapshot into Map
    final itemdocMap = itemdoc.data() ?? {};
    // getting current Counter
    final orderId = itemdocMap['counter'];
// sending counter value to [counter] variable
    counter = orderId.toString();
  }

  // this function create order for app database with a specific orderID
  static Future<void> createItem(
    List? imageLinks, {
    String? ordertitle,
    String? price,
    String? category,
    String? shortInfo,
    String? longInfo,
  }) async {
    // getting current Items as Snapshot
    final itemdoc = await firestore.collection('admin').doc('counter').get();
    // changing to Map
    final itemdocMap = itemdoc.data() ?? {};
    // getting orderID
    final orderId = itemdocMap['counter'];
    // creating a new document in [Items] collection with there details in firestore
    await firestore.collection('items').doc('$orderId').set({
      'title': ordertitle,
      'price': price,
      'images': imageLinks,
      'category': category,
      'longInfo': longInfo,
      'shortInfo': shortInfo,
      'id': orderId.toString()
    }).then((value) async {
      // updating counter when item added
      await firestore
          .collection('admin')
          .doc('counter')
          .update({'counter': orderId + 1});
    });
    // fetch data and save to local variable when adding the new one
    await getItems();
  }

  // fn for editing the item
  static Future<void> editItem(String id,
      {String? price,
      String? category,
      String? longInfo,
      String? shortInfo,
      String? title}) async {
    await firestore.collection('items').doc(id).update({
      'title': title,
      'price': price,
      'category': category,
      'longInfo': longInfo,
      'shortInfo': shortInfo,
      'id': id
    });
    await getItems();
  }

  // fn for fetching carouselItems from Firebase
  static Future<void> getCarouselItems() async {
    final data = await firestore
        .collection('admin')
        .doc('carousel')
        .collection('carousel-items')
        .get();
    localData.value['carousel'] = [];
    for (int i = 0; i < data.docs.length; i++) {
      localData.value['carousel']?.add({
        'id': data.docs[i].data()['id'],
        'img': data.docs[i].data()['img'],
        'title': data.docs[i].data()['title'],
        'price': data.docs[i].data()['price']
      });
    }
  }

  static Future<void> createCarouselItems(
      ItemForSaleModel item, String id, String image) async {
    final data = await firestore
        .collection('admin')
        .doc('carousel')
        .collection('carousel-items')
        .add({
      'id': id,
      'title': item.title,
      'shortInfo': item.shortInfo,
      'category': item.category,
      'longInfo': item.longInfo,
      'price': item.price,
      'images': item.imageLinks,
      'img': image,
    });
    await getCarouselItems();
    print('Carousel Created');
  }

  static Future<void> deleteCarouselItem(String id) async {
    final data = await firestore
        .collection('admin')
        .doc('carousel')
        .collection('carousel-items')
        .get();
    int? index;
    final docs = data.docs;
    for (int i = 0; i < docs.length; i++) {
      final doc = docs[i].data();
      if (doc['id'] == id) {
        index = i;
        break;
      }
    }
    final doc = docs[index!].id;
    await firestore
        .collection('admin')
        .doc('carousel')
        .collection('carousel-items')
        .doc(doc)
        .delete();
    await getCarouselItems();
    print('Doc Deleted');
  }

  // fn for fetching data from firebase
  static Future getItems() async {
    items.value.clear();
    final data = await firestore.collection('items').get();
    final documents = data.docs;
    final List<ItemForSaleModel> listmodel = [];
    for (int i = 0; i < documents.length; i++) {
      final item = documents[i].data();
      final model = ItemForSaleModel(
          imageLinks: item['images'],
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
  }

  static Future<void> deleteItem(int index) async {
    String id = items.value[index].id!;
    items.value.removeAt(index);
    firestore.collection('items').doc(id).delete();
  }

  // CATEGORY SECTION
  //
  // get categories from Firestore
  //

  static Future<String> uploadImage() async {
    // Method to pick image in flutter web

    String uniqueName = DateTime.now().toString();
    // Pick image using image_picker package
    Uint8List? file = await ImagePickerWeb.getImageAsBytes();

    //
    final refRoot = FirebaseStorage.instance.ref().child('images');
    final ref = refRoot.child(uniqueName);
    final metadata = SettableMetadata(contentType: 'image/jpeg');
    await ref.putData(file!, metadata);
    final dlLink = await ref.getDownloadURL();
    return dlLink;
  }

  static Future getCategories() async {
    var cat = await firestore.collection('admin').doc('category').get();
    var mappedCategory = cat.data();
    categoryName =
        (mappedCategory?['category'] as List).map((e) => e as String).toList();
            categoryImg =
        (mappedCategory?['category-img'] as List).map((e) => e as String).toList();
  }

  // create a new Category
  static Future createCategory(String newCategory, String catImg) async {
    categoryName.add(newCategory);
    categoryImg.add(catImg);
    await firestore.collection('admin').doc('category').update({
      'category': categoryName,
      'category-img': categoryImg,
    });
  }

  //
  static Future deleteCategory(int index) async {
    categoryName.removeAt(index);
    categoryImg.removeAt(index);
    await firestore.collection('admin').doc('category').update({
      'category': categoryName,
      'category-img': categoryImg,
    });
  }
}

class OrdersClass {
  static final admin = FirebaseFirestore.instance.collection('admin');

  static Future<void> init() async {
    await getCompletedOrders();
    await getPendingOrders();
    await getRejectedOrders();
    await getNotifications();
    debugPrint('Orders and Notifications initialize');
  }

  static Future<void> getPendingOrders() async {
    final data = await admin.doc('pending-orders').get();
    final mapped = data.data() ?? {};

    // orders variables
    final cloudOrders = mapped['pending-orders'] ?? [];
    localData.value['pending-orders'] = [];
    final localOrders = localData.value['pending-orders'] ?? [];

    //loop to get data
    for (int i = 0; i < cloudOrders.length; i++) {
      localOrders.add({
        'id': cloudOrders[i]['id'],
        'uid': cloudOrders[i]['uid'],
        'title': cloudOrders[i]['title'],
        'shortInfo': cloudOrders[i]['shortInfo'],
        'longInfo': cloudOrders[i]['longInfo'],
        'quantity': cloudOrders[i]['quantity'],
        'images': cloudOrders[i]['images'],
        'status': cloudOrders[i]['status'],
        'trackingID': cloudOrders[i]['trackingID']
      });
    }
  }

  static Future<void> getCompletedOrders() async {
    final data = await admin.doc('completed-orders').get();
    final mapped = data.data() ?? {};

    // orders variables
    final cloudOrders = mapped['completed-orders'] ?? [];
    localData.value['completed-orders'] = [];
    final localOrders = localData.value['completed-orders'] ?? [];

    //loop to get data
    for (int i = 0; i < cloudOrders.length; i++) {
      localOrders.add({
        'id': cloudOrders[i]['id'],
        'uid': cloudOrders[i]['uid'],
        'title': cloudOrders[i]['title'],
        'shortInfo': cloudOrders[i]['shortInfo'],
        'longInfo': cloudOrders[i]['longInfo'],
        'quantity': cloudOrders[i]['quantity'],
        'images': cloudOrders[i]['images'],
        'status': cloudOrders[i]['status'],
        'trackingID': cloudOrders[i]['trackingID']
      });
    }
  }

  static Future<void> getRejectedOrders() async {
    final data = await admin.doc('rejected-orders').get();
    final mapped = data.data() ?? {};

    // orders variables
    final cloudOrders = mapped['rejected-orders'] ?? [];
    localData.value['rejected-orders'] = [];
    final localOrders = localData.value['rejected-orders'] ?? [];

    //loop to get data
    for (int i = 0; i < cloudOrders.length; i++) {
      localOrders.add({
        'id': cloudOrders[i]['id'],
        'uid': cloudOrders[i]['uid'],
        'title': cloudOrders[i]['title'],
        'shortInfo': cloudOrders[i]['shortInfo'],
        'longInfo': cloudOrders[i]['longInfo'],
        'quantity': cloudOrders[i]['quantity'],
        'images': cloudOrders[i]['images'],
        'status': cloudOrders[i]['status'],
        'trackingID': cloudOrders[i]['trackingID']
      });
    }
  }

  static Future<void> getNotifications() async {
    final data = await admin.doc('notifications').get();
    final map = (data.data() ?? {})['notifications'];

    for (int i = 0; i < map.length; i++) {
      notifications.add({
        'title': map[i]['title'],
        'msg': map[i]['msg'],
      });
    }
  }

  static Future<void> updateOrder(
      {String? uid, String? orderID, String? newStatus}) async {
    // fetching currentOrders
    final userOrderSnap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userOrdersMap = userOrderSnap.data() ?? {};
    List<Map> orders = userOrdersMap['orders'];
    final index = orders.indexWhere((element) => element['id'] == orderID);
    orders[index]['status'] = newStatus.toString().toUpperCase();

    print(orders);

    // after fetching and updating list of specific user upload it back to firestore
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(uid).update({});
  }
}
