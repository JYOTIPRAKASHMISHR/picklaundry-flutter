class DeliveryPartnerModel {
  final int id;
  final String fullName;
  final String mobile;
  final int completedOrders;
  final int pendingEarnings;
  final int totalEarnings;

  DeliveryPartnerModel({
    required this.id,
    required this.fullName,
    required this.mobile,
    required this.completedOrders,
    required this.pendingEarnings,
    required this.totalEarnings,
  });

  factory DeliveryPartnerModel.fromJson(
      Map<String, dynamic> json) {
    return DeliveryPartnerModel(
      id: json["id"],
      fullName: json["fullName"],
      mobile: json["mobile"],
      completedOrders: json["completedOrders"] ?? 0,
      pendingEarnings: json["pendingEarnings"] ?? 0,
      totalEarnings: json["totalEarnings"] ?? 0,
    );
  }
}