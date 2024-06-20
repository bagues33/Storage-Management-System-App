import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:storage_management_app/controllers/category_provider.dart';
import 'package:storage_management_app/controllers/profile_provider.dart';
import 'package:storage_management_app/controllers/register_provider.dart';
import 'package:storage_management_app/views/splash_screen.dart';

import 'controllers/login_provider.dart';
import 'controllers/main_provider.dart';
import 'controllers/product_provider.dart';
import 'firebase_options.dart';
import 'views/category/category_page.dart';
import 'views/login_page.dart';
import 'views/product/product_page.dart';
import 'views/register_page.dart';

void main() {
  initFirebase();
}

Future initFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MainProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(fontFamily: 'FontLato'),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
           routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/product': (context) => const ProductPage(),
            '/category': (context) => const CategoryPage(),
            // Tambahkan rute lainnya di sini
          },
          ),
    );
  }
}