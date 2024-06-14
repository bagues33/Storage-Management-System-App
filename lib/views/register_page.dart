import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/register_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_management_app/views/login_page.dart';

class RegisterPage extends StatefulWidget {
 
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String? pathFiles;
  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.sizeOf(context).width;
    var registerProvider = context.watch<RegisterProvider>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                Container(
                  child: Text(
                    'Please Register and Upload Your Picture!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                if (registerProvider.imageFile != null)
                  Image.file(
                    registerProvider.imageFile!,
                    width: 100,
                    height: 100,
                  )
                else
                  Image.asset(
                    'lib/assets/images/profile.png',
                    width: 100,
                    height: 100,
                  ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    await registerProvider.pickImage();
                  },
                  child: Image.asset(
                    'lib/assets/images/photo.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: registerProvider.usernameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                    controller: registerProvider.passwordController,
                    obscureText: registerProvider.obscurePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tolong isi field ini';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              context
                                  .read<RegisterProvider>()
                                  .actionObscurePassword();
                            },
                            icon: Icon(registerProvider.obscurePassword == true
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(26, 33, 48, 1),
                      elevation: 5),
                  onPressed: registerProvider.state == RegisterState.loading
                      ? null
                      : () {
                          registerProvider.processRegister(context, formKey);
                        },
                  child: registerProvider.state == RegisterState.loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sudah punya akun?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // use naigator pushReplacement
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future captureImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      pathFiles = image!.path;
    });
    print(pathFiles);
  }
}
