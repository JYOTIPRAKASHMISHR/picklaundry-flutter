import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';


class OrdersScreen extends StatefulWidget {

  const OrdersScreen({
    super.key,
  });


  @override
  State<OrdersScreen> createState() => _OrdersScreenState();

}



class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {



  final OrderService orderService = OrderService();



  List<OrderModel> orders = [];

  List<OrderModel> filteredOrders = [];



  bool loading = true;



  final TextEditingController searchController =
      TextEditingController();



  late AnimationController animationController;



  @override
  void initState() {

    super.initState();


    animationController =
        AnimationController(

      vsync: this,

      duration:
      const Duration(milliseconds: 800),

    );


    loadOrders();

  }





  //=========================================
  // LOAD ALL ORDERS
  //=========================================


  Future<void> loadOrders() async {


    try {


      orders =
          await orderService.getAllOrders();



      filteredOrders =
          orders;



      animationController.forward();



      setState(() {

        loading = false;

      });



    } catch(e){


      print(
          "ORDER ERROR : $e"
      );


      setState(() {

        loading = false;

      });


    }


  }







  //=========================================
  // SEARCH ORDERS
  //=========================================


  void searchOrder(String value){


    if(value.isEmpty){


      setState(() {

        filteredOrders = orders;

      });


      return;

    }




    setState(() {


      filteredOrders =
          orders.where((order){


            return order.orderId
                .toLowerCase()
                .contains(
                value.toLowerCase()
            )

                ||

                order.customerName
                    .toLowerCase()
                    .contains(
                    value.toLowerCase()
                );


          }).toList();



    });


  }







  @override
  void dispose(){


    animationController.dispose();


    searchController.dispose();


    super.dispose();

  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xff081120),




