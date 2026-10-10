import 'dart:async';

import 'package:flutter/material.dart';

import '../models/delivery_partner_model.dart';
import '../services/admin_service.dart';

class DeliveryPartnerScreen extends StatefulWidget {
  const DeliveryPartnerScreen({super.key});

  @override
  State<DeliveryPartnerScreen> createState() =>
      _DeliveryPartnerScreenState();
}

class _DeliveryPartnerScreenState
    extends State<DeliveryPartnerScreen>
    with SingleTickerProviderStateMixin {

  //-------------------------------------------------------
  // SERVICE
  //-------------------------------------------------------

  final AdminService adminService = AdminService();

  //-------------------------------------------------------
  // CONTROLLER
  //-------------------------------------------------------

  final TextEditingController searchController =
      TextEditingController();

  //-------------------------------------------------------
  // ANIMATION
  //-------------------------------------------------------

  late AnimationController animationController;

  late Animation<double> fadeAnimation;

  //-------------------------------------------------------
  // DATA
  //-------------------------------------------------------

  bool loading = true;

  List<DeliveryPartnerModel> partners = [];

  List<DeliveryPartnerModel> filteredPartners = [];

  //-------------------------------------------------------
  // INIT
  //-------------------------------------------------------

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    fadeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    loadPartners();

    searchController.addListener(searchPartner);
  }

  //-------------------------------------------------------
  // LOAD DATA
  //-------------------------------------------------------

  Future<void> loadPartners() async {

    setState(() {
      loading = true;
    });

    try {

      partners =
          await adminService.getDeliveryPartners();

      filteredPartners = partners;

      animationController.forward();

    } catch (e) {

      debugPrint(e.toString());

    }

    setState(() {
      loading = false;
    });
  }

  //-------------------------------------------------------
  // SEARCH
  //-------------------------------------------------------

  void searchPartner() {

    final query =
        searchController.text.toLowerCase();

    if (query.isEmpty) {

      setState(() {
        filteredPartners = partners;
      });

      return;
    }

    setState(() {

      filteredPartners =
          partners.where((partner) {

        return partner.fullName
                .toLowerCase()
                .contains(query) ||

            partner.mobile
                .contains(query);

      }).toList();

    });
  }

  //-------------------------------------------------------
  // MARK PAID
  //-------------------------------------------------------

  Future<void> markAsPaid(int partnerId) async {

    try {

      await adminService.markPartnerPaid(partnerId);

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text(
            "Payment Updated Successfully",
          ),
        ),

      );

      loadPartners();

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(e.toString()),
        ),

      );

    }
  }

  //-------------------------------------------------------
  // DISPOSE
  //-------------------------------------------------------

  @override
  void dispose() {

    animationController.dispose();

    searchController.dispose();

    super.dispose();

  }

  //-------------------------------------------------------
  // UI
  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.indigo,

        foregroundColor: Colors.white,

        centerTitle: true,

        title: const Text(

          "Delivery Partners",

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),

        ),

      ),

      body: RefreshIndicator(

        onRefresh: loadPartners,

        child: Column(

          children: [

            //---------------------------------------------------
            // SEARCH BAR
            //---------------------------------------------------

            Padding(

              padding: const EdgeInsets.all(16),

              child: TextField(

                controller: searchController,

                decoration: InputDecoration(

                  hintText: "Search Partner",

                  prefixIcon:
                      const Icon(Icons.search),

                  filled: true,

                  fillColor: Colors.white,

                  border: OutlineInputBorder(

                    borderRadius:
                        BorderRadius.circular(18),

                    borderSide: BorderSide.none,

                  ),

                ),

              ),

            ),

            //---------------------------------------------------
            // BODY
            //---------------------------------------------------

            Expanded(

              child: loading

                  ? const Center(

                      child:
                          CircularProgressIndicator(),

                    )

                  : filteredPartners.isEmpty

                      ? const Center(

                          child: Column(

                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Icon(

                                Icons.person_off,

                                size: 70,

                                color: Colors.grey,

                              ),

                              SizedBox(height: 15),

                              Text(

                                "No Delivery Partners Found",

                                style: TextStyle(
                                  fontSize: 18,
                                ),

                              ),

                            ],

                          ),

                        )

                      : FadeTransition(

                          opacity: fadeAnimation,

                          child: ListView.builder(

                            padding:
                                const EdgeInsets.only(
                              bottom: 20,
                            ),

                            itemCount:
                                filteredPartners.length,

                            itemBuilder:
                                (context, index) {

                              final partner =
                                  filteredPartners[index];

                              // Card UI comes in Part 2
                              return AnimatedContainer(
  duration: Duration(
    milliseconds: 350 + (index * 100),
  ),
  curve: Curves.easeInOut,
  margin: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  ),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(.08),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: Padding(
    padding: const EdgeInsets.all(18),
    child: Column(
      children: [

        //------------------------------------------
        // HEADER
        //------------------------------------------

        Row(
          children: [

            Hero(
              tag: partner.id,
              child: CircleAvatar(
                radius: 30,
                backgroundColor:
                    Colors.indigo.shade100,
                child: Text(
                  partner.fullName
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  Text(
                    partner.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [

                      const Icon(
                        Icons.phone,
                        size: 18,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        partner.mobile,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

          ],
        ),

        const SizedBox(height: 20),

        //------------------------------------------
        // STATISTICS
        //------------------------------------------

        Row(
          children: [

            Expanded(
              child: statCard(
                "Completed",
                partner.completedOrders.toString(),
                Icons.check_circle,
                Colors.green,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: statCard(
                "Pending",
                "₹${partner.pendingEarnings}",
                Icons.account_balance_wallet,
                Colors.orange,
              ),
            ),

          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [

            Expanded(
              child: statCard(
                "Total Earned",
                "₹${partner.totalEarnings}",
                Icons.currency_rupee,
                Colors.indigo,
              ),
            ),

          ],
        ),

        const SizedBox(height: 22),

        //------------------------------------------
        // BUTTON
        //------------------------------------------

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.payments),
            label: const Text(
              "Mark as Paid",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(16),
              ),
            ),
            onPressed: partner.pendingEarnings == 0
                ? null
                : () {

                    showDialog(

                      context: context,

                      builder: (_) {

                        return AlertDialog(

                          title: const Text(
                            "Confirm Payment",
                          ),

                          content: Text(
                            "Pay ₹${partner.pendingEarnings} to ${partner.fullName} ?",
                          ),

                          actions: [

                            TextButton(

                              onPressed: () {

                                Navigator.pop(context);

                              },

                              child: const Text(
                                "Cancel",
                              ),

                            ),

                            ElevatedButton(

                              onPressed: () async {

                                Navigator.pop(context);

                                await markAsPaid(
                                  partner.id,
                                );

                              },

                              child: const Text(
                                "Confirm",
                              ),

                            ),

                          ],

                        );

                      },

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

                        ),

            ),

          ],

        ),

      ),

    );

  }

  Widget statCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 18,
    ),
    decoration: BoxDecoration(
      color: color.withOpacity(.08),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [

        Icon(
          icon,
          color: color,
          size: 30,
        ),

        const SizedBox(height: 10),

        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),

      ],
    ),
  );
}

}

