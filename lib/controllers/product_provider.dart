import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:storage_management_app/models/Product_response_model.dart';
import 'package:storage_management_app/views/components/alert_dialogs.dart';

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
    state = ProductState.loading;
    notifyListeners();
    try {
      var response =
          await Dio().get('http://192.168.100.178:3000/api/products');
      var result = ProductModel.fromJson(response.data);
      if (result.data!.isEmpty) {
        state = ProductState.nodata;
      } else {
        state = ProductState.success;
        listProduct = result.data;
      }
      state = ProductState.success;
    } catch (e) {
      state = ProductState.error;
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future insertProduct(
    BuildContext context,
  ) async {
    state = ProductState.loading;
    notifyListeners();
    try {
      int userId = await getUserId();
      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "image_url": imageController.text,
        "created_by": userId,
        "updated_by": userId,
        "category_id": categoryIdController.text,
      };
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
      showAlertError(context, 'Ohh Nooo!', error);
      getProduct();
      print('error insert product: $error');
    }
    notifyListeners();
  }

  Future detailProduct(int id) async {
    state = ProductState.loading;
    try {
      messageError = '';
      var response =
          await Dio().get('http://192.168.100.178:3000/api/products/$id');
      var result = ProductResponseModel.fromJson(response.data);
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
      messageError = '';
      nameController.clear();
      qtyController.clear();
      imageController.clear();
      categoryIdController.clear();
      showAlertDialogWithBack(
          context, 'Great Work!', 'Product has been updated successfully.');
      getProduct();
    } on DioException catch (e) {
      var error = e.response!.data[0]['msg'];
      showAlertError(context, 'Ohh Nooo!', error);
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


}

enum ProductState { initial, loading, success, error, nodata }
