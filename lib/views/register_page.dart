import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/register_provider.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? pathFiles;
  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.sizeOf(context).width;
    var registerProvider = context.watch<RegisterProvider>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        title: const Text('Register Page'),
        // actions: const [Icon(Icons.star), Icon(Icons.alarm)],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: registerProvider.formKey,
            child: ListView(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Row(
                    children: [
                      Image.network(
                        'https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png',
                        fit: BoxFit.cover,
                        height: sizeWidth / 6,
                      ),
                      const Expanded(
                        child: Text(
                          'Selamat Datang di Kampus Merdeka',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (registerProvider.imageFile != null)
                  Image.file(
                    registerProvider.imageFile!,
                    width: 100,
                    height: 100,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await registerProvider.pickImage();
                  },
                  child: const Text('Upload Image'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: registerProvider.usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Masukkan username Anda',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                              context.read<RegisterProvider>().actionObscurePassword();
                            },
                            icon: Icon(registerProvider.obscurePassword == true
                                ? Icons.visibility_off
                                : Icons.visibility)
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))
                        )
                    )
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    registerProvider.processRegister(context);
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back to Login'),
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