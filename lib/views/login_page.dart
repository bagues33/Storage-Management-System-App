import 'package:flutter/material.dart';
import 'package:storage_management_app/controllers/login_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/views/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var sizeWidth = MediaQuery.sizeOf(context).width;
    var loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: sizeWidth * 0.5,
                  height: sizeWidth * 0.5,
                  child: SvgPicture.asset('lib/assets/images/ilus_login.svg'),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Welcome Back !',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
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
                              context
                                  .read<LoginProvider>()
                                  .actionObscurePassword();
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
                      backgroundColor: Color.fromRGBO(26, 33, 48, 1),
                      elevation: 5),
                  onPressed: loginProvider.state == LoginState.loading
                      ? null
                      : () {
                          loginProvider.processLogin(context, formKey);
                        },
                  child: loginProvider.state == LoginState.loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        "Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          // use navigator pushReplacement
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue),
                        ))
                  ],
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
