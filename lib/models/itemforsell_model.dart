// ignore_for_file: file_names

class ItemForSaleModel {
  final String? title, shortInfo, longInfo, price, id, category;
  final List imageLinks;

  ItemForSaleModel(
      {this.title,
      this.shortInfo,
      this.longInfo,
      this.price,
      this.id,
      required this.category,
      required this.imageLinks});
}
