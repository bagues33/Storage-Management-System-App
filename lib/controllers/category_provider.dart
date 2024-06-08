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
      var response = await Dio().get('http://192.168.100.178:3000/api/categories');
      var result = CategoryModel.fromJson(response.data);
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
      var requestModel = {
        "name": nameController.text,
      };
      await Dio().post(
        'http://192.168.100.178:3000/api/categories',
        data: requestModel,
      );

      Navigator.pop(context);
      getCategory();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future detailCategory(int id) async {
    try {
      messageError = '';
      var response = await Dio().get('http://192.168.100.178:3000/api/categories/$id');
      var result = CategoryResponseModel.fromJson(response.data);
      idDataSelected = id;
      nameController.text = result.data!.name ?? '-';

    } catch (e) {
      state = CategoryState.error;
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future updateCategory(
    BuildContext context,
  ) async {
    try {
      var requestModel = {
        "id": idDataSelected,
        "name": nameController.text,
      };
      await Dio().put('http://192.168.100.178:3000/api/categories', data: requestModel);
      // var result = CategoryResponseModel.fromJson(response.data);
      Navigator.pop(context);
      getCategory();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future deleteCategory(BuildContext context, int id) async {
    try {
      await Dio().delete('http://192.168.100.178:3000/api/categories/$id');
      getCategory();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }
}

enum CategoryState { initial, loading, success, error, nodata }
