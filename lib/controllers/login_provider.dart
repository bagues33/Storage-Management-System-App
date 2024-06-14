import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storage_management_app/models/login_response_model.dart';
import 'package:storage_management_app/utils/push_notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/views/home_screen.dart';
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

  Future<Map<String, dynamic>?> loginAPI(
      String username, String password) async {
    try {
      var url = Uri.parse(
          'http://192.168.100.178:3000/api/auth/login'); // Ganti dengan URL API lokal Anda
      var response = await http
          .post(url, body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data; // Mengembalikan data lengkap dari response API
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void processLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      try {
        loginState = StateLogin.initial;
        var response =
            await loginAPI(usernameController.text, passwordController.text);
        if (response != null) {
          if (response.containsKey('msg')) {
            // Show the error message in an alert dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Failed'),
                  content: Text(response['msg']),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            loginState = StateLogin.error;
          } else {
            LoginResponseModel loginResponse = LoginResponseModel.fromJson(response);
            var token = loginResponse.token;
            var id = loginResponse.user?.id;
            var username = loginResponse.user?.username;

            if (token != null && id != null && username != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);
              await prefs.setInt('userId', id);
              await prefs.setString('username', username);

              pushNotificationService.showNotification(
                  'Success', 'Congratulation. You have successfully for login');
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } else {
              loginState = StateLogin.error;
            }
          }
        } else {
          loginState = StateLogin.error;
        }
      } catch (e) {
        loginState = StateLogin.error;
      }
    } else {
      showAlertError(context);
    }
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
