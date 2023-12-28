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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:notepedixia_admin/const/database.dart';
import 'package:notepedixia_admin/models/itemforsell_model.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:velocity_x/velocity_x.dart';

// ItemsClass to fetch items in goDown
class ItemsClass {
  //firestore variable to use in all functions to access firestore instance
  static final firestore = FirebaseFirestore.instance;

  // initializing all init functions
  static init() async {
    await getItems();
    await getCategories();
    await getCarouselItems();
    await getFilters();
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
  static Future<void> createItem(List? imageLinks,
      {required String ordertitle,
      required String? price,
      required String? category,
      required String? description,
      required String? pages,
      required List tags,
      String? time,
      required String? pdf,
      required String? condition,
      required String? cover,
      required String? language}) async {
    final pallete = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(imageLinks![0]),
        maximumColorCount: 20);

    final bgColor = pallete.dominantColor?.color.materialColor().toHex();
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
      'description': description,
      'cover': cover,
      'tags': tags,
      'condition': condition,
      'pages': pages,
      'pdf': pdf ?? 'Not Available',
      'time': DateTime.now().toString(),
      'language': language,
      'color': bgColor,
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
      String? pages,
      required List? tags,
      String? condition,
      String? cover,
      String? language,
      String? description,
      String? time,
      String? pdf,
      String? title}) async {
    await firestore.collection('items').doc(id).update({
      'title': title,
      'price': price,
      'tags': tags,
      'category': category,
      'description': description,
      'cover': cover,
      'pdf': pdf ?? 'Not Available',
      'language': language,
      'pages': pages,
      'condition': condition,
      'id': id,
      'time': DateTime.now().toString()
    });
    await getItems();
  }

  // fn for getting filters
  static Future<void> getFilters() async {
    localData.value['all-filters'] = [];
    localData.value['notes-filters'] = [];
    final filterDoc = await firestore.collection('admin').doc('filters').get();
    localData.value['all-filters'] = filterDoc.data()?['all-filters'] ?? [];
    localData.value['notes-filters'] = filterDoc.data()?['notes-filters'] ?? [];
  }

  //delete
  static Future<void> deleteAllFilter(int index, bool isNotes) async {
    if (isNotes) {
      (localData.value['notes-filters'] as List).removeAt(index);
    } else {
      (localData.value['all-filters'] as List).removeAt(index);
    }
    firestore.collection('admin').doc('filters').update({
      'all-filters': localData.value['all-filters'],
      'notes-filters': localData.value['notes-filters'],
    });
  }

  //
  static Future<void> createFilters(
      String filterName, bool isNoteFilter) async {
    final filterDoc = firestore.collection('admin').doc('filters');
    final currentData = await filterDoc.get();
    final mappedData = currentData.data() ?? {};
    List allFilters = mappedData['all-filters'] ?? [];
    List notesFilters = mappedData['notes-filters'] ?? [];
    if (isNoteFilter) {
      // await filterDoc
      notesFilters.add(filterName);
    } else {
      allFilters.add(filterName);
      // await filterDoc.collection('all-filters').add({'filter': filterName});
    }
    await filterDoc.update({
      'all-filters': allFilters,
      'notes-filters': notesFilters,
    });
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
        'price': data.docs[i].data()['price'],
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
      'description': item.description,
      'category': item.category,
      'cover': item.cover,
      'pages': item.pages,
      'language': item.language,
      'condition': item.condition,
      'price': item.price,
      'images': item.images,
      'time': item.time,
      'img': image,
      'color': item.bgColor.toHex(),
    });
    await getCarouselItems();
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
  }

  // fn for getting all Notes from Firestire

  // fn for fetching data from firebase
  static Future getItems() async {
    shopItems.value.clear();
    notesItems.value.clear();
    final data = await firestore.collection('items').get();
    final documents = data.docs;
    final List<ItemForSaleModel> listmodel = [];
    for (int i = 0; i < documents.length; i++) {
      final item = documents[i].data();
      final model = ItemForSaleModel(
          tags: item['tags'] ?? [],
          time: item['time'],
          bgColor: HexColor(item['color']),
          cover: item['cover'],
          description: item['description'],
          language: item['language'],
          pages: item['pages'],
          images: item['images'],
          title: item['title'],
          id: item['id'],
          condition: item['condition'],
          price: item['price'],
          category: item['category']);

      listmodel.add(model);
    }
    listmodel.sort(
      (a, b) => int.parse(b.id!).compareTo(int.parse(a.id!)),
    );
    shopItems.value
        .addAll(listmodel.where((element) => element.category != 'Notes'));
    notesItems.value
        .addAll(listmodel.where((element) => element.category == 'Notes'));
  }

  static Future<void> deleteItem(int index, bool isNotes) async {
    String id = '';
    if (isNotes) {
      String uid = notesItems.value[index].id!;
      id = uid;
      notesItems.value.removeAt(index);
    } else {
      String uid = shopItems.value[index].id!;
      id = uid;
      shopItems.value.removeAt(index);
    }
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

  // Method to upload pdf to Firebase
  static Future<String> uploadPdf(String fileName, Uint8List file) async {
    final ref = FirebaseStorage.instance.ref().child('pdfs/$fileName.pdf');

    final uploadTask = ref.putData(file);

    await uploadTask.whenComplete(() {});

    final dlLink = await ref.getDownloadURL();

    return dlLink;
  }

  static Future<String> pickPdf(String order) async {
    String link = '';
    final pickedFiles = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (pickedFiles != null) {
      String fileName = DateTime.now().toString();
      Uint8List file = pickedFiles.files.first.bytes!;

      final downloadLink = await uploadPdf(fileName, file);
    } else {
      debugPrint('Picked File is null');
    }
    debugPrint('Pdf Uploaded Successfully');
    return link;
  }

  static Future getCategories() async {
    var cat = await firestore.collection('admin').doc('category').get();
    var mappedCategory = cat.data();
    categoryName =
        (mappedCategory?['category'] as List).map((e) => e as String).toList();
    categoryImg = (mappedCategory?['category-img'] as List)
        .map((e) => e as String)
        .toList();
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
    final data = await admin.doc('pending-orders').collection('orders').get();

    // orders variables

    localData.value['pending-orders'] = [];
    List localOrders = localData.value['pending-orders'];

    //loop to get data
    for (int i = 0; i < data.docs.length; i++) {
      final cloudOrders = data.docs[i].data();
      (localData.value['pending-orders'] as List).add({
        'id': cloudOrders['id'],
        'uid': cloudOrders['uid'],
        'title': cloudOrders['title'],
        'description': cloudOrders['description'],
        'color': cloudOrders['color'],
        'cover': cloudOrders['cover'],
        'condition': cloudOrders['condition'],
        'purchase-time': cloudOrders['purchase-time'],
        'time': cloudOrders['time'],
        'pages': cloudOrders['pages'],
        'price': cloudOrders['price'],
        'address': cloudOrders['address'],
        'language': cloudOrders['language'],
        'quantity': cloudOrders['quantity'],
        'images': cloudOrders['images'],
        'status': cloudOrders['status'],
        'trackingID': cloudOrders['trackingID']
      });
    }
  }

  static Future<void> getCompletedOrders() async {
    final data = await admin.doc('completed-orders').get();
    final mapped = data.data() ?? {};

    // orders variables
    final cloudOrders = mapped['orders'] ?? [];
    localData.value['completed-orders'] = [];
    final localOrders = localData.value['completed-orders'] ?? [];

    //loop to get data
    for (int i = 0; i < cloudOrders.length; i++) {
      localOrders.add({
        'id': cloudOrders[i]['id'],
        'uid': cloudOrders[i]['uid'],
        'title': cloudOrders[i]['title'],
        'description': cloudOrders[i]['description'],
        'color': cloudOrders[i]['color'],
        'cover': cloudOrders[i]['cover'],
        'condition': cloudOrders[i]['condition'],
        'purchase-time': cloudOrders['purchase-time'],
        'time': cloudOrders['time'],
        'pages': cloudOrders[i]['pages'],
        'language': cloudOrders[i]['language'],
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
    final cloudOrders = mapped['orders'] ?? [];
    localData.value['rejected-orders'] = [];
    final localOrders = localData.value['rejected-orders'] ?? [];

    //loop to get data
    for (int i = 0; i < cloudOrders.length; i++) {
      localOrders.add({
        'id': cloudOrders[i]['id'],
        'uid': cloudOrders[i]['uid'],
        'title': cloudOrders[i]['title'],
        'description': cloudOrders[i]['description'],
        'color': cloudOrders[i]['color'],
        'cover': cloudOrders[i]['cover'],
        'condition': cloudOrders[i]['condition'],
        'pages': cloudOrders[i]['pages'],
        'purchase-time': cloudOrders['purchase-time'],
        'time': cloudOrders['time'],
        'language': cloudOrders[i]['language'],
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

  static Future<void> updateStatus(
      String uid, String orderID, String newStatus) async {
    // update status in Users account
    final usercollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .get();
    final id = usercollection.docs
        .where((element) => element['id'] == orderID && element['uid'] == uid)
        .first
        .id;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('orders')
        .doc(id)
        .update({
      'status': newStatus,
    });

    // updte status in admin panel
    final admincollection = await FirebaseFirestore.instance
        .collection('admin')
        .doc('pending-orders')
        .collection('orders')
        .get();
    final adminId = admincollection.docs
        .where((element) => element['id'] == orderID && element['uid'] == uid)
        .first
        .id;
    await admin.doc('pending-orders').collection('orders').doc(adminId).update({
      'status': newStatus,
    });
  }
}
