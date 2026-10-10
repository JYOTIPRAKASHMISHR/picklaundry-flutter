import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:url_launcher/url_launcher.dart';
import 'package:printing/printing.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  //---------------------------------------------------------
  // CHANGE THIS TO YOUR SPRING BOOT SERVER
  //---------------------------------------------------------

  static const String baseUrl = "https://picklaundrybackend-production.up.railway.app/api/orders";

  //---------------------------------------------------------
  // VARIABLES
  //---------------------------------------------------------

  bool isLoading = true;

  bool downloadingInvoice = false;

  List<dynamic> orders = [];

  //---------------------------------------------------------
  // INIT
  //---------------------------------------------------------

  @override
  void initState() {
    super.initState();
    loadOrders();
  }


Future<void> callDeliveryPartner(String mobile) async {
  final Uri uri = Uri.parse("tel:$mobile");

  try {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Unable to make phone call: $e"),
      ),
    );
  }
}
  
  //---------------------------------------------------------
  // LOAD ORDERS
  //---------------------------------------------------------

  Future<void> loadOrders() async {
    try {
      setState(() {
        isLoading = true;
      });

      final prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("accessToken") ?? "";

      final response = await http.get(
        Uri.parse(baseUrl),

        headers: {
          "Authorization": "Bearer $token",

          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        orders = jsonDecode(response.body);
      } else {
        orders = [];

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(response.body)));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  //---------------------------------------------------------
  // STATUS COLOR
  //---------------------------------------------------------

  Color statusColor(String status) {
    switch (status.toUpperCase()) {
      case "PENDING":
        return Colors.orange;

      case "CONFIRMED":
        return Colors.blue;

      case "OUT_FOR_PICKUP":
        return Colors.deepPurple;

      case "PROCESSING":
        return Colors.purple;

      case "OUT_FOR_DELIVERY":
        return Colors.teal;

      case "DELIVERED":
        return Colors.green;

      case "CANCELLED":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  //---------------------------------------------------------
  // PLAN COLOR
  //---------------------------------------------------------

  Color planColor(String plan) {
    switch (plan.toUpperCase()) {
      case "BASE":
        return Colors.blue;

      case "EXPRESS":
        return Colors.orange;

      case "PREMIUM":
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }

  //---------------------------------------------------------
  // BUILD
  //---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        backgroundColor: const Color(0xff0F172A),

        elevation: 0,

        centerTitle: true,

        title: const Text(
          "My Orders",

          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),

        actions: [
          IconButton(onPressed: loadOrders, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: const [
                  Icon(Icons.receipt_long, color: Colors.white24, size: 120),

                  SizedBox(height: 20),

                  Text(
                    "No Orders Found",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Place your first laundry order.",

                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadOrders,

              child: ListView.builder(
                padding: const EdgeInsets.all(16),

                itemCount: orders.length,

                itemBuilder: (context, index) {
                  final order = orders[index];

                  return orderCard(order);
                },
              ),
            ),
    );
  }

  //---------------------------------------------------------
  // ORDER CARD
  //---------------------------------------------------------

  Widget orderCard(Map<String, dynamic> order) {
    List items = order["items"] ?? [];

    String services = "";

    if (items.isNotEmpty) {
      services = items.map((e) => e["serviceName"]).toSet().join(", ");
    }

    return Card(
      color: const Color(0xff1E293B),

      elevation: 6,

      margin: const EdgeInsets.only(bottom: 18),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.orange),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    order["orderId"],

                    style: const TextStyle(
                      color: Colors.white,

                      fontWeight: FontWeight.bold,

                      fontSize: 17,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,

                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: statusColor(order["orderStatus"]).withOpacity(.15),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    order["orderStatus"],

                    style: TextStyle(
                      color: statusColor(order["orderStatus"]),

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            ListTile(
              contentPadding: EdgeInsets.zero,

              leading: const Icon(Icons.person, color: Colors.blue),

              title: const Text(
                "Customer",

                style: TextStyle(color: Colors.white54),
              ),

              subtitle: Text(
                order["customerName"],

                style: const TextStyle(
                  color: Colors.white,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,

              leading: const Icon(
                Icons.local_laundry_service,

                color: Colors.cyan,
              ),

              title: const Text(
                "Services",

                style: TextStyle(color: Colors.white54),
              ),

              subtitle: Text(
                services,

                style: const TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,

              leading: const Icon(Icons.location_on, color: Colors.red),

              title: const Text(
                "Pickup Address",
                style: TextStyle(color: Colors.white54),
              ),

              subtitle: Text(
                order["pickupAddress"],
                style: const TextStyle(color: Colors.white),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,

              leading: const Icon(Icons.workspace_premium, color: Colors.amber),

              title: const Text(
                "Selected Plan",
                style: TextStyle(color: Colors.white54),
              ),

              subtitle: Text(
                order["selectedPlan"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              contentPadding: EdgeInsets.zero,

              leading: const Icon(Icons.payments, color: Colors.green),

              title: const Text(
                "Payment",
                style: TextStyle(color: Colors.white54),
              ),

              subtitle: Text(
                order["paymentStatus"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (order["orderStatus"] == "OUT_FOR_DELIVERY" ||
    order["orderStatus"] == "DELIVERED")
  ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(
      Icons.delivery_dining,
      color: Colors.orange,
    ),
    title: const Text(
      "Delivery Partner",
      style: TextStyle(color: Colors.white54),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          order["deliveryPartnerName"] ?? "Not Assigned",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

      InkWell(
  onTap: () {
    callDeliveryPartner(
      order["deliveryPartnerMobile"],
    );
  },
  child: Text(
    order["deliveryPartnerMobile"] ?? "",
    style: const TextStyle(
      color: Colors.lightBlueAccent,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.bold,
    ),
  ),
),

      ],
    ),
  ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff2563EB), Color(0xff4F46E5)],
                ),

                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                children: [
                  const Text(
                    "Grand Total",

                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),

                  const Spacer(),

                  Text(
                    "₹${order["grandTotal"]}",

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 24,

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    icon: const Icon(Icons.visibility),

                    label: const Text("View"),

                    onPressed: () {
                      showOrderDetails(order);
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    icon: const Icon(Icons.picture_as_pdf),

                    label: const Text("Invoice"),

                    onPressed: () async {
                      await generateInvoice(order);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  //---------------------------------------------------------
  // ORDER DETAILS BOTTOM SHEET
  //---------------------------------------------------------

  void showOrderDetails(Map<String, dynamic> order) {
    final List items = order["items"] ?? [];

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: const Color(0xff111827),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,

          initialChildSize: .92,

          maxChildSize: .98,

          builder: (_, controller) {
            return ListView(
              controller: controller,

              padding: const EdgeInsets.all(20),

              children: [
                Center(
                  child: Container(
                    width: 70,

                    height: 5,

                    decoration: BoxDecoration(
                      color: Colors.white30,

                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Order Details",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 26,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                detailTile(Icons.receipt_long, "Order ID", order["orderId"]),

                detailTile(Icons.person, "Customer", order["customerName"]),

                detailTile(Icons.phone, "Mobile", order["mobileNumber"]),

                detailTile(
                  Icons.location_on,

                  "Pickup Address",

                  order["pickupAddress"],
                ),

                detailTile(
                  Icons.workspace_premium,

                  "Selected Plan",

                  order["selectedPlan"],
                ),

                detailTile(
                  Icons.payments,

                  "Payment Method",

                  order["paymentStatus"],
                ),

                detailTile(
                  Icons.local_shipping,

                  "Order Status",

                  order["orderStatus"],
                ),

                if (order["orderStatus"] == "OUT_FOR_DELIVERY" ||
    order["orderStatus"] == "DELIVERED") ...[

  detailTile(
    Icons.delivery_dining,
    "Delivery Partner",
    order["deliveryPartnerName"] ?? "Not Assigned",
  ),

  ListTile(
  leading: const Icon(
    Icons.phone,
    color: Colors.green,
  ),
  title: const Text(
    "Partner Mobile",
    style: TextStyle(color: Colors.white54),
  ),
  subtitle: InkWell(
    onTap: () {
      callDeliveryPartner(
        order["deliveryPartnerMobile"],
      );
    },
    child: Text(
      order["deliveryPartnerMobile"] ?? "",
      style: const TextStyle(
        color: Colors.lightBlueAccent,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),

],

                const SizedBox(height: 25),

                const Text(
                  "Laundry Items",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 22,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                for (var item in items)
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),

                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      color: const Color(0xff1E293B),

                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          item["serviceName"],

                          style: const TextStyle(
                            color: Colors.blue,

                            fontWeight: FontWeight.bold,

                            fontSize: 17,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item["itemName"],

                          style: const TextStyle(
                            color: Colors.white,

                            fontSize: 20,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Plan : ${item["selectedPlan"]}",

                          style: const TextStyle(color: Colors.white70),
                        ),

                        Text(
                          "Quantity : ${item["quantity"]}",

                          style: const TextStyle(color: Colors.white70),
                        ),

                        Text(
                          "Price : ₹${item["price"]}",

                          style: const TextStyle(
                            color: Colors.green,

                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          "Subtotal : ₹${item["subtotal"]}",

                          style: const TextStyle(
                            color: Colors.orange,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 25),

                const Text(
                  "Track Your Order",

                  style: TextStyle(
                    color: Colors.white,

                    fontSize: 22,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                buildTrackingTimeline(order["orderStatus"]),

                const SizedBox(height: 30),

                //---------------------------------------------------------
                // GRAND TOTAL CARD
                //---------------------------------------------------------
                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff2563EB), Color(0xff4F46E5)],
                    ),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [
                      const Text(
                        "Grand Total",

                        style: TextStyle(color: Colors.white70, fontSize: 18),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "₹${order["grandTotal"]}",

                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 34,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Payment : ${order["paymentStatus"]}",

                        style: const TextStyle(
                          color: Colors.white70,

                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                //---------------------------------------------------------
                // DOWNLOAD INVOICE BUTTON
                //---------------------------------------------------------
                SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),

                    label: const Text(
                      "Download Invoice",

                      style: TextStyle(
                        fontSize: 18,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    onPressed: () async {
                      Navigator.pop(context);

                      await generateInvoice(order);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                //---------------------------------------------------------
                // CANCEL ORDER BUTTON
                //---------------------------------------------------------
                if (order["orderStatus"] == "PENDING")
                  SizedBox(
                    width: double.infinity,

                    height: 55,

                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),

                      label: const Text(
                        "Cancel Order",

                        style: TextStyle(
                          fontSize: 18,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,

                        foregroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      onPressed: () async {
                        Navigator.pop(context);

                        await cancelOrder(order["orderId"]);
                      },
                    ),
                  ),

                const SizedBox(height: 30),
              ],
            );
          },
        );
      },
    );
  }

  //---------------------------------------------------------
  // DETAIL TILE
  //---------------------------------------------------------

  Widget detailTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),

      title: Text(title, style: const TextStyle(color: Colors.white54)),

      subtitle: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // ORDER TRACKING TIMELINE
  //---------------------------------------------------------

  Widget buildTrackingTimeline(String status) {
    int currentStep = 0;

    switch (status.toUpperCase()) {
      case "PENDING":
        currentStep = 1;
        break;

      case "CONFIRMED":
        currentStep = 2;
        break;

      case "OUT_FOR_PICKUP":
        currentStep = 3;
        break;

      case "PROCESSING":
        currentStep = 4;
        break;

      case "OUT_FOR_DELIVERY":
        currentStep = 5;
        break;

      case "DELIVERED":
        currentStep = 6;
        break;

      default:
        currentStep = 1;
    }

    final steps = [
      "Order Placed",

      "Order Confirmed",

      "Out For Pickup",

      "Laundry Processing",

      "Out For Delivery",

      "Delivered",
    ];

    return Column(
      children: List.generate(steps.length, (index) {
        bool completed = index < currentStep;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 16,

                  backgroundColor: completed
                      ? Colors.green
                      : Colors.grey.shade700,

                  child: Icon(
                    completed ? Icons.check : Icons.circle,

                    color: Colors.white,

                    size: 16,
                  ),
                ),

                if (index != steps.length - 1)
                  Container(
                    width: 3,

                    height: 45,

                    color: completed ? Colors.green : Colors.grey.shade700,
                  ),
              ],
            ),

            const SizedBox(width: 15),

            Padding(
              padding: const EdgeInsets.only(top: 4),

              child: Text(
                steps[index],

                style: TextStyle(
                  color: completed ? Colors.green : Colors.white54,

                  fontWeight: FontWeight.bold,

                  fontSize: 17,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  //---------------------------------------------------------
  // CANCEL ORDER API
  //---------------------------------------------------------

  Future<void> cancelOrder(String orderId) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String token = prefs.getString("accessToken") ?? "";

      final response = await http.put(
        Uri.parse("$baseUrl/$orderId/cancel"),

        headers: {
          "Authorization": "Bearer $token",

          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,

            content: Text("Order Cancelled Successfully"),
          ),
        );

        loadOrders();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.body)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  //---------------------------------------------------------
  // DOWNLOAD INVOICE
  //---------------------------------------------------------

  Future<void> generateInvoice(Map<String, dynamic> order) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.orange,

        content: Text("Invoice generation will be added next."),
      ),
    );
  }
}
