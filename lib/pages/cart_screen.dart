import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:picklaundry/pages/checkout_screen.dart';
import 'package:picklaundry/services/order_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/cart_provider.dart';
import '../screen/address_picker_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String pickupAddress = "";
  String paymentMethod = "CASH_ON_DELIVERY";
  String selectedPlan = "";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    if (cart.items.isNotEmpty) {
  selectedPlan = cart.items.first.plan.toUpperCase();
}

    return Scaffold(
      backgroundColor: const Color(0xff0F172A),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff0F172A),

        title: const Text(
          "My Cart",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: cart.items.isEmpty
          ? _emptyCart()
          : Column(
              children: [

                //----------------------------------
                // CART ITEMS
                //----------------------------------

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: cart.items.length,

                    itemBuilder: (context, index) {
                      final item = cart.items[index];

                      return TweenAnimationBuilder(
                        duration: Duration(
                          milliseconds:
                              300 + (index * 120),
                        ),

                        tween:
                            Tween<double>(begin: 0, end: 1),

                        builder:
                            (context, value, child) {
                          return Transform.translate(
                            offset:
                                Offset(0, 50 * (1 - value)),

                            child: Opacity(
                              opacity: value,

                              child: Container(
                                margin: const EdgeInsets.only(
                                  bottom: 16,
                                ),

                                padding:
                                    const EdgeInsets.all(18),

                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xff1E293B),

                                  borderRadius:
                                      BorderRadius.circular(
                                          24),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.15),
                                      blurRadius: 15,
                                    ),
                                  ],
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    //----------------------------------
                                    // SERVICE NAME
                                    //----------------------------------

                                    Text(
                                      item.serviceName,

                                      style: const TextStyle(
                                        color:
                                            Colors.white70,
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    //----------------------------------
                                    // ITEM NAME
                                    //----------------------------------

                                   Text(
  item.itemName,

  style: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 10),

Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),

  decoration: BoxDecoration(
    color: item.plan == "Base"
        ? Colors.blue.withOpacity(.2)
        : item.plan == "Express"
            ? Colors.orange.withOpacity(.2)
            : Colors.purple.withOpacity(.2),

    borderRadius: BorderRadius.circular(20),
  ),

  child: Text(
    item.plan,

    style: TextStyle(
      color: item.plan == "Base"
          ? Colors.blue
          : item.plan == "Express"
              ? Colors.orange
              : Colors.purple,

      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 15),

                                    //----------------------------------
                                    // PRICE + QUANTITY
                                    //----------------------------------

                                    Row(
                                      children: [

                                        Text(
                                          "₹${item.price.toStringAsFixed(0)}",

                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.green,
                                            fontSize: 22,
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        const Spacer(),

                                        quantityButton(
                                          icon:
                                              Icons.remove,
                                          onTap: () {
                                            cart
                                                .decreaseQuantity(
                                              item.itemId,
                                            );
                                          },
                                        ),

                                        Padding(
                                          padding:
                                              const EdgeInsets
                                                  .symmetric(
                                            horizontal: 15,
                                          ),

                                          child: Text(
                                            item.quantity
                                                .toString(),

                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white,
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),

                                        quantityButton(
                                          icon: Icons.add,
                                          onTap: () {
                                            cart
                                                .increaseQuantity(
                                              item.itemId,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                //----------------------------------
                // BOTTOM TOTAL SECTION
                //----------------------------------

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: const BoxDecoration(
                    color: Color(0xff1E293B),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),

                  child: Column(
                    children: [

                      Row(
                        children: [

                          const Text(
                            "Total Amount",

                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            "₹${cart.totalPrice.toStringAsFixed(2)}",

                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.location_on),
    label: Text(
      pickupAddress.isEmpty
          ? "Select Pickup Address"
          : "Change Pickup Address",
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
    ),
    onPressed: () async {

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddressPickerScreen(),
        ),
      );

      if (result != null) {

        setState(() {

          pickupAddress = result["address"];

        });
      }
    },
  ),
),

if (pickupAddress.isNotEmpty)
  Container(
    width: double.infinity,
    margin: const EdgeInsets.only(top: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      pickupAddress,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  ),

  const SizedBox(height: 20),

Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Payment Method",
    style: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
),

const SizedBox(height: 10),

Container(
  decoration: BoxDecoration(
    color: const Color(0xff111827),
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    children: [

      RadioListTile<String>(
        value: "CASH_ON_DELIVERY",
        groupValue: paymentMethod,
        activeColor: Colors.green,
        title: const Text(
          "Cash On Delivery",
          style: TextStyle(color: Colors.white),
        ),
        subtitle: const Text(
          "Pay when your laundry is delivered",
          style: TextStyle(color: Colors.white54),
        ),
        onChanged: (value) {
          setState(() {
            paymentMethod = value!;
          });
        },
      ),

      const Divider(height: 1),

      RadioListTile<String>(
        value: "ONLINE_PAYMENT",
        groupValue: paymentMethod,
        activeColor: Colors.blue,
        enabled: false,
        title: const Text(
          "Online Payment",
          style: TextStyle(color: Colors.grey),
        ),
        subtitle: const Text(
          "Coming Soon",
          style: TextStyle(color: Colors.grey),
        ),
        onChanged: null,
      ),
    ],
  ),
),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton.icon(
                       onPressed: pickupAddress.isEmpty
                            ? null
                            : () async {
  try {

    // Get JWT Token
    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("accessToken") ?? "";
print("================================");
print("TOKEN FROM SHAREDPREFERENCES");
print(token);

print("ROLE");
print(prefs.getString("role"));

print("================================");
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login again."),
        ),
      );
      return;
    }

    // Check Cart
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cart is Empty"),
        ),
      );
      return;
    }

    
  //  if (pickupAddress.isEmpty) {

  // ScaffoldMessenger.of(context).showSnackBar(
  //   const SnackBar(
  //     content: Text("Please select pickup address"),
  //   ),
  // );

//   return;
// }
    String instruction = "Handle Carefully";

    final orderBody = {
      "selectedPlan": selectedPlan,
      "pickupAddress": pickupAddress,
      "paymentMethod": paymentMethod,
      "specialInstruction": instruction,
      "pickupDate": DateTime.now().toIso8601String(),
      "items": cart.items.map((item) {
        return {
          "serviceId": item.serviceId,
          "serviceItemId": item.itemId,
          "quantity": item.quantity,
        };
      }).toList(),
    };

    print("========== TOKEN ==========");
    print(token);

    print("========== ORDER BODY ==========");
    print(jsonEncode(orderBody));

    final response =
        await OrderService().placeOrder(
      token,
      orderBody,
    );

    print("========== RESPONSE ==========");
    print(response);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          order: response,
        ),
      ),
    );

  } catch (e) {

    print("ORDER ERROR");
    print(e);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  }
},
                          icon:
                              const Icon(Icons.payment),

                          label: Text(
                                pickupAddress.isEmpty
                                    ? "Select Address First"
                                    : "Proceed To Checkout",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(
                                    0xff2563EB),

                            foregroundColor:
                                Colors.white,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  //--------------------------------------
  // EMPTY CART
  //--------------------------------------

  Widget _emptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: const [

          Icon(
            Icons.shopping_cart_outlined,
            size: 120,
            color: Colors.white24,
          ),

          SizedBox(height: 20),

          Text(
            "Your Cart is Empty",

            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 10),

          Text(
            "Add some laundry items",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }

  //--------------------------------------
  // QUANTITY BUTTON
  //--------------------------------------

  Widget quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Container(
        width: 38,
        height: 38,

        decoration: BoxDecoration(
          color: const Color(0xff2563EB),

          borderRadius:
              BorderRadius.circular(12),
        ),

        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}