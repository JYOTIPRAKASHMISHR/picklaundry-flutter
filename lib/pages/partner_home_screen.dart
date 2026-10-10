import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';  
import '../services/pickup_service.dart';
import 'login_screen.dart';
import 'processing_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class PartnerDashboard extends StatefulWidget {
  const PartnerDashboard({super.key});

  @override
  State<PartnerDashboard> createState() =>
      _PartnerDashboard();
}

class _PartnerDashboard
    extends State<PartnerDashboard> {
      String selectedTab = "PICKUP";

  //-------------------------------------------------------
  // ONLINE STATUS
  //-------------------------------------------------------

  bool isOnline = true;

  //-------------------------------------------------------
  // DASHBOARD DATA
  //-------------------------------------------------------

  int totalOrders = 0;
  int completedOrders = 0;
  int pendingOrders = 0;

  double todayEarnings = 0;
  int pendingEarnings = 0;

int totalEarnings = 0;



  //-------------------------------------------------------
  // ACTIVE ORDERS
  //-------------------------------------------------------

 List<OrderModel> activeOrders = [];
 List<OrderModel> deliveryOrders = [];

final PickupService orderService = PickupService();
  //-------------------------------------------------------
  // INIT
  //-------------------------------------------------------

  @override
  void initState() {
    super.initState();

    // loadDummyOrders();
    loadPickupOrders();
    loadDashboardData();
  }
  Future<void> loadDashboardData() async {

  try {

    totalEarnings =
        await orderService.getTotalEarnings();

    pendingEarnings =
        await orderService.getPendingEarnings();

    completedOrders =
        await orderService.getCompletedOrders();

    setState(() {});

  } catch (e) {

    print(e);

  }

}

  Future<void> openGoogleMaps(String address) async {

  final Uri googleMapUrl = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}",
  );

  if (await canLaunchUrl(googleMapUrl)) {
    await launchUrl(
      googleMapUrl,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw Exception("Could not launch Google Maps");
  }
}

  Future<void> loadDeliveryOrders() async {

  deliveryOrders = await orderService.getDeliveryOrders();

  setState(() {});

}

 Future<void> loadPickupOrders() async {

  print("Loading pickup orders...");

  try {

    activeOrders = await orderService.getPickupOrders();

    print("Loaded ${activeOrders.length}");

    totalOrders = activeOrders.length;
    pendingOrders = activeOrders.length;

    setState(() {});

  } catch (e, s) {

    print("ERROR = $e");
    print(s);

  }

}
  //-------------------------------------------------------

  //-------------------------------------------------------
  // LOGOUT
  //-------------------------------------------------------

//   Future<void> logout() async {

//   final prefs = await SharedPreferences.getInstance();

//   String? refreshToken = prefs.getString("refreshToken");

//   if (refreshToken != null) {
//       await authService.logout(refreshToken);
//   }

//   await prefs.remove("accessToken");
//   await prefs.remove("refreshToken");
//   await prefs.remove("role");
//   await prefs.remove("userId");
//   await prefs.remove("fullName");

//   if (!mounted) return;

