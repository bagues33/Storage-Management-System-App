import 'dart:io';

import 'package:flutter/material.dart';
import 'package:storage_management_app/utils/push_notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storage_management_app/views/login_page.dart';

enum RegisterState { initial, success, error, loading }

class RegisterProvider extends ChangeNotifier {
  PushNotificationService pushNotificationService = PushNotificationService();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  RegisterState state = RegisterState.initial;
  var username = '';
  var messageError = '';
  bool obscurePassword = true;
  File? imageFile;

  Future<String?> registerAPI(String username, String password) async {
    state = RegisterState.loading;
    var url = Uri.parse(
        'http://192.168.100.178:3000/api/auth/register'); // Ganti dengan URL API lokal Anda

    var request = http.MultipartRequest('POST', url);
    request.fields['username'] = username;
    request.fields['password'] = password;

    print('Image file: $imageFile');

    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile!.path));
    }

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    var data = jsonDecode(responseString);

    if (response.statusCode == 200) {
      return null; // Pendaftaran berhasil, kembalikan null
    } else {
      print(response);
      return data['error']; // Terjadi error, kembalikan pesan error
    }
  }

  void processRegister(BuildContext context, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      String? error =
          await registerAPI(usernameController.text, passwordController.text);
      if (error == null) {
        username = usernameController.text;
        state = RegisterState.success;
        pushNotificationService.showNotification(
            'Success', 'Congratulation. You have successfully for register');
        showAlertSuccess(context);
      } else {
        messageError = error;
        state = RegisterState.error;
        showAlertError(context,
            messageError); // Mengirimkan messageError sebagai parameter
      }
    } else {
      state = RegisterState.error;
      showAlertError(context, 'Username dan password tidak boleh kosong');
    }

    notifyListeners();
  }

  void actionObscurePassword() {
    obscurePassword = !obscurePassword;
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
        notifyListeners();
      } else {
        // Tampilkan pesan error bahwa format gambar tidak didukung
      }
    }
  }
}

void showAlertError(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(errorMessage), // Menampilkan pesan error dari server
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}

void showAlertSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Success'),
        content: const Text('Berhasil register'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}
