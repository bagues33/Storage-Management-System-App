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

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    return userId ?? '';
  }

  Future getProduct() async {
    try {
      var response = await Dio().get('http://192.168.100.178:3000/api/products');
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
      String userId = await getUserId();
      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "image_url": imageController.text,
        "created_by": userId,
        "updated_by": userId,
        "category_id": categoryIdController.text,
      };
      await Dio().post(
        'http://192.168.100.178:3000/api/products',
        data: requestModel,
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Data berhasil ditambahkan'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('OK'),
              )
            ],
          );
        },
      );
      getProduct();
    } catch (e) {
      messageError = e.toString();
    }
    notifyListeners();
  }

  Future detailProduct(int id) async {
    try {
      messageError = '';
      var response = await Dio().get('http://192.168.100.178:3000/api/products/$id');
      var result = ProductResponseModel.fromJson(response.data);
      idDataSelected = id;
      nameController.text = result.data!.name ?? '-';
      qtyController.text = result.data!.qty.toString();
      imageController.text = result.data!.imageUrl ?? '-';
      createdByController.text = result.data!.createdBy.toString();
      updatedByController.text = result.data!.updatedBy.toString();
      categoryIdController.text = result.data!.categoryId.toString();
      
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
      String userId = await getUserId();
      var requestModel = {
        "name": nameController.text,
        "qty": qtyController.text,
        "image_url": imageController.text,
        "updated_by": userId,
        "category_id": categoryIdController.text,
      };
      await Dio().put('http://192.168.100.178:3000/api/products/$id', data: requestModel);
      // var result = ProductResponseModel.fromJson(response.data);
      Navigator.pop(context);
      getProduct();
    } catch (e) {
      messageError = e.toString();
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
