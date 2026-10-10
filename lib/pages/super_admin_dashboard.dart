import 'package:flutter/material.dart';
import 'package:picklaundry/screen/delivery_partner_screen.dart';
import 'package:picklaundry/screen/users_screen.dart';
import 'package:picklaundry/services/order_service.dart';
import '../services/laundry_service.dart';
import '../models/service_item.dart';
import '../services/auth_service.dart';
// import '../constants/api_constants.dart';
import 'package:picklaundry/screen/orders_screen.dart';

class SuperAdminDashboard extends StatefulWidget {
  const SuperAdminDashboard({super.key});

  @override
  State<SuperAdminDashboard> createState() => _SuperAdminDashboardState();
}

class _SuperAdminDashboardState extends State<SuperAdminDashboard> {
  static const Color primary = Color(0xff0F172A);
  static const Color secondary = Color(0xff6D28D9);
  static const Color emerald = Color(0xff10B981);
  static const Color gold = Color(0xffD4AF37);

  final AuthService authService = AuthService();

  List<ServiceItem> currentItems = [];
  int totalUsers = 0;
  int totalOrders = 0;
  double totalRevenue = 0;
  String deliveredOrders = "0";
  String pickupPending="0";

  @override
  void initState() {
    super.initState();
    loadUserCount();
    loadOrderCount();
    loadRevenue();
    loadDashboard();
    loadPickupCount();
  }

  Future<void> loadPickupCount() async {
    final count = await OrderService().getPickupPendingCount();

    setState(() {
      pickupPending = count.toString();
    });
  }

  Future<void> loadDashboard() async {
    final count = await OrderService().getDeliveredCount();

    setState(() {
      deliveredOrders = count.toString();
    });
  }

  Future<void> loadRevenue() async {
    totalRevenue = await orderService.getTotalRevenue();

    setState(() {});
  }

  final OrderService orderService = OrderService();

  Future<void> loadOrderCount() async {
    totalOrders = await orderService.getOrderCount();

    setState(() {});
  }

  Future<void> loadUserCount() async {
    totalUsers = await authService.getUserCount();

    setState(() {});
  }

