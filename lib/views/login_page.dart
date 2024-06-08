import 'package:flutter/material.dart';
import 'package:storage_management_app/controllers/login_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.sizeOf(context).width;
    var loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        title: const Text('Login Page'),
        // actions: const [Icon(Icons.star), Icon(Icons.alarm)],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: loginProvider.formKey,
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
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                    controller: loginProvider.usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tolong isi field ini';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                    controller: loginProvider.passwordController,
                    obscureText: loginProvider.obscurePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tolong isi field ini';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              context.read<LoginProvider>().actionObscurePassword();
                            },
                            icon: Icon(loginProvider.obscurePassword == true
                                ? Icons.visibility_off
                                : Icons.visibility)),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))))),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, elevation: 5),
                  onPressed: () {
                    context.read<LoginProvider>().processLogin(context);
                  },
                  child: const Text("Login",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, elevation: 5),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text("Register",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                // bodyMessage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget bodyMessage() {
  //   var state = context.watch<LoginProvider>().loginState;
  //   var username = context.watch<LoginProvider>().username;
  //   switch (state) {
  //     case StateLogin.initial:
  //       return const SizedBox();
  //     case StateLogin.success:
  //       return Text('Selamat datang $username');
  //     case StateLogin.error:
  //       return Text(context.watch<LoginProvider>().messageError);
  //     default:
  //       return const SizedBox();
  //   }
  // }
}
