import 'package:flutter/foundation.dart';
import 'package:notepedixia_admin/models/itemforsell_model.dart';

List<String> categoryName = [];
List<String> categoryImg = [];
final ValueNotifier<List<ItemForSaleModel>> shopItems = ValueNotifier([]);
final ValueNotifier<List<ItemForSaleModel>> notesItems = ValueNotifier([]);
final ValueNotifier localData =
    ValueNotifier({});
List<Map<String, dynamic>> notifications = [];
String counter = '';
