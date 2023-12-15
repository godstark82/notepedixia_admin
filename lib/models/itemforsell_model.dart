// ignore_for_file: file_names

class ItemForSaleModel {
  final String? title, shortInfo, longInfo, price, id, category;
  final List imageLinks;

  ItemForSaleModel(
      {required this.title,
      required this.shortInfo,
      required this.longInfo,
      required this.price,
      required this.id,
      required this.category,
      required this.imageLinks});
}
