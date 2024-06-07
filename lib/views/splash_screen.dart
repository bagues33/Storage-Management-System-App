import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';  
import 'package:storage_management_app/views/product/product_page.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadingData();
  }

  Future<void> loadingData() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    var token = sharedPref.getString('token');
    Future.delayed(const Duration(seconds: 3), () {
      if (token == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPage(),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
            child: Image.asset('lib/assets/images/logo-coursenet.png')),
      ),
    );
  }
}
