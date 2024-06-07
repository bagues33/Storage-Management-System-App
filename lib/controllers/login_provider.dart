import 'package:flutter/material.dart';
import 'package:storage_management_app/utils/push_notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/views/product/product_page.dart';

class LoginProvider extends ChangeNotifier {
  PushNotificationService pushNotificationService = PushNotificationService();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var loginState = StateLogin.initial;
  var username = '';
  var messageError = '';
  bool obscurePassword = true;

  Future<Map<String, dynamic>?> loginAPI(String username, String password) async {
    try {
      var url = Uri.parse('http://192.168.100.178:3000/api/auth/login'); // Ganti dengan URL API lokal Anda
      var response = await http.post(url, body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data; // Mengembalikan data lengkap dari response API
      } else {
        print(response.body);
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }   
  }


  void processLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Map<String, dynamic>? data = await loginAPI(usernameController.text, passwordController.text);
      if (data != null) {
        username = data['user']['username'];
        loginState = StateLogin.success;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setInt('userId', data['user']['id']);
        await prefs.setString('username', data['user']['username']);
        pushNotificationService.showNotification('Success', 'Congratulation. You have successfully for login');
        showAlertSuccess(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProductPage()),
        );
      } else {
        messageError = 'Username dan password salah. Ulangi!!!';
        loginState = StateLogin.error;
      }
    } else {
      showAlertError(context);
    }

    notifyListeners();
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
}

enum StateLogin { initial, success, error }

showAlertError(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Periksa kelengkapan datamu!'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'))
        ],
      );
    },
  );
}

showAlertSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Selamat!'),
        content: const Text('Login berhasil!'),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'))
        ],
      );
    },
  );
}
