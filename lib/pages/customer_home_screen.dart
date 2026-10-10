import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:picklaundry/models/order_model.dart';
import 'package:picklaundry/pages/profile_screen.dart';
import 'package:picklaundry/pages/service_details_screen.dart';
import 'package:picklaundry/services/order_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/weather_card.dart';
import 'services_screen.dart';
import 'package:picklaundry/pages/order_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {

  List<OrderModel> recentOrders = [];
bool loadingOrders = true;

  String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 12) {
    return "Good Morning 👋";
  } else if (hour < 17) {
    return "Good Afternoon ☀️";
  } else {
    return "Good Evening 🌙";
  }
}

  WeatherModel? weather;
  bool isLoadingWeather = true;

  int selectedIndex = 0;
  final String baseUrl =
      "http://10.108.147.139:8080/api/orders";
  Map<String, dynamic>? recentOrder;
  bool isLoading = true;

  final Color primaryColor = const Color(0xff0F172A);

  final Color secondaryColor = const Color(0xff6D28D9);

  final Color accentColor = const Color(0xff10B981);

  final Color goldColor = const Color(0xffD4AF37);
  String fullName = "";

  @override
  void initState() {
    super.initState();
    loadRecentOrder();
    loadWeather();
    loadUser();
    loadRecentOrderss();
  }
 final List<Map<String, dynamic>> featuredServices  = [

  {
    "id": 2,
    "title": "Wash & Iron",
    "orders": "950+ Orders",
    "icon": Icons.iron,
    "color": const Color(0xff7C3AED),
  },

  {
    "id": 3,
    "title": "Wash & Fold",
    "orders": "1200+ Orders",
    "icon": Icons.local_laundry_service,
    "color": const Color(0xff2563EB),
  },

  

  {
    "id": 4,
    "title": "Dry Cleaning",
    "orders": "700+ Orders",
    "icon": Icons.dry_cleaning,
    "color": const Color(0xffEC4899),
  },

  {
    "id": 5,
    "title": "Shoe Cleaning",
    "orders": "450+ Orders",
    "icon": Icons.hiking,
    "color": const Color(0xff10B981),
  },

  {
    "id": 6,
    "title": "Mending",
    "orders": "350+ Orders",
    "icon": Icons.content_cut,
    "color": const Color(0xffF59E0B),
  },
];
  
  final OrderService orderService = OrderService();

Future<void> loadRecentOrderss() async {

  try {

    recentOrders = await orderService.getMyOrders();

    recentOrders.sort(
      (a, b) => b.createdAt.compareTo(a.createdAt),
    );

    setState(() {
      loadingOrders = false;
    });

  } catch (e) {

    print(e);

    setState(() {
      loadingOrders = false;
    });

  }

}
 
  Future<void> loadUser() async {
  final prefs = await SharedPreferences.getInstance();

  setState(() {
    fullName = prefs.getString("fullName") ?? "User";
  });
}

  Future<void> loadRecentOrder() async {

  try {

    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("accessToken") ?? "";

    final response = await http.get(

      Uri.parse("$baseUrl"),

      headers: {

        "Authorization": "Bearer $token",

        "Content-Type": "application/json",

      },
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      setState(() {

        if (data.isNotEmpty) {

          recentOrder = data.first;

        }

        isLoading = false;

      });

    }

  } catch (e) {

    setState(() {

      isLoading = false;

    });
  }
}