//   Navigator.pushAndRemoveUntil(
//     context,
//     MaterialPageRoute(
//       builder: (_) => const LoginScreen(),
//     ),
//     (route) => false,
//   );
// }
  
  
  //-------------------------------------------------------
  // BUILD
  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {

final filteredOrders = activeOrders.where((order) {

  if (selectedTab == "PICKUP") {
    return order.orderStatus == "PICKUP_PENDING";
  }

  return order.orderStatus == "READY_FOR_DELIVERY";

}).toList();

    return Scaffold(

    backgroundColor: const Color(0xFF1E3A8A),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.indigo,

        foregroundColor: const Color.fromARGB(255, 240, 238, 238),

        centerTitle: true,

        title: const Text(
          "Delivery Partner",
        ),

        actions: [

          // IconButton(

          //   icon: const Icon(Icons.logout),

          //   onPressed: logout,

          // ),

        ],
      ),

      body: SingleChildScrollView(

        child: Column(

          children: [

            //-------------------------------------------------
            // TOP CARD
            //-------------------------------------------------

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: const BoxDecoration(

                color: Colors.indigo,

                borderRadius: BorderRadius.only(

                  bottomLeft: Radius.circular(30),

                  bottomRight: Radius.circular(30),

                ),

              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Welcome Partner 👋",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 26,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Manage pickups and deliveries",

                    style: TextStyle(

                      color: Colors.white70,

                    ),

                  ),

                  const SizedBox(height: 25),

                  Row(

                    children: [

                      const Text(

                        "Status",

                        style: TextStyle(

                          color: Colors.white,

                          fontSize: 16,

                        ),

                      ),

                      const Spacer(),

                      Text(

                        isOnline
                            ? "ONLINE"
                            : "OFFLINE",

                        style: TextStyle(

                          color: isOnline
                              ? Colors.greenAccent
                              : Colors.redAccent,

                          fontWeight:
                              FontWeight.bold,

                        ),

                      ),

                      Switch(

                        value: isOnline,

                        activeColor:
                            Colors.greenAccent,

                        onChanged: (value) {

                          setState(() {

                            isOnline = value;

                          });

                        },

                      ),

                    ],

                  ),

                ],

              ),

            ),

            const SizedBox(height: 20),

            //-------------------------------------------------
            // DASHBOARD CARDS
            //-------------------------------------------------

       Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      Expanded(
        child: dashboardCard(
          "Orders",
          totalOrders.toString(),
          Icons.shopping_bag_rounded,
          const Color(0xFF3B82F6), // Blue
        ),
      ),
      const SizedBox(width: 12),

       Expanded(
        child: dashboardCard(
           "Total Earnings",
           "₹$totalEarnings",
          Icons.currency_rupee_rounded,
          const Color(0xFF8B5CF6), // Purple
        ),
      ),
     
    ],
  ),
),

const SizedBox(height: 12),

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [
      Expanded(
        child: dashboardCard(
          "Pending",
          pendingOrders.toString(),
          Icons.pending_actions_rounded,
          const Color(0xFFF59E0B), // Amber
        ),
      ),
      const SizedBox(width: 12),
       Expanded(
        child: dashboardCard(
          "Completed",
          completedOrders.toString(),
          Icons.check_circle_rounded,
          const Color(0xFF10B981), // Emerald
        ),
      ),
     
    ],
  ),
),

const SizedBox(height: 12),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Row(
    children: [

      Expanded(
        child: dashboardCard(
          "Pending Earnings",
          "₹$pendingEarnings",
          Icons.account_balance_wallet_rounded,
          Colors.orange,
        ),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: dashboardCard(
          "Online Status",
          isOnline ? "Online" : "Offline",
          Icons.circle,
          isOnline ? Colors.green : Colors.red,
        ),
      ),

    ],
  ),
),
const SizedBox(height: 25),
            //-------------------------------------------------
// ACTIVE ORDERS TITLE
//-------------------------------------------------

Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      const Row(
        children: [

          Icon(
            Icons.local_shipping,
            color: Colors.indigo,
          ),

          SizedBox(width: 10),

          Text(
            "Active Orders",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),

      const SizedBox(height: 15),

      Row(
        children: [

          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedTab = "PICKUP";
                });
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTab == "PICKUP"
                    ? const Color.fromARGB(255, 39, 151, 171)
                    : Colors.grey.shade300,

                foregroundColor: selectedTab == "PICKUP"
                    ? Colors.white
                    : Colors.black,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              child: const Text("Pickup Orders"),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                setState(() {
                  selectedTab = "DELIVERY";
                });
                await loadDeliveryOrders();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: selectedTab == "DELIVERY"
                    ? Colors.green
                    : Colors.grey.shade300,

                foregroundColor: selectedTab == "DELIVERY"
                    ? Colors.white
                    : Colors.black,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),

              child: const Text("Delivery Orders"),
            ),
          ),

        ],
      ),
    ],
  ),
),
const SizedBox(height: 15),

//-------------------------------------------------
// ORDER LIST
//-------------------------------------------------



