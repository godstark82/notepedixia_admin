

class OrderModel {
  String? id, uid, title, price, status, trackingId,address;
  int? quantity;
  List? images;
  OrderModel({
    required this.address,
    required this.id,
    required this.images,
    // required this.longInfo,
    required this.price,
    required this.quantity,
    // required this.shortInfo,
    required this.title,
    required this.uid,
    required this.status,
    required this.trackingId,
  });
}