double getProgress(String status) {

  switch (status.toUpperCase()) {

    case "PENDING":
      return 0.15;

    case "CONFIRMED":
      return 0.30;

    case "OUT_FOR_PICKUP":
      return 0.50;

    case "PROCESSING":
      return 0.70;

    case "OUT_FOR_DELIVERY":
      return 0.90;

    case "DELIVERED":
      return 1.0;

    default:
      return 0.10;
  }
}

 Future<void> loadWeather() async {
  setState(() {
    isLoadingWeather = true;
  });

  try {
    weather = await WeatherService.getWeather();

    if (!mounted) return;

    setState(() {
      isLoadingWeather = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() {
      weather = null;
      isLoadingWeather = false;
    });

    debugPrint("Weather Error: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 47, 77, 86),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentColor,

        onPressed: () {},

        icon: const Icon(Icons.add),

        label: const Text("New Pickup"),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (value) {

          if (value == 1) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderScreen(),
      ),
    );

    return;
  }
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ServicesScreen()),
            );

            return;
          }
              if (value == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );

            return;
          }

          setState(() {
            selectedIndex = value;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: "Orders",
          ),

          NavigationDestination(
            icon: Icon(Icons.local_laundry_service),
            label: "Services",
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              //---------------- HEADER ----------------//
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                      Text(
  getGreeting(),
  style: GoogleFonts.poppins(
    color: Colors.grey,
    fontSize: 14,
  ),
),

                        const SizedBox(height: 5),

                        Text(
  fullName,
  style: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
),

                        const SizedBox(height: 8),

                      ],
                    ),
                  ),

               

                  const SizedBox(width: 12),

                 Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: CircleAvatar(
    radius: 28,
    backgroundColor: Colors.white,
    child: CircleAvatar(
      radius: 25,
      backgroundColor: Colors.teal,
      child: const Icon(
        Icons.person_rounded,
        color: Colors.white,
        size: 30,
      ),
    ),
  ),
),
                ],
              ),

              const SizedBox(height: 25),

              //---------------- WEATHER CARD ----------------//
              if (isLoadingWeather)
                Container(
                  height: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xff6D28D9), Color(0xff0F172A)],
                    ),
                  ),
                  child: const CircularProgressIndicator(color: Colors.white),
                )
              else if (weather != null)
                WeatherCard(weather: weather!)
              else
                Container(
                  height: 170,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xff6D28D9), Color(0xff0F172A)],
                    ),
                  ),
                  child: const Text(
                    "Unable to load weather",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              const SizedBox(height: 25),

             

              
              //---------------- ACTIVE ORDER ----------------//
              Text(
                "Active Order",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

             isLoading
    ? const Center(
        child: CircularProgressIndicator(),
      )

    : recentOrders.isEmpty

        ? Card(

            elevation: 4,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Padding(

              padding: EdgeInsets.all(25),

              child: Center(

                child: Text(
                  "No Recent Orders",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )

      : Builder(
  builder: (context) {

    final order = recentOrders.first;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.local_shipping),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        order.orderId,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        order.orderStatus,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: getProgress(order.orderStatus),
              minHeight: 8,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_searching),
                label: const Text("Track Order"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  },
),
              const SizedBox(height: 25),

             
              //---------------- SERVICES ----------------//
              Text(
                "Featured Services",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 15),

             SizedBox(
  height: 260,

  child: ListView.separated(

    scrollDirection: Axis.horizontal,

    itemCount: featuredServices.length,

    separatorBuilder: (_, __) =>
        const SizedBox(width: 15),

    itemBuilder: (context, index) {

      return SizedBox(
        width: 180,
        child: serviceCard(
          featuredServices[index],
        ),
      );

    },
  ),
),
              const SizedBox(height: 25),

              //---------------- RECENT ORDERS ----------------//
              Text(
                "Recent Orders",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

              loadingOrders
    ? const Center(
        child: CircularProgressIndicator(),
      )
    : recentOrders.isEmpty
        ? const Center(
            child: Text("No Orders Yet"),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentOrders.length,
            itemBuilder: (context, index) {

              final order = recentOrders[index];

              return recentOrderCard(order);

            },
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard(Map<String, dynamic> service) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ServiceDetailsScreen(
            serviceId: service["id"],
            serviceName: service["title"],
            color: service["color"],
            icon: service["icon"],
          ),
        ),
      );
    },
    child: Container(
      width: 440,
      margin: const EdgeInsets.only(right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            service["color"],
            service["color"].withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: service["color"].withOpacity(0.35),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                service["icon"],
                color: Colors.white,
                size: 34,
              ),
            ),

            const Spacer(),

            Text(
              service["title"],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              service["orders"],
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              height: 42,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Explore",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget recentOrderCard(OrderModel order) {
    return
   Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: ListTile(

    leading: const CircleAvatar(
      child: Icon(Icons.local_laundry_service),
    ),

    title: Text(order.orderId),

    subtitle: Text(order.selectedPlan),

    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(
          "₹${order.grandTotal}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          order.orderStatus,
          style: TextStyle(
            color: order.orderStatus == "DELIVERED"
                ? Colors.green
                : Colors.orange,
          ),
        ),

      ],
    ),
  ),
);
  }
}
