class CartItem {
  final int serviceId;
  final String serviceName;

  final int itemId;
  final String itemName;

  final double price;
  final String plan;

  int quantity;

  CartItem({
    required this.serviceId,
    required this.serviceName,
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.plan,
    this.quantity = 1,
  });
}