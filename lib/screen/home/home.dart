import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO : Impelement build
    return Scaffold(
      body: Center(
        child: Text(
          "Ini Halaman beranda",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
