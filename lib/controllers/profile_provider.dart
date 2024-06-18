import 'dart:convert';
import 'dart:io';

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

  // get user data from shared preferences
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

      ProfileResponseModel profile = ProfileResponseModel.fromJson(data);
      print('Profile: $profile');
      usernameController.text = profile.username ?? '';
      
      if (profile.image != null) {
        image = profile.image;
        imageUrl = publicUrl.toString() + profile.image!;
      }
      print('image URL: $imageUrl');
      print('image: $image');
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
      // var data = jsonDecode(responseString);
      print("ID User: $idUser");
      print("responseString Update Profile: $responseString");
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
        // Tampilkan pesan error bahwa format gambar tidak didukung
      }
    }
    notifyListeners(); // Add this line to notify listeners after picking an image
  }
}


enum ProfileState { initial, loading, success, error }
