import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String fullName = "";
  String mobile = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  //-------------------------------------------------------
  // LOAD PROFILE
  //-------------------------------------------------------

  Future<void> loadProfile() async {

    final prefs = await SharedPreferences.getInstance();

    setState(() {
      fullName = prefs.getString("fullName") ?? "Customer";
      mobile = prefs.getString("mobile") ?? "";
      email = prefs.getString("email") ?? "";
    });
  }

  //-------------------------------------------------------
  // BUILD
  //-------------------------------------------------------

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF4F7FC),

      appBar: AppBar(

        elevation: 0,

        backgroundColor: Colors.blue,

        centerTitle: true,

        title: const Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding: const EdgeInsets.all(18),

          child: Column(

            children: [

              const SizedBox(height: 20),

              //----------------------------------------------------
              // PROFILE CARD
              //----------------------------------------------------

              Container(

                width: double.infinity,

                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(25),

                  gradient: const LinearGradient(

                    colors: [

                      Color(0xff2196F3),

                      Color(0xff64B5F6),

                    ],

                    begin: Alignment.topLeft,

                    end: Alignment.bottomRight,

                  ),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.blue.withOpacity(.25),

                      blurRadius: 20,

                      offset: const Offset(0, 8),

                    )

                  ],

                ),

                child: Column(

                  children: [

                    Hero(

                      tag: "profile",

                      child: CircleAvatar(

                        radius: 55,

                        backgroundColor: Colors.white,

                        child: Icon(

                          Icons.person,

                          size: 65,

                          color: Colors.blue.shade700,

                        ),

                      ),

                    ),

                    const SizedBox(height: 18),

                    Text(

                      fullName,

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 8),

                    Text(

                      mobile,

                      style: const TextStyle(

                        color: Colors.white70,

                        fontSize: 16,

                      ),

                    ),

                    const SizedBox(height: 5),

                    Text(

                      email,

                      style: const TextStyle(

                        color: Colors.white70,

                        fontSize: 16,

                      ),

                    ),

                  ],

                ),

              )

                  .animate()

                  .fade(duration: 600.ms)

                  .slideY(begin: -.2),

              const SizedBox(height: 35),

              //----------------------------------------------------
              // SUPPORT
              //----------------------------------------------------

              buildModernTile(

                icon: Icons.support_agent,

                title: "Contact Support",

                subtitle: "Call our support team",

                color: Colors.blue,

                onTap: callSupport,

              )

                  .animate()

                  .fade(delay: 200.ms)

                  .slideX(begin: .3),

              const SizedBox(height: 15),

              //----------------------------------------------------
              // RATE
              //----------------------------------------------------

              buildModernTile(

                icon: Icons.star,

                title: "Rate Our App",

                subtitle: "Share your experience",

                color: Colors.orange,

                onTap: rateApp,

              )

                  .animate()

                  .fade(delay: 300.ms)

                  .slideX(begin: .3),

              const SizedBox(height: 15),

              //----------------------------------------------------
              // LOGOUT
              //----------------------------------------------------

              buildModernTile(

                icon: Icons.logout,

                title: "Logout",

                subtitle: "Sign out from account",

                color: Colors.red,

                onTap: logout,

              )

                  .animate()

                  .fade(delay: 400.ms)

                  .slideX(begin: .3),

              const SizedBox(height: 40),

              Text(

                "PickLaundry Version 1.0.0",

                style: TextStyle(

                  color: Colors.grey.shade600,

                  fontWeight: FontWeight.w500,

                ),

              ),

              const SizedBox(height: 30),

            ],

          ),

        ),

      ),

    );
    
  }
    //-------------------------------------------------------
  // CALL SUPPORT
  //-------------------------------------------------------

  Future<void> callSupport() async {

    final Uri uri = Uri(
      scheme: "tel",
      path: "8908045837",
    );

    if (await canLaunchUrl(uri)) {

      await launchUrl(uri);

    } else {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to call support"),
        ),
      );

    }
  }

  //-------------------------------------------------------
  // RATE APP
  //-------------------------------------------------------

  Future<void> rateApp() async {

    final Uri uri = Uri.parse(
      "https://play.google.com/store/apps/details?id=com.example.picklaundry",
    );

    if (await canLaunchUrl(uri)) {

      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

    }
  }

  //-------------------------------------------------------
  // LOGOUT
  //-------------------------------------------------------

  Future<void> logout() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
      (route) => false,
    );
  }

  //-------------------------------------------------------
  // MODERN TILE
  //-------------------------------------------------------

  Widget buildModernTile({

    required IconData icon,

    required String title,

    required String subtitle,

    required Color color,

    required VoidCallback onTap,

  }) {

    return Material(

      elevation: 4,

      color: Colors.white,

      borderRadius: BorderRadius.circular(20),

      child: InkWell(

        borderRadius: BorderRadius.circular(20),

        splashColor: color.withOpacity(.15),

        onTap: onTap,

        child: Padding(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),

          child: Row(

            children: [

              Container(

                height: 58,

                width: 58,

                decoration: BoxDecoration(

                  color: color.withOpacity(.12),

                  borderRadius: BorderRadius.circular(18),

                ),

                child: Icon(

                  icon,

                  color: color,

                  size: 30,

                ),

              ),

              const SizedBox(width: 18),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      title,

                      style: const TextStyle(

                        fontSize: 17,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 4),

                    Text(

                      subtitle,

                      style: TextStyle(

                        color: Colors.grey.shade600,

                        fontSize: 14,

                      ),

                    ),

                  ],

                ),

              ),

              CircleAvatar(

                radius: 18,

                backgroundColor:
                    Colors.grey.shade100,

                child: const Icon(

                  Icons.arrow_forward_ios_rounded,

                  size: 16,

                  color: Colors.black54,

                ),

              ),

            ],

          ),

        ),

      ),

    );
  }
}
