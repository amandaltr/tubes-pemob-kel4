import 'package:flutter/material.dart';

// Import file-file di folder 'screen'
import 'screen/features/splash.dart';
import 'screen/statistic/dashboard.dart';

// Import file-file di folder 'screen/auth'
import 'screen/auth/login.dart';
import 'screen/auth/register.dart';


import 'screen/wishes/wishes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BudgetIn App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // Route awal diarahkan ke SplashScreen
      initialRoute: '/wishes',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/wishes': (context) => const WishesScreen(), // Tambahkan ini
      },

    );
  }
}
