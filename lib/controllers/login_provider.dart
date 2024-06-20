import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:storage_management_app/models/login_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/views/components/alert_dialogs.dart';
import 'package:storage_management_app/views/home_screen.dart';
import 'package:storage_management_app/views/product/product_page.dart';

enum LoginState { initial, success, error, loading }

class LoginProvider extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginState state = LoginState.initial;
  var username = '';
  var messageError = '';
  bool obscurePassword = true;

  Future<Map<String, dynamic>?> loginAPI(
      String username, String password) async {
    try {
      var url = Uri.parse(
          'http://192.168.100.178:3000/api/auth/login');
      var response = await http
          .post(url, body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data; 
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('Error: $e');
      return null;
    }
  }

  void processLogin(BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      try {
        state = LoginState.loading;
        notifyListeners();
        var response =
            await loginAPI(usernameController.text, passwordController.text);
        if (response != null) {
          if (response.containsKey('msg')) {
            showAlertError(context, 'Ohh Nooo!', response['msg']);
            state = LoginState.error;
            notifyListeners();
          } else {
            LoginResponseModel loginResponse =
                LoginResponseModel.fromJson(response);
            var token = loginResponse.token;
            var id = loginResponse.user?.id;
            var username = loginResponse.user?.username;

            if (token != null && id != null && username != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token);
              await prefs.setInt('userId', id);
              await prefs.setString('username', username);
              state = LoginState.success;
              usernameController.clear();
              passwordController.clear();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } else {
              state = LoginState.error;
            }
          }
        } else {
          state = LoginState.error;
        }
      } catch (e) {
        state = LoginState.error;
      }
    } else {
      showAlertError(context, 'Ohh Nooo!', 'Please fill in the form correctly');
    }
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }
  
}

