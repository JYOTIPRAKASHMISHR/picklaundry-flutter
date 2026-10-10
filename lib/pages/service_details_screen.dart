import 'package:flutter/material.dart';
import '../models/service_item.dart';
import '../services/laundry_service.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';
import '../models/cart_item.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final int serviceId;
  final String serviceName;
  final Color color;
  final IconData icon;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.color,
    required this.icon
  });

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen>
    with SingleTickerProviderStateMixin {
      String selectedPlan = "Base";
  List<ServiceItem> items = [];

  bool isLoading = true;
  String? error;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    loadItems();
  }

  Future<void> loadItems() async {
    try {
      final data = await ApiService.getItems(widget.serviceId);

      setState(() {
        items = data;
        isLoading = false;
      });

      _controller.forward();
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  

 Widget priceBox(
  String title,
  double price,
  bool selected,
) {
  return Container(
    padding: const EdgeInsets.all(10),

    decoration: BoxDecoration(
      color: selected
          ? widget.color
          : Colors.grey.shade200,

      borderRadius:
          BorderRadius.circular(12),
    ),

    child: Column(
      children: [

        Text(
          title,

          style: TextStyle(
            color:
                selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          "₹${price.toStringAsFixed(0)}",

          style: TextStyle(
            color:
                selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
  Widget buildPlanButton(String plan) {

  bool selected = selectedPlan == plan;

  return Expanded(
    child: GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = plan;
        });
      },

      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? widget.color
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(12),
        ),

        child: Center(
          child: Text(
            plan,

            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black,

              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget itemCard(ServiceItem item, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),

      tween: Tween(begin: 0, end: 1),

      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),

          child: Opacity(
            opacity: value,

            child: Container(
              margin: const EdgeInsets.only(bottom: 18),

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: const Color(0xff1E293B),

                borderRadius: BorderRadius.circular(24),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.itemName,

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: item.active
                              ? Colors.green.shade100
                              : Colors.red.shade100,

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          item.active ? "Active" : "Inactive",

                          style: TextStyle(
                            color: item.active ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                 Row(
  children: [

    Expanded(
      child: priceBox(
        "Base",
        item.basePrice,
        selectedPlan == "Base",
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: priceBox(
        "Express",
        item.expressPrice,
        selectedPlan == "Express",
      ),
    ),

    const SizedBox(width: 10),

    Expanded(
      child: priceBox(
        "Premium",
        item.premiumPrice,
        selectedPlan == "Premium",
      ),
    ),
  ],
),
                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "GST : 0%",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,

                    child: ElevatedButton.icon(
                    onPressed: () {

  Provider.of<CartProvider>(
    context,
    listen: false,
  ).addToCart(

    CartItem(
      serviceId: widget.serviceId,

      serviceName: widget.serviceName,

      itemId: item.id,

      itemName: item.itemName,

      price: selectedPlan == "Base"
          ? item.basePrice
          : selectedPlan == "Express"
              ? item.expressPrice
              : item.premiumPrice,
              plan: selectedPlan, 
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        "${item.itemName} added ($selectedPlan)",
      ),
    ),
  );
},
                      icon: const Icon(Icons.shopping_cart),

                      label: const Text("Add To Cart"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2563EB),

                        foregroundColor: const Color.fromARGB(
                          255,
                          219,
                          215,
                          215,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error!)),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 63, 139, 215),

      body: CustomScrollView(
        slivers: [
         SliverAppBar(
  expandedHeight: 220,
  pinned: true,
  backgroundColor: widget.color,

  actions: [

    Consumer<CartProvider>(
      builder: (_, cart, __) {
        return Stack(
          children: [

            IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CartScreen(),
                  ),
                );
              },
            ),

            if (cart.totalItems > 0)
              Positioned(
                right: 5,
                top: 5,

                child: Container(
                  padding: const EdgeInsets.all(4),

                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),

                  child: Text(
                    cart.totalItems.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    ),
  ],

  flexibleSpace: FlexibleSpaceBar(
    title: Text(widget.serviceName),

    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.color,
            widget.color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),

      child: Center(
        child: Hero(
          tag: widget.serviceId,
          child: Icon(
            widget.icon,
            size: 120,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ),
),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                 Row(
  children: [
    Expanded(
      child: Text(
        widget.serviceName,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.shopping_cart_outlined,
        color: Colors.white,
        size: 26,
      ),
    ),
  ],
),

                  const SizedBox(height: 8),

                  Text(
                    "${items.length} Items Available",

                    style: TextStyle(color: const Color.fromARGB(255, 179, 23, 77)),
                  ),

                  const SizedBox(height: 20),

const Text(
  "Delivery Timeline",
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
),

const SizedBox(height: 12),

Row(
  children: const [
    Icon(Icons.check_circle, color: Colors.green),
    SizedBox(width: 10),
    Expanded(
      child: Text(
        "Base Service → Delivery within 48 Hours",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 10),

Row(
  children: const [
    Icon(Icons.flash_on, color: Colors.orange),
    SizedBox(width: 10),
    Expanded(
      child: Text(
        "Express Service → Delivery within 24 Hours",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 10),

Row(
  children: const [
    Icon(Icons.workspace_premium, color: Colors.purple),
    SizedBox(width: 10),
    Expanded(
      child: Text(
        "Premium Service → Delivery within 8 Hours",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  ],
),

const SizedBox(height: 25),
Container(
  height: 50,

  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
  ),

  child: Row(
    children: [

      buildPlanButton("Base"),

      buildPlanButton("Express"),

      buildPlanButton("Premium"),
    ],
  ),
),

const SizedBox(height: 20),

                  ListView.builder(
                    shrinkWrap: true,

                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: items.length,

                    itemBuilder: (context, index) {
                      return itemCard(items[index], index);
                    },
                  ),
                ],
              ),
            ),
          ),
       
        ],
      ),
    );
 
  }
}
