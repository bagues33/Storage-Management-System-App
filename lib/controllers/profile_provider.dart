import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController imageController = TextEditingController();

  var profileState = StateProfile.initial;
  File? imageFile;
  String? imageUrl = 'http://localhost:3000/uploads/users/';
  String? image;

  // get user data from shared preferences
  Future<int?> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId;
  }

  Future getUser() async {
    try {
      profileState = StateProfile.loading;
      var url = Uri.parse(
          'http://192.168.100.178:3000/api/auth/get-user/${await getIdUser()}');
      var response = await http.get(url);
      var data = jsonDecode(response.body);
      usernameController.text = data['username'];
      image = imageUrl! + data['image'];
      profileState = StateProfile.success;
    } catch (e) {
      profileState = StateProfile.error;
    }
    notifyListeners();
  }

  Future updateProfile() async {
    try {
      profileState = StateProfile.loading;
      var url =
          Uri.parse('http://192.168.100.178:3000/api/auth/update-profile');
      var request = http.MultipartRequest('POST', url);
      request.fields['username'] = usernameController.text;
      request.fields['password'] = passwordController.text;
      request.fields['id'] = await getIdUser().toString();

      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile!.path));
      }

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = jsonDecode(responseString);

      profileState = StateProfile.success;
    } catch (e) {
      profileState = StateProfile.error;
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

showAlertError(BuildContext context, String message) {
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



enum StateProfile { initial, loading, success, error }
