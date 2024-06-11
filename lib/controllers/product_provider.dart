// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:storage_management_app/models/Product_response_model.dart';

class ProductProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController qtyController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController createdByController = TextEditingController();
  TextEditingController updatedByController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();

  List<Data>? listProduct;
  var state = ProductState.initial;
  var messageError = '';

  int idDataSelected = 0;

  Future<int> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('userId');
    return userId ?? 0;
  }

  Future getProduct() async {
    try {
      state = ProductState.loading;
      var response =
          await Dio().get('http://192.168.100.178:3000/api/products');
      var result = ProductModel.fromJson(response.data);
      print('result: $result');
      if (result.data!.isEmpty) {
        state = ProductState.nodata;
      } else {
        state = ProductState.success;
        listProduct = result.data;
      }
    } catch (e) {
      state = ProductState.error;
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future insertProduct(
    BuildContext context,
  ) async {
    try {
      state = ProductState.loading;
      int userId = await getUserId();
      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "image_url": imageController.text,
        "created_by": userId,
        "updated_by": userId,
        "category_id": categoryIdController.text,
      };
      print('requestModel products: $requestModel');
      await Dio()
          .post('http://192.168.100.178:3000/api/products', data: requestModel);
      messageError = '';
      nameController.clear();
      qtyController.clear();
      imageController.clear();
      categoryIdController.clear();
      showAlertDialogWithBack(
          context, 'Success', 'Product has been added successfully.');
      getProduct();
    } on DioException catch (e) {
      var error = e.response!.data[0]['msg'];
      showAlertDialog(context, 'Error', error);
      // var error = e.toString();
      print('error insert product: $error');
    }
    notifyListeners();
  }

  Future detailProduct(int id) async {
    try {
      messageError = '';
      var response =
          await Dio().get('http://192.168.100.178:3000/api/products/$id');
      var result = ProductResponseModel.fromJson(response.data);
      print('result detail product: $result');
      idDataSelected = id;
      nameController.text = result.name!;
      qtyController.text = result.qty!.toString();
      imageController.text = result.imageUrl!;
      categoryIdController.text = result.categoryId!.toString();
      state = ProductState.success;
    } catch (e) {
      state = ProductState.error;
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future updateProduct(
    BuildContext context,
  ) async {
    try {
      state = ProductState.loading;
      var id = idDataSelected;
      int userId = await getUserId();
      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "image_url": imageController.text,
        "updated_by": userId,
        "category_id": categoryIdController.text,
      };
      await Dio().put('http://192.168.100.178:3000/api/products/$id',
          data: requestModel);
      // var result = ProductResponseModel.fromJson(response.data);
      messageError = '';
      nameController.clear();
      qtyController.clear();
      imageController.clear();
      categoryIdController.clear();
      showAlertDialogWithBack(
          context, 'Success', 'Product has been updated successfully.');
      getProduct();
    } on DioException catch (e) {
      var error = e.response!.data[0]['msg'];
      showAlertDialog(context, 'Error', error);
      print('error update product: $error');
    }
    notifyListeners();
  }

  Future deleteProduct(BuildContext context, int id) async {
    try {
      state = ProductState.loading;
      await Dio().delete('http://192.168.100.178:3000/api/products/$id');
      getProduct();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
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

  void showAlertDialogWithBack(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

enum ProductState { initial, loading, success, error, nodata }