  Future<void> loadItems(int serviceId) async {
    try {
      currentItems = await ApiService.getItems(serviceId);

      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B1120),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: primary),
              child: Text(
                "PickLaundry Admin",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.dashboard), title: Text("Dashboard")),
            ListTile(
  leading: const Icon(Icons.people),

  title: const Text(
    "Users",
  ),

  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsersScreen(),
      ),
    );

  },
),
            ListTile(
  leading: Icon(Icons.payments),
  title: Text("Delivery Partners"),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DeliveryPartnerScreen(),
      ),
    );
  },
),
            ListTile(
  leading: const Icon(Icons.receipt_long),
  title: const Text("Orders"),
  onTap: () {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrdersScreen(),
      ),
    );
  },
),
            const ListTile(leading: Icon(Icons.analytics), title: Text("Delivery Boys Earnings")),
            const ListTile(leading: Icon(Icons.settings), title: Text("Settings")),
          ],
        ),
      ),

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: const Text(
          "PickLaundry Admin",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
          ),
          const SizedBox(width: 15),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: emerald,
        elevation: 12,
        icon: const Icon(Icons.bolt),
        label: const Text("Quick Actions"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: const Color(0xff111827),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    quickActionTile(Icons.person_add, "Add Partner"),

                    quickActionTile(Icons.local_offer, "Create Offer"),

                    quickActionTile(Icons.notifications, "Send Notification"),

                    quickActionTile(Icons.assignment, "Generate Report"),

                    quickActionTile(Icons.support_agent, "Customer Complaints"),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff0F172A),
                    Color(0xff1E293B),
                    Color(0xff6D28D9),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome Lipu Babu",
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Business Overview",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "KPI Overview",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.95,
              children: [
                dashboardCard(
                  "Total Users",
                  totalUsers.toString(),
                  Icons.people_alt_rounded,
                  emerald,
                ),

                dashboardCard(
                  "Total Orders",
                  totalOrders.toString(),
                  Icons.shopping_bag_rounded,
                  secondary,
                ),

                dashboardCard(
                  "Completed Orders",
                  deliveredOrders,
                  Icons.check_circle_rounded,
                  Colors.green,
                ),

                dashboardCard(
                  "Pickup Pending",
                  pickupPending,
                  Icons.local_shipping,
                  Colors.orange,
                ),

                dashboardCard(
                  "Total Revenue",
                  "₹${totalRevenue.toStringAsFixed(0)}",
                  Icons.account_balance_wallet_rounded,
                  gold,
                ),

                dashboardCard(
                  "Customer Rating",
                  "4.9★",
                  Icons.star_rounded,
                  Colors.amber,
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Services",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.65,
              children: [
                serviceCard(
                  context,
                  title: "Wash & Iron",
                  orders: "1,250 Orders",
                  revenue: "₹2.4L Revenue",
                  rating: "4.8",
                  growth: "+12%",
                  icon: Icons.iron,
                  color: Colors.blue,
                ),

                serviceCard(
                  context,
                  title: "Wash & Fold",
                  orders: "980 Orders",
                  revenue: "₹1.8L Revenue",
                  rating: "4.8",
                  growth: "+10%",
                  icon: Icons.checkroom,
                  color: Colors.purple,
                ),

                serviceCard(
                  context,
                  title: "Dry Cleaning",
                  orders: "720 Orders",
                  revenue: "₹3.1L Revenue",
                  rating: "4.8",
                  growth: "+10%",
                  icon: Icons.local_laundry_service,
                  color: Colors.orange,
                ),

                serviceCard(
                  context,
                  title: "Shoe Wash",
                  orders: "350 Orders",
                  revenue: "₹85K Revenue",
                  rating: "4.8",
                  growth: "+10%",
                  icon: Icons.hiking,
                  color: Colors.green,
                ),

                serviceCard(
                  context,
                  title: "Mending",
                  orders: "190 Orders",
                  revenue: "₹45K Revenue",
                  rating: "4.8",
                  growth: "+10%",
                  icon: Icons.content_cut,
                  color: Colors.redAccent,
                ),
              ],
            ),
            const SizedBox(height: 25),
           
          ],
        ),
      ),
    );
  }

  Widget analyticsRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          ),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration cardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      gradient: const LinearGradient(
        colors: [Color(0xff1E293B), Color(0xff111827)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      border: Border.all(color: Colors.white12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.25),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 5,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget recentOrderCard(
    String id,
    String customer,
    String service,
    String amount,
    String status,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            id,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Customer : $customer",
            style: const TextStyle(color: Colors.white70),
          ),

          Text(
            "Service : $service",
            style: const TextStyle(color: Colors.white70),
          ),

          Text(
            "Amount : $amount",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(status),
                backgroundColor: Colors.green.withOpacity(.2),
              ),

              Row(
                children: [
                  TextButton(onPressed: () {}, child: const Text("Details")),

                  TextButton(onPressed: () {}, child: const Text("Assign")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget dashboardCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.25), const Color(0xff111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "+12%",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            title,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(
    BuildContext context, {
    required String title,
    required String orders,
    required String revenue,
    required String growth,
    required String rating,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () async {
        switch (title) {
          case "Wash & Iron":
            await loadItems(2);
            showWashIronDialog(context);
            break;

          case "Wash & Fold":
            await loadItems(3);
            showWashFoldDialog(context);
            break;

          case "Dry Cleaning":
            await loadItems(4);
            showDryCleaningDialog(context);
            break;

          case "Shoe Wash":
            await loadItems(5);
            showShoeWashDialog(context);
            break;

          case "Mending":
            await loadItems(6);
            showMendingDialog(context);
            break;
        }
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [color.withOpacity(.25), const Color(0xff111827)],
          ),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 30),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    growth,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "$orders Orders",
              style: TextStyle(color: Colors.grey.shade400),
            ),

            Text(
              revenue,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),

                const SizedBox(width: 5),

                Text(rating, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showServiceDialog(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> items,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xff0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$title Pricing",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "${items[index]['name']} Price",
                            labelStyle: const TextStyle(color: Colors.white70),
                            prefixText: "₹ ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Prices Updated")),
                      );
                    },
                    child: const Text("SAVE PRICES"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showWashIronDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xff0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            height: 650,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Title
                const Text(
                  "Wash & Iron Pricing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Item List
                Expanded(
                  child: ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];

                      return pricingItemCard(item: item);
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Bottom Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          showAddItemDialog(context, 2);
                          await loadItems(2);
                        },

                        icon: const Icon(Icons.add),

                        label: const Text("Add Item"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          for (ServiceItem item in currentItems) {
                            print("Item ID = ${item.id}");
                            print(item.toJson());

                            bool success = await ApiService.updateItem(
                              id: item.id,
                              itemName: item.itemName,
                              basePrice: item.basePrice,
                              expressPrice: item.expressPrice,
                              premiumPrice: item.premiumPrice,
                              gst: item.gst,
                              active: item.active,
                            );

                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update item"),
                                ),
                              );
                              return;
                            }
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Prices Saved Successfully"),
                            ),
                          );
                        },

                        icon: const Icon(Icons.save),

                        label: const Text("Save Prices"),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showWashFoldDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xff0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 650,
            child: Column(
              children: [
                const Text(
                  "Wash & Fold Pricing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];

                      return pricingItemCard(item: item);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showAddItemDialog(context, 3);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Item"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          for (ServiceItem item in currentItems) {
                            print("Item ID = ${item.id}");
                            print(item.toJson());

                            bool success = await ApiService.updateItem(
                              id: item.id,
                              itemName: item.itemName,
                              basePrice: item.basePrice,
                              expressPrice: item.expressPrice,
                              premiumPrice: item.premiumPrice,
                              gst: item.gst,
                              active: item.active,
                            );

                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update item"),
                                ),
                              );
                              return;
                            }
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Prices Saved Successfully"),
                            ),
                          );
                        },

                        icon: const Icon(Icons.save),
                        label: const Text("Save Prices"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDryCleaningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xff0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 650,
            child: Column(
              children: [
                const Text(
                  "Dry Cleaning Pricing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];

                      return pricingItemCard(item: item);
                    },
                  ),
                ),
                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showAddItemDialog(context, 4);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Item"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          for (ServiceItem item in currentItems) {
                            print("Item ID = ${item.id}");
                            print(item.toJson());

                            bool success = await ApiService.updateItem(
                              id: item.id,
                              itemName: item.itemName,
                              basePrice: item.basePrice,
                              expressPrice: item.expressPrice,
                              premiumPrice: item.premiumPrice,
                              gst: item.gst,
                              active: item.active,
                            );

                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update item"),
                                ),
                              );
                              return;
                            }
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Prices Saved Successfully"),
                            ),
                          );
                        },

                        icon: const Icon(Icons.save),
                        label: const Text("Save Prices"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showShoeWashDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xff0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 650,
            child: Column(
              children: [
                const Text(
                  "Shoe Wash Pricing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];

                      return pricingItemCard(item: item);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showAddItemDialog(context, 5);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Item"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          for (ServiceItem item in currentItems) {
                            print("Item ID = ${item.id}");
                            print(item.toJson());

                            bool success = await ApiService.updateItem(
                              id: item.id,
                              itemName: item.itemName,
                              basePrice: item.basePrice,
                              expressPrice: item.expressPrice,
                              premiumPrice: item.premiumPrice,
                              gst: item.gst,
                              active: item.active,
                            );

                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update item"),
                                ),
                              );
                              return;
                            }
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Prices Saved Successfully"),
                            ),
                          );
                        },

                        icon: const Icon(Icons.save),
                        label: const Text("Save Prices"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showMendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: const Color(0xff0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: 650,
            child: Column(
              children: [
                const Text(
                  "Mending Pricing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: currentItems.length,
                    itemBuilder: (context, index) {
                      final item = currentItems[index];

                      return pricingItemCard(item: item);
                    },
                  ),
                ),

                const SizedBox(height: 15),

                // ✅ Buttons go INSIDE the Column
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showAddItemDialog(context, 6);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text("Add Item"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          for (ServiceItem item in currentItems) {
                            print("Item ID = ${item.id}");
                            print(item.toJson());

                            bool success = await ApiService.updateItem(
                              id: item.id,
                              itemName: item.itemName,
                              basePrice: item.basePrice,
                              expressPrice: item.expressPrice,
                              premiumPrice: item.premiumPrice,
                              gst: item.gst,
                              active: item.active,
                            );

                            if (!success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Failed to update item"),
                                ),
                              );
                              return;
                            }
                          }

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Prices Saved Successfully"),
                            ),
                          );
                        },

                        icon: const Icon(Icons.save),
                        label: const Text("Save Prices"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showAddItemDialog(BuildContext context, int serviceId) async {
    final itemController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add New Item"),

          content: TextField(
            controller: itemController,
            decoration: const InputDecoration(hintText: "Enter Item Name"),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                if (itemController.text.trim().isNotEmpty) {
                  bool success = await ApiService.addItem(
                    serviceId: serviceId,
                    itemName: itemController.text.trim(),
                    basePrice: 0,
                    expressPrice: 0,
                    premiumPrice: 0,
                    gst: 18,
                    active: true,
                  );

                  if (success) {
                    await loadItems(serviceId);

                    Navigator.pop(context);

                    setState(() {});

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Item Added Successfully")),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to Add Item")),
                    );
                  }
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Widget pricingItemCard({required ServiceItem item}) {
    bool isActive = item.active;

    final basePriceController = TextEditingController(
      text: item.basePrice.toString(),
    );

    final gstController = TextEditingController(text: item.gst.toString());

    final expressPriceController = TextEditingController(
      text: item.expressPrice.toString(),
    );

    final premiumPriceController = TextEditingController(
      text: item.premiumPrice.toString(),
    );

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xff1E293B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              //---------------- Header ----------------//
              Row(
                children: [
                  const Icon(Icons.checkroom, color: Colors.cyan),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      item.itemName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Switch(
                    value: isActive,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                        item.active = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 15),

              //---------------- Base Price + GST ----------------//
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: basePriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        item.basePrice = double.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                        labelText: "Base Price",
                        prefixText: "₹ ",
                        filled: true,
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: gstController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        item.gst = double.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                        labelText: "GST %",
                        filled: true,
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              //---------------- Express + Premium ----------------//
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expressPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        item.expressPrice = double.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                        labelText: "Express Price",
                        prefixText: "₹ ",
                        filled: true,
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: TextField(
                      controller: premiumPriceController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        item.premiumPrice = double.tryParse(value) ?? 0;
                      },
                      decoration: InputDecoration(
                        labelText: "Premium Price",
                        prefixText: "₹ ",
                        filled: true,
                        fillColor: Colors.black26,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget revenueItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget statusCard(String title, String count, Color color, IconData icon) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [color.withOpacity(.25), const Color(0xff111827)],
        ),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),

          const Spacer(),

          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  static Widget orderTile(String orderId, String status, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(.2),
          child: Icon(Icons.receipt_long, color: color),
        ),
        title: Text(orderId),
        subtitle: Text(status),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget quickActionTile(IconData icon, String title) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: emerald.withOpacity(.15),
        child: Icon(icon, color: emerald),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white54,
        size: 16,
      ),
    );
  }

  Widget graphBar(double height) {
    return Container(
      width: 24,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xff10B981), Color(0xff6D28D9)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
    );
  }

  Widget revenueCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color.withOpacity(.12),
        border: Border.all(color: color.withOpacity(.4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(title, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  Widget operationCard(String title, String count, Color color, IconData icon) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color(0xff111827),
        border: Border.all(color: color.withOpacity(.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),

          const Spacer(),

          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(title, style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
