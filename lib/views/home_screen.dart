import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/profile_provider.dart';
import 'package:storage_management_app/views/category/category_page.dart';
import 'package:storage_management_app/views/product/product_page.dart';
import 'package:storage_management_app/views/profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    context.read<ProfileProvider>().getUser(context);
  }

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ProductPage(),
    CategoryPage(),
  ];

  static List<String> _appBarTitles = <String>[
    'Product Page',
    'Category Page',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(255, 247, 233, 1),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 24,
        ),
        title: Text(_appBarTitles[_selectedIndex]), // Change this
        actions: [
          IconButton(
            icon: _buildProfileImage(),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ));
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        clipBehavior:
            Clip.hardEdge, //or better look(and cost) using Clip.antiAlias,
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

  Widget _buildProfileImage() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var profileProvider = context.watch<ProfileProvider>();
        if (profileProvider.imageFile != null) {
          return CircleAvatar(
            backgroundImage: FileImage(profileProvider.imageFile!),
            radius: constraints.maxHeight < constraints.maxWidth
                ? constraints.maxHeight / 2
                : constraints.maxWidth / 2,
          );
        } else if (profileProvider.imageFile == null &&
            profileProvider.image != null &&
            profileProvider.image != '') {
          return CircleAvatar(
            backgroundImage: NetworkImage(profileProvider.imageUrl!),
            radius: constraints.maxHeight < constraints.maxWidth
                ? constraints.maxHeight / 2
                : constraints.maxWidth / 2,
          );
        } else {
          return CircleAvatar(
            child: Icon(
              Icons.person,
              size: constraints.maxHeight < constraints.maxWidth
                  ? constraints.maxHeight / 2
                  : constraints.maxWidth / 2,
            ),
          );
        }
      },
    );
  }
  
}
