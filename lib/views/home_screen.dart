import 'package:flutter/material.dart';
import 'package:storage_management_app/views/category/category_page.dart';
import 'package:storage_management_app/views/product/product_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ProductPage(),
    CategoryPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge, //or better look(and cost) using Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/products.png')),
              label: 'Product',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/assets/images/categories.png')),
              label: 'Category',
            ),
          ],
          currentIndex: _selectedIndex,
          // show slected item color with #FF7F3E rgb(255, 127, 62)
          selectedItemColor: Color.fromRGBO(255, 255, 255, 1),
          unselectedItemColor: Color.fromRGBO(255, 255, 255, 0.5),
          backgroundColor: Color.fromRGBO(26, 33, 48, 1),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}