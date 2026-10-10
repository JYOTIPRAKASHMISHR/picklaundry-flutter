import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'screen/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: const PickLaundryApp(),
    ),
  );
}

class PickLaundryApp extends StatelessWidget {
  const PickLaundryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PickLaundry',
      theme: ThemeData.dark(),
      home: const SplashScreen(),
    );
  }
}