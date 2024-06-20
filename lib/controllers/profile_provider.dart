import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/profile_response_model.dart';
import 'package:storage_management_app/views/components/alert_dialogs.dart';

class ProfileProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  var state = ProfileState.initial;
  File? imageFile;
  String? publicUrl = 'http://192.168.100.178:3000/uploads/users/';
  String? imageUrl;
  String? image;
  var obscurePassword = true;

  Future<int?> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId;
  }

  Future getUser(BuildContext context) async {
     state = ProfileState.loading;
    try {
      var url = Uri.parse(
          'http://192.168.100.178:3000/api/auth/get-user/${await getIdUser()}');
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      print(response.body);
      ProfileResponseModel profile = ProfileResponseModel.fromJson(data);
      usernameController.text = profile.username ?? '';
      var username = profile.username;
      print(username);
      if (profile.image != null) {
        image = profile.image;
        imageUrl = publicUrl.toString() + profile.image!;
      }
      state = ProfileState.success;
    } on DioException catch (e) {
      showAlertError(context, '', e as String);
      state = ProfileState.error;
    }
    notifyListeners();
  }

  Future updateProfile(BuildContext context) async {
    state = ProfileState.loading;
    notifyListeners();
    try {
      var idUser = await getIdUser();
      var url =
          Uri.parse('http://192.168.100.178:3000/api/auth/update-profile');
      var request = http.MultipartRequest('PUT', url);
      request.fields['username'] = usernameController.text;
      request.fields['id'] = idUser.toString();
      
      if (passwordController.text.isNotEmpty) {
        request.fields['password'] = passwordController.text;
      }

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile!.path));
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      passwordController.clear();
      showAlertSuccess(context,'Great Work!', 'Profile has been updated successfully.');
      state = ProfileState.success;
    } on DioException catch (e) {
      showAlertError(context, 'Ohh Nooo!', e as String);
      state = ProfileState.error;
    }
    notifyListeners();
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? ext = image.path.split('.').last;
      if (ext != null &&
          (ext.toLowerCase() == 'jpg' ||
              ext.toLowerCase() == 'jpeg' ||
              ext.toLowerCase() == 'png')) {
        imageFile = File(image.path);
      } else {
        print('File not supported');
      }
    }
    notifyListeners();
  }

  Future logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('username');
    imageController.clear();
    usernameController.clear();
    passwordController.clear();
    imageFile = null;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

}

enum ProfileState { initial, loading, success, error }
