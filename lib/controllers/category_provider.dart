// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:storage_management_app/models/Category_model.dart';
import 'package:dio/dio.dart';
import 'package:storage_management_app/models/Category_response_model.dart';

class CategoryProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  List<Data>? listCategory;
  var state = CategoryState.initial;
  var messageError = '';

  int idDataSelected = 0;

  Future getCategory() async {
    try {
      var response =
          await Dio().get('http://192.168.100.178:3000/api/categories');
      var result = CategoryModel.fromJson(response.data);
      messageError = '';
      if (result.data!.isEmpty) {
        state = CategoryState.nodata;
      } else {
        state = CategoryState.success;
        listCategory = result.data;
        print('listCategory: $listCategory');
      }
    } catch (e) {
      state = CategoryState.error;
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future insertCategory(
    BuildContext context,
  ) async {
    try {
      state = CategoryState.loading;
      var requestModel = {
        "name": nameController.text,
      };
      await Dio().post(
        'http://192.168.100.178:3000/api/categories',
        data: requestModel,
      );
      messageError = '';
      nameController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Category has been added successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      getCategory();
    } on DioException catch (e) {
      var error = e.response!.data[0]['msg'];
      print('error insert category: $error');
      showAlertDialog(context, 'Error', error);
    }
    notifyListeners();
  }

  Future detailCategory(int id) async {
    try {
      state = CategoryState.loading;
      print('id Category: $id');
      messageError = '';
      var response =
          await Dio().get('http://192.168.100.178:3000/api/categories/$id');
      var result = CategoryResponseModel.fromJson(response.data);
      nameController.text = result.name!;
      print('nameController: ${nameController.text}');
      state = CategoryState.success;
    } catch (e) {
      print('error Detail Category: $e');
      state = CategoryState.error;
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future updateCategory(
    BuildContext context,
  ) async {
    try {
      state = CategoryState.loading;
      var requestModel = {
        "name": nameController.text,
      };
      await Dio().put(
          'http://192.168.100.178:3000/api/categories/$idDataSelected',
          data: requestModel);
      // var result = CategoryResponseModel.fromJson(response.data);
      messageError = '';
      nameController.clear();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Category has been updated successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
      getCategory();
    } on DioException catch (e) {
      var error = e.response!.data[0]['msg'];
      print('error update category: $error');
      showAlertDialog(context, 'Error', error);
    }
    notifyListeners();
  }

  Future deleteCategory(BuildContext context, int id) async {
    try {
      state = CategoryState.loading;
      await Dio().delete('http://192.168.100.178:3000/api/categories/$id');
      messageError = '';
      getCategory();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }

  showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
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
  }
}

enum CategoryState { initial, loading, success, error, nodata }
