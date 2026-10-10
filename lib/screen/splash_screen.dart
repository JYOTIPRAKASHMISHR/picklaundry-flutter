import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/login_screen.dart';
import '../pages/customer_home_screen.dart';
import '../pages/super_admin_dashboard.dart';
import '../pages/partner_home_screen.dart';
// import '../pages/partner_dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController rippleController;
  late AnimationController bubbleController;

  @override
  void initState() {
    super.initState();

    rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("accessToken");

    String? role = prefs.getString("role");

    print("TOKEN = $token");
    print("ROLE = $role");

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      if (role == "CUSTOMER") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CustomerHomeScreen()),
        );
      } else if (role == "DELIVERY_PARTNER") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PartnerDashboard()),
        );
      } else if (role == "SUPER_ADMIN") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SuperAdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    rippleController.dispose();
    bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([rippleController, bubbleController]),
        builder: (context, child) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff07152F),
                      Color(0xff27104D),
                      Color(0xff0D5C53),
                    ],
                  ),
                ),
              ),

              ...List.generate(
                20,
                (index) => BubbleWidget(
                  animationValue: bubbleController.value,
                  seed: index,
                ),
              ),

              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 240,
                      width: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          for (int i = 0; i < 3; i++)
                            RippleCircle(
                              progress:
                                  (rippleController.value + (i * 0.3)) % 1,
                            ),

                          Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.white.withOpacity(0.12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.cyanAccent.withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.local_laundry_service,
                                color: Colors.white,
                                size: 65,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Text(
                      "PickLaundry",
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Pickup • Clean • Deliver",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 40),

                    const SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RippleCircle extends StatelessWidget {
  final double progress;

  const RippleCircle({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160 + (120 * progress),
      height: 160 + (120 * progress),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withOpacity((1 - progress) * 0.3),
          width: 2,
        ),
      ),
    );
  }
}

class BubbleWidget extends StatelessWidget {
  final double animationValue;
  final int seed;

  const BubbleWidget({
    super.key,
    required this.animationValue,
    required this.seed,
  });

  @override
  Widget build(BuildContext context) {
    final random = Random(seed);

    final size = random.nextDouble() * 40 + 15;

    final x = random.nextDouble() * MediaQuery.of(context).size.width;

    final y =
        MediaQuery.of(context).size.height -
        ((MediaQuery.of(context).size.height + 200) *
            ((animationValue + random.nextDouble()) % 1));

    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.05),
            ],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
      ),
    );
  }
}
