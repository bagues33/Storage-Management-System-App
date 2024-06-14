import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:storage_management_app/models/profile_response_model.dart';

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
    try {
      state = ProfileState.loading;
      var url = Uri.parse(
          'http://192.168.100.178:3000/api/auth/get-user/${await getIdUser()}');
      var response = await http.get(url);
      var data = jsonDecode(response.body);

      ProfileResponseModel profile = ProfileResponseModel.fromJson(data);

      usernameController.text = profile.username ?? '';
      image = profile.image;
      imageUrl = publicUrl.toString() + profile.image!;
      print('image URL: $imageUrl');
      print('image: $image');
      state = ProfileState.success;
    } on DioException catch (e) {
      showAlertError(context, e as String);
      state = ProfileState.error;
    }
    notifyListeners();
  }

  Future updateProfile(BuildContext context) async {
    try {
      state = ProfileState.loading;
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
      showAlertSuccess(context);
      state = ProfileState.success;
    } on DioException catch (e)  {
      showAlertError(context, e as String);
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

showAlertSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Success'),
        content:
            Text('Congratulation. You have successfully for update profile'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

void showAlertError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

enum ProfileState { initial, loading, success, error }
