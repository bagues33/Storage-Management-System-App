import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/views/components/alert_dialogs.dart';
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
    context.read<ProfileProvider>().getUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(255, 247, 233, 1),
        appBar: AppBar(
          title: const Text('Profile Page'),
          backgroundColor: Color.fromRGBO(255, 247, 233, 1),
        ),
        body: bodyData(context, context.watch<ProfileProvider>().state));
  }

  Widget _buildProfileImage() {
    var profileProvider = context.watch<ProfileProvider>();
    Widget imageWidget;

    if (profileProvider.imageFile != null) {
      imageWidget = Image.file(
        profileProvider.imageFile!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else if (profileProvider.imageFile == null &&
        profileProvider.image != null &&
        profileProvider.image != '') {
      imageWidget = Image.network(
        profileProvider.imageUrl!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      imageWidget = Image.asset(
        'lib/assets/images/profile.png',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: imageWidget,
    );
  }

  Widget bodyData(BuildContext context, ProfileState state) {
    var profileProvider = context.watch<ProfileProvider>();
    switch (state) {
      case ProfileState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case ProfileState.error:
        return const Center(
          child: Text('Error'),
        );
      case ProfileState.success:
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfileImage(),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      await profileProvider.pickImage();
                    },
                    child: Image.asset(
                      'lib/assets/images/photo.png',
                      width: 50,
                      height: 50,
                    ),
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
                    obscureText: profileProvider.obscurePassword,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<ProfileProvider>()
                                  .actionObscurePassword();
                            },
                            icon: Icon(profileProvider.obscurePassword == true
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(26, 33, 48, 1),
                            elevation: 5),
                        onPressed: profileProvider.state == ProfileState.loading
                            ? null
                            : () {
                                context
                                    .read<ProfileProvider>()
                                    .updateProfile(context);
                              },
                        child: profileProvider.state == ProfileState.loading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : const Text(
                                'Update Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                        ),
                        onPressed: () async {
                          showAlertDialogLogout(context, 'Logout',
                              'Are you sure you want to logout?');
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return const Center(
          child: Text('No Data'),
        );
    }
  }
}
