import 'package:flutter/material.dart';
import 'service_details_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() =>
      _ServicesScreenState();
}

class _ServicesScreenState
    extends State<ServicesScreen>
    with TickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1200,
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

 final List<Map<String, dynamic>> services = [

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
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color.fromARGB(255, 45, 64, 83),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              //---------------------------------
              // Header
              //---------------------------------

              Container(

                padding:
                    const EdgeInsets.all(25),

                decoration: BoxDecoration(

                  borderRadius:
                      BorderRadius.circular(
                          30),

                  gradient:
                      const LinearGradient(

                    colors: [

                      Color(0xff6366F1),
                      Color(0xff8B5CF6),

                    ],
                  ),
                ),

                child: Row(

                  children: [

                    Expanded(

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: const [

                          Text(
                            "PickLaundry",
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 10),

                          Text(
                            "Choose your preferred laundry service",
                            style: TextStyle(
                              color:
                                  Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons.local_laundry_service,
                      size: 60,
                      color: Colors.white,
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              //---------------------------------
              // Search Bar
              //---------------------------------

              Container(

                decoration: BoxDecoration(

                  color: const Color.fromARGB(255, 78, 145, 99),

                  borderRadius:
                      BorderRadius.circular(
                          18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                    )
                  ],
                ),

                child: const TextField(

                  decoration: InputDecoration(

                    border: InputBorder.none,

                    prefixIcon:
                        Icon(Icons.search),

                    hintText:
                        "Search services",

                    contentPadding:
                        EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //---------------------------------
              // Statistics
              //---------------------------------

              Row(

                children: [

                  Expanded(
                    child: statCard(
                      "12K+",
                      "Orders",
                      Icons.shopping_bag,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: statCard(
                      "4.9",
                      "Rating",
                      Icons.star,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: statCard(
                      "48Hr",
                      "Delivery",
                      Icons.local_shipping,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Available Services",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              //---------------------------------
              // Service Grid
              //---------------------------------

              GridView.builder(
  shrinkWrap: true,
  physics:
      const NeverScrollableScrollPhysics(),

  itemCount: services.length,

  gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(

    crossAxisCount: 2,

    crossAxisSpacing: 16,

    mainAxisSpacing: 16,

    childAspectRatio: 0.75,
  ),

  itemBuilder: (context, index) {

    return serviceCard(
      services[index],
    );
  },
)
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------
  // Service Card
  //---------------------------------

 Widget serviceCard(
  Map<String, dynamic> service,
) {

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

  child: TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 700),
    tween: Tween(begin: 0, end: 1),
    builder: (context, value, child) {
      return Transform.scale(
        scale: value,
        child: Opacity(
          opacity: value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),

              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  service["color"],
                  service["color"].withOpacity(0.75),
                ],
              ),

              boxShadow: [
                BoxShadow(
                  color: service["color"].withOpacity(0.35),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  //--------------------------------
                  // ICON
                  //--------------------------------

                  Container(
                    padding:
                        const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.18),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      service["icon"],
                      color: Colors.white,
                      size: 32,
                    ),
                  ),

                 const SizedBox(height: 10),

Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Text(
        service["title"],
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),

      const SizedBox(height: 4),

      Text(
        service["orders"],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),

      const Spacer(),

      Container(
        height: 38,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Explore",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  ),
),
                ],
              ),
            ),
          ),
        ),
      );
    },
  ));
}
  
  //---------------------------------
  // Statistics Card
  //---------------------------------

  Widget statCard(
    String value,
    String title,
    IconData icon,
  ) {
    return Container(

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: const Color.fromARGB(255, 72, 141, 125),

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: const [

          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),

      child: Column(

        children: [

          Icon(
            icon,
            color:
                const Color(0xff6366F1),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 18,
            ),
          ),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}