ListView.builder(
     

  shrinkWrap: true,

  physics: const NeverScrollableScrollPhysics(),

itemCount: selectedTab == "PICKUP"
    ? filteredOrders.length
    : deliveryOrders.length,

  itemBuilder: (context, index) {
final OrderModel order = selectedTab == "PICKUP"
    ? filteredOrders[index]
    : deliveryOrders[index];

    return Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: const Color(0xFF334155),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(
            color: Colors.grey.withOpacity(.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )

        ],

      ),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Expanded(
  child: Text(
    order.orderId,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),
              const SizedBox(width: 10),

              Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),

                decoration: BoxDecoration(

                  color: order.orderStatus==
                          "PICKUP_PENDING"
                      ? Colors.orange.shade100
                      : Colors.green.shade100,

                  borderRadius:
                      BorderRadius.circular(20),

                ),

                child: Text(

                  order.orderStatus,

                  style: TextStyle(

                    color: order.orderStatus ==
                            "PICKUP_PENDING"
                        ? Colors.orange
                        : Colors.green,

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),

              ),

            ],

          ),

          const Divider(height: 25),

          infoRow(
            Icons.person,
            order.customerName,
          ),

          const SizedBox(height: 8),

          infoRow(
            Icons.phone,
            order.mobileNumber,
          ),

          const SizedBox(height: 8),

          Row(
  children: [

    Expanded(
      child: infoRow(
        Icons.location_on,
        order.pickupAddress,
      ),
    ),

    IconButton(
      icon: const Icon(
        Icons.navigation,
        color: Colors.blue,
      ),
      onPressed: () {
        openGoogleMaps(order.pickupAddress);
      },
    ),

  ],
),

          const SizedBox(height: 8),

          infoRow(
            Icons.local_laundry_service,
            order.selectedPlan,
          ),

          const SizedBox(height: 8),

          infoRow(
            Icons.currency_rupee,
            "₹${order.grandTotal}",
          ),

          

          const SizedBox(height: 20),



        selectedTab == "PICKUP"
    ? Row(
        children: [

          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.motorcycle),
              label: const Text("Out For Pickup"),
              onPressed: order.orderStatus == "PICKUP_PENDING"
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Partner is going for Pickup"),
                        ),
                      );
                    }
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.check_circle),
              label: const Text("Picked Up"),
              onPressed: order.orderStatus == "PICKUP_PENDING"
                  ? () async {
                      await orderService.pickupOrder(order.orderId);
                      await loadPickupOrders();
                    }
                  : null,
            ),
          ),

        ],
      )

    : Row(
        children: [

          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.local_shipping),
              label: const Text("Out For Delivery"),
              onPressed: order.orderStatus == "READY_FOR_DELIVERY"
                  ? () async {

                      await orderService.outForDelivery(order.orderId);

                      await loadDeliveryOrders();

                    }
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.done_all),
              label: const Text("Delivered"),
              onPressed: order.orderStatus == "OUT_FOR_DELIVERY"
                  ? () async {

                      await orderService.delivered(order.orderId);

                      await loadDeliveryOrders();
                      await loadDashboardData();

                    }
                  : null,
            ),
          ),

        ],
      ),

        ],

      ),

    );

  },
          

),


const SizedBox(height: 25),

],
),
),

      //---------------------------------------------------------
      // FLOATING BUTTON
      //---------------------------------------------------------

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.refresh),
        label: const Text("Refresh"),
        onPressed: () {
          loadPickupOrders();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Orders Refreshed"),
            ),
          );
        },
      ),

      //---------------------------------------------------------
      // BOTTOM NAVIGATION
      //---------------------------------------------------------

      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  selectedItemColor: const Color.fromARGB(255, 65, 78, 151),
  unselectedItemColor: const Color.fromARGB(255, 65, 176, 141),
  type: BottomNavigationBarType.fixed,

  onTap: (index) {

    switch (index) {

      case 0:
        // Already on Home
        break;

      case 1:

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ProcessingScreen(),
          ),
        );

        break;

      case 2:
        // Earnings Screen (Later)
        break;

      case 3:
        // Profile Screen (Later)
        break;
    }
  },

  items: const [

    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.assignment),
      label: "Orders",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.currency_rupee),
      label: "Earnings",
    ),

    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: "Profile",
    ),

  ],
),
);
} // <-- build() ends here



//---------------------------------------------------------
// DASHBOARD CARD
//---------------------------------------------------------

Widget dashboardCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {
  return Container(
    height: 190, // Same size for every card
    decoration: BoxDecoration(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: Colors.white.withOpacity(.08),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.18),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
//---------------------------------------------------------
// INFORMATION ROW
//---------------------------------------------------------

Widget infoRow(

  IconData icon,

  String value,

) {

  return Row(

    children: [

      Icon(

        icon,

        color: const Color.fromARGB(255, 63, 161, 181),

        size: 20,

      ),

      const SizedBox(width: 10),

      Expanded(

        child: Text(

          value,

          style: const TextStyle(

            fontSize: 15,

            fontWeight: FontWeight.w500,

          ),

        ),

      ),

    ],

  );
}


}