      body: SafeArea(


        child: Column(

          children: [




            //===============================
            // APP BAR
            //===============================


            Container(

              padding:
              const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  25
              ),



              decoration:
              const BoxDecoration(

                gradient:
                LinearGradient(

                  colors: [

                    Color(0xff0F2027),

                    Color(0xff203A43),

                    Color(0xff2C5364),

                  ],

                  begin:
                  Alignment.topLeft,

                  end:
                  Alignment.bottomRight,

                ),


                borderRadius:
                BorderRadius.only(

                  bottomLeft:
                  Radius.circular(35),

                  bottomRight:
                  Radius.circular(35),

                ),


              ),




              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [



                  Row(

                    children: [


                      IconButton(

                        icon:
                        const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),


                        onPressed: (){

                          Navigator.pop(context);

                        },

                      ),




                      Text(

                        "All Orders",

                        style:
                        GoogleFonts.poppins(

                          color:
                          Colors.white,

                          fontSize:
                          26,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),



                    ],

                  ),




                  const SizedBox(height:15),





                  //=============================
                  // SEARCH BOX
                  //=============================



                  Container(


                    decoration:
                    BoxDecoration(

                      color:
                      Colors.white
                          .withOpacity(.12),


                      borderRadius:
                      BorderRadius.circular(18),


                    ),



                    child:
                    TextField(


                      controller:
                      searchController,


                      onChanged:
                      searchOrder,



                      style:
                      const TextStyle(
                          color: Colors.white
                      ),



                      decoration:
                      InputDecoration(


                        hintText:
                        "Search Order ID or Customer",



                        hintStyle:
                        const TextStyle(

                          color:
                          Colors.white70,

                        ),



                        prefixIcon:
                        const Icon(

                          Icons.search,

                          color:
                          Colors.white,

                        ),



                        border:
                        InputBorder.none,



                        suffixIcon:
                        IconButton(

                          icon:
                          const Icon(

                            Icons.refresh,

                            color:
                            Colors.white,

                          ),



                          onPressed:
                          () async {


                            setState(() {

                              loading=true;

                            });


                            await loadOrders();


                          },


                        ),


                      ),



                    ),


                  ),


                ],

              ),


            ),






            const SizedBox(height:15),






            // Remaining order list will come in PART 2



            Expanded(

              child:


              loading


                  ?


              const Center(

                child:
                CircularProgressIndicator(

                  color:
                  Colors.teal,

                ),

              )



                  :


              filteredOrders.isEmpty


                  ?


              Center(

                child:
                Text(

                  "No Orders Found",

                  style:
                  GoogleFonts.poppins(

                    color:
                    Colors.white,

                    fontSize:
                    18,

                  ),

                ),

              )



                  :


              RefreshIndicator(
  color: Colors.teal,

  onRefresh: () async {
    await loadOrders();
  },

  child: ListView.builder(

    padding: const EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: 20,
    ),

    itemCount: filteredOrders.length,

    itemBuilder: (context, index) {

      final order = filteredOrders[index];

      return AnimatedBuilder(

        animation: animationController,

        builder: (context, child) {

          return Transform.translate(

            offset: Offset(
              0,
              60 * (1 - animationController.value),
            ),

            child: Opacity(
              opacity: animationController.value,
              child: child,
            ),
          );
        },

        child: Container(

          margin: const EdgeInsets.only(bottom: 18),

          decoration: BoxDecoration(

            color: const Color(0xff162033),

            borderRadius: BorderRadius.circular(24),

            boxShadow: [

              BoxShadow(
                color: Colors.black.withOpacity(.30),
                blurRadius: 18,
                offset: const Offset(0, 8),
              )

            ],

          ),

          child: Padding(

            padding: const EdgeInsets.all(18),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                //--------------------------------------------------
                // ORDER ID + STATUS
                //--------------------------------------------------

                Row(

                  children: [

                    Expanded(

                      child: Text(

                        order.orderId,

                        style: GoogleFonts.poppins(

                          color: Colors.white,

                          fontSize: 18,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                    ),

                    Container(

                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(

                        color: getStatusColor(order.orderStatus)
                            .withOpacity(.18),

                        borderRadius:
                            BorderRadius.circular(30),

                      ),

                      child: Text(

                        order.orderStatus,

                        style: GoogleFonts.poppins(

                          color:
                              getStatusColor(order.orderStatus),

                          fontWeight: FontWeight.bold,

                          fontSize: 12,

                        ),

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 15),

                const Divider(color: Colors.white24),

                const SizedBox(height: 10),

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
                  Icons.inventory_2,
                  "${order.totalItems} Items",
                ),

                const SizedBox(height: 10),

                infoRow(
                  Icons.currency_rupee,
                  "₹${order.grandTotal}",
                ),

                const SizedBox(height: 10),

                infoRow(
                  Icons.payment,
                  order.paymentMethod,
                ),

                const SizedBox(height: 10),

                infoRow(
                  Icons.account_balance_wallet,
                  order.paymentStatus,
                ),

                const SizedBox(height: 18),

                Row(

                  children: [

                    Expanded(

                      child: Container(

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(

                          color: Colors.teal.withOpacity(.12),

                          borderRadius:
                              BorderRadius.circular(16),

                        ),

                        child: Column(

                          children: [

                            const Icon(
                              Icons.calendar_month,
                              color: Colors.teal,
                            ),

                            const SizedBox(height: 5),

                            // Text(

                            //   order.pickupDate,

                            //   textAlign: TextAlign.center,

                            //   style: GoogleFonts.poppins(

                            //     color: Colors.white,

                            //     fontSize: 12,

                            //   ),

                            // ),

                          ],

                        ),

                      ),

                    ),

                    const SizedBox(width: 15),

                    Expanded(

                      child: Container(

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(

                          color: Colors.deepPurple
                              .withOpacity(.15),

                          borderRadius:
                              BorderRadius.circular(16),

                        ),

                        child: Column(

                          children: [

                            const Icon(
                              Icons.local_shipping,
                              color: Colors.deepPurpleAccent,
                            ),

                            const SizedBox(height: 5),

                            // Text(

                            //   order.deliveryDate,

                            //   textAlign: TextAlign.center,

                            //   style: GoogleFonts.poppins(

                            //     color: Colors.white,

                            //     fontSize: 12,

                            //   ),

                            // ),

                          ],

                        ),

                      ),

                    ),

                  ],

                ),

              ],

            ),

          ),

        ),

      );

    },

  ),

)


            )




          ],

        ),


      ),


    );


  }

  //===========================================
// INFO ROW
//===========================================

Widget infoRow(
  IconData icon,
  String value,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Icon(
        icon,
        color: Colors.tealAccent,
        size: 20,
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Text(
          value.isEmpty ? "-" : value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),

    ],
  );
}



//===========================================
// STATUS COLOR
//===========================================

Color getStatusColor(String status) {

  switch (status) {

    case "PICKUP_PENDING":
      return Colors.orange;

    case "OUT_FOR_PICKUP":
      return Colors.deepOrange;

    case "PICKED_UP":
      return Colors.blue;

    case "PROCESSING":
      return Colors.purple;

    case "READY_FOR_DELIVERY":
      return Colors.indigo;

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


}