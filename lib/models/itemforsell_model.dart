import 'package:flutter/material.dart';

class ItemForSaleModel {
  String? id,
      title,
      price,
      category,
      description,
      condition,
      pages,
      language,
      cover,
      time;
  Color bgColor;
  List tags;
  List images;
  ItemForSaleModel(
      {required this.bgColor,
      required this.tags,
      required this.category,
      required this.id,
      required this.images,
      required this.price,
      required this.title,
      required this.description,
      required this.condition,
      required this.pages,
      required this.language,
      required this.cover,
      required this.time});

  //
}
