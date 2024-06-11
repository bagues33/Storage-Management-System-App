import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/views/login_page.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileProvider>().getUser();
  }
  @override
  Widget build(BuildContext context) {
    var profileProvider = context.watch<ProfileProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (profileProvider.imageFile != null)
              Image.file(
                profileProvider.imageFile!,
                width: 100,
                height: 100,
              ),
            if (profileProvider.imageFile == null)
              Image.network(
                // get image url from profileProvider.image
                profileProvider.image!,
                width: 100,
                height: 100,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await profileProvider.pickImage();
              },
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: profileProvider.usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: profileProvider.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await profileProvider.updateProfile();
                  },
                  child: const Text('Update Profile'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout Confirmation'),
                          content: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Yes'),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove('token');
                                await prefs.remove('userId');
                                await prefs.remove('username');
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
