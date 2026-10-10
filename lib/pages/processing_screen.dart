import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/pickup_service.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() =>
      _ProcessingScreenState();
}

class _ProcessingScreenState
    extends State<ProcessingScreen> {

  final PickupService service = PickupService();

  List<OrderModel> orders = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {

    try {

      orders = await service.getProcessingOrders();

    } catch (e) {

      print(e);

    }

    loading = false;

    if (mounted) {
      setState(() {});
    }
  }

  //-------------------------------------------------------
  // INFO ROW
  //-------------------------------------------------------

  Widget infoRow(
      IconData icon,
      String value,
      ) {

    return Row(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Icon(
          icon,
          color: Colors.cyanAccent,
          size: 22,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xff233c94),

      appBar: AppBar(

        title: const Text(
          "Processing Orders",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),

        backgroundColor: Colors.indigo,

        centerTitle: true,

      ),

      body: loading

          ? const Center(
        child: CircularProgressIndicator(),
      )

          : orders.isEmpty

          ? const Center(
        child: Text(
          "No Processing Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      )

          : RefreshIndicator(

        onRefresh: loadOrders,

        child: ListView.builder(

          padding:
          const EdgeInsets.all(15),

          itemCount: orders.length,

          itemBuilder: (context, index) {

            final order = orders[index];

            return AnimatedContainer(

              duration:
              const Duration(milliseconds: 300),

              margin:
              const EdgeInsets.only(bottom: 20),

              decoration: BoxDecoration(

                color: const Color(0xff3b475b),

                borderRadius:
                BorderRadius.circular(18),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black
                        .withOpacity(.25),

                    blurRadius: 8,

                    offset: const Offset(0, 5),

                  )

                ],

              ),

              child: Padding(

                padding:
                const EdgeInsets.all(16),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    //----------------------------------------
                    // ORDER ID + STATUS
                    //----------------------------------------

                    Row(

                      children: [

                        Expanded(

                          child: Text(

                            order.orderId,

                            maxLines: 1,

                            overflow:
                            TextOverflow.ellipsis,

                            style:
                            const TextStyle(

                              color: Colors.white,

                              fontSize: 20,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),

                        ),

                        Container(

                          padding:
                          const EdgeInsets.symmetric(

                            horizontal: 14,

                            vertical: 6,

                          ),

                          decoration:
                          BoxDecoration(

                            color: order.orderStatus ==
                                "PICKED_UP"

                                ? Colors.orange.shade100

                                : Colors.green.shade100,

                            borderRadius:
                            BorderRadius.circular(20),

                          ),

                          child: Text(

                            order.orderStatus,

                            style: TextStyle(

                              color:
                              order.orderStatus ==
                                  "PICKED_UP"

                                  ? Colors.orange

                                  : Colors.green,

                              fontWeight:
                              FontWeight.bold,

                            ),

                          ),

                        ),

                      ],

                    ),

                    const Divider(
                      height: 28,
                      color: Colors.white24,
                    ),

                    infoRow(
                      Icons.person,
                      order.customerName,
                    ),

                    const SizedBox(height: 10),

                    infoRow(
                      Icons.phone,
                      order.mobileNumber,
                    ),

                    const SizedBox(height: 10),

                    infoRow(
                      Icons.location_on,
                      order.pickupAddress,
                    ),

                    const SizedBox(height: 10),

                    infoRow(
                      Icons.local_laundry_service,
                      order.selectedPlan,
                    ),

                    const SizedBox(height: 10),

                    infoRow(
                      Icons.currency_rupee,
                      "₹${order.grandTotal}",
                    ),

                    const SizedBox(height: 10),

                    infoRow(
                      Icons.info,
                      order.orderStatus,
                    ),

                    const SizedBox(height: 25),

                    //----------------------------------------
                    // BUTTONS
                    //----------------------------------------

                    Row(

                      children: [

                        Expanded(

                          child:
                          ElevatedButton.icon(

                            icon: const Icon(
                              Icons.sync,
                            ),

                            label: const Text(
                              "Processing",
                            ),

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              Colors.orange,

                              foregroundColor:
                              Colors.white,

                              minimumSize:
                              const Size.fromHeight(50),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(12),

                              ),

                            ),

                            onPressed:

                            order.orderStatus ==
                                "PICKED_UP"

                                ? () async {

                              await service.processing(
                                  order.orderId);

                              await loadOrders();

                              ScaffoldMessenger.of(
                                  context)
                                  .showSnackBar(

                                const SnackBar(

                                  content: Text(
                                      "Order moved to Processing"),

                                ),

                              );

                            }

                                : null,

                          ),

                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child:
                          ElevatedButton.icon(

                            icon: const Icon(
                              Icons.local_shipping,
                            ),

                            label: const Text(
                              "Ready",
                            ),

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              Colors.green,

                              foregroundColor:
                              Colors.white,

                              minimumSize:
                              const Size.fromHeight(50),

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(12),

                              ),

                            ),

                            onPressed:

                            order.orderStatus ==
                                "PROCESSING"

                                ? () async {

                              await service.readyForDelivery(
                                  order.orderId);

                              await loadOrders();

                              ScaffoldMessenger.of(
                                  context)
                                  .showSnackBar(

                                const SnackBar(

                                  content: Text(
                                      "Order Ready For Delivery"),

                                ),

                              );

                            }

                                : null,

                          ),

                        ),

                      ],

                    )

                  ],

                ),

              ),

            );

          },

        ),

      ),

    );

  }

}