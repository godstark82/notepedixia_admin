import 'package:flutter/foundation.dart';
import 'package:notepedixia_admin/models/itemforsell_model.dart';

List<String> category = [];
final ValueNotifier<List<ItemForSaleModel>> items = ValueNotifier([]);
final ValueNotifier<Map<String, List<Map<String, dynamic>>>> localData =
    ValueNotifier({});
List<Map<String, dynamic>> notifications = [];
String counter = '';
