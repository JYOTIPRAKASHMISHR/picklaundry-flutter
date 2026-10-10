class ServiceItem {
  final int id;
  final String itemName;

  double basePrice;
  double expressPrice;
  double premiumPrice;
  double gst;
  bool active;

  ServiceItem({
    required this.id,
    required this.itemName,
    required this.basePrice,
    required this.expressPrice,
    required this.premiumPrice,
    required this.gst,
    required this.active,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      id: json["id"] ?? 0,
      itemName: json["itemName"] ?? "",
      basePrice: (json["basePrice"] as num?)?.toDouble() ?? 0.0,
      expressPrice: (json["expressPrice"] as num?)?.toDouble() ?? 0.0,
      premiumPrice: (json["premiumPrice"] as num?)?.toDouble() ?? 0.0,
      gst: (json["gst"] as num?)?.toDouble() ?? 0.0,
      active: json["active"] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "itemName": itemName,
      "basePrice": basePrice,
      "expressPrice": expressPrice,
      "premiumPrice": premiumPrice,
      "gst": gst,
      "active": active,
    };
  }
}