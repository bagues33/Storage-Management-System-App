import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_management_app/views/components/alert_dialogs.dart';
import 'package:storage_management_app/views/login_page.dart';

enum RegisterState { initial, success, error, loading }

class RegisterProvider extends ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RegisterState state = RegisterState.initial;
  var username = '';
  var messageError = '';
  bool obscurePassword = true;
  File? imageFile;

  Future<String?> registerAPI(String username, String password) async {
    var url = Uri.parse('http://192.168.100.178:3000/api/auth/register');

    var request = http.MultipartRequest('POST', url);
    request.fields['username'] = username;
    request.fields['password'] = password;

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile!.path));
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    var data = jsonDecode(responseString);

    if (response.statusCode == 200) {
      return null;
    } else {
      return data['error'];
    }
  }

  void processRegister(
      BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      state = RegisterState.loading;
      notifyListeners();
      String? error =
          await registerAPI(usernameController.text, passwordController.text);
      if (error == null) {
        username = usernameController.text;
        state = RegisterState.success;
        notifyListeners();
        usernameController.clear();
        passwordController.clear();
        showAlertSuccessLogin(
            context, 'Great Work!', 'You have successfully registered');
      } else {
        messageError = error;
        state = RegisterState.error;
        showAlertError(context, 'Ohh Nooo!', messageError);
      }
    } else {
      state = RegisterState.error;
      showAlertError(context, 'Ohh Nooo!', 'Please fill in the form correctly');
    }

    notifyListeners();
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future pickImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String? ext = image.path.split('.').last;
      if (ext != null &&
          (ext.toLowerCase() == 'jpg' ||
              ext.toLowerCase() == 'jpeg' ||
              ext.toLowerCase() == 'png')) {
        imageFile = File(image.path);
        notifyListeners();
      } else {
        alertUploadImage(context, 'File not supported', 'Please upload a jpg, jpeg or png file');
        print('File not supported');
      }
    }
  }
}
