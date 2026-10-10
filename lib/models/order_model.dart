class OrderModel {
  final String orderId;
  final String customerName;
  final String mobileNumber;
  final String pickupAddress;
  final String selectedPlan;
  final int totalItems;
  final double grandTotal;
  final String orderStatus;
  final DateTime createdAt;
  final String paymentMethod;
  final String paymentStatus;

  OrderModel({
    required this.orderId,
    required this.customerName,
    required this.mobileNumber,
    required this.pickupAddress,
    required this.selectedPlan,
    required this.totalItems,
    required this.grandTotal,
    required this.orderStatus,
    required this.createdAt,
    required this.paymentStatus,
    this.paymentMethod = "Cash on Delivery",
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json["orderId"],
      customerName: json["customerName"],
      mobileNumber: json["mobileNumber"],
      pickupAddress: json["pickupAddress"],
      selectedPlan: json["selectedPlan"],
      totalItems: json["totalItems"],
      grandTotal: double.parse(json["grandTotal"].toString()),
      orderStatus: json["orderStatus"],
      createdAt: DateTime.parse(json["createdAt"]),
      paymentMethod: json["paymentMethod"] ?? "Cash on Delivery",
      paymentStatus: json["paymentStatus"] ?? "Pending",
    );
  }
}
