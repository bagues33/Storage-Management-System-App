import 'package:flutter/material.dart';
import 'package:storage_management_app/controllers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/product_provider.dart';
import 'package:storage_management_app/views/product/product_page.dart';
import 'package:storage_management_app/controllers/category_provider.dart';

class FormProductPage extends StatefulWidget {
  const FormProductPage({super.key});

  @override
  State<FormProductPage> createState() => _FormProductPageState();
}

class _FormProductPageState extends State<FormProductPage> {
  void initState() {
    super.initState();
    context.read<CategoryProvider>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = context.watch<ProductProvider>();
    var dataCategory = context.watch<CategoryProvider>().listCategory;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      appBar: AppBar(
        title: const Text('Insert Product'),
        backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: productProvider.formKey,
          child: ListView(
            children: [
              const Text(
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                  controller: productProvider.nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong isi field ini';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Qty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                  controller: productProvider.qtyController,
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'Tolong isi field ini';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Image URL',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                  controller: productProvider.imageController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Tolong isi field ini';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 10,
              ),
              // list category
              const Text(
                'Category ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: productProvider.categoryIdController.text.isEmpty
                    ? null
                    : productProvider.categoryIdController
                        .text, // set to null if the initial value is not in the dropdown items
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong isi field ini';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    productProvider.categoryIdController.text = newValue;
                  }
                },
                items: (dataCategory ?? [])
                    .map((e) => DropdownMenuItem<String>(
                          value: e.id.toString(),
                          child: Text(e.name.toString()),
                        ))
                    .toList(),
                // items: [
                //   DropdownMenuItem<String>(
                //     child: Text('Admin'),
                //     value: 'one',
                //   ),
                // ],
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(26, 33, 48, 1),
                    elevation: 5),
                onPressed: productProvider.state == ProductState.loading
                    ? null
                    : () {
                        context.read<ProductProvider>().insertProduct(context);
                      },
                child: productProvider.state == ProductState.loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
              // bodyMessage()
            ],
          ),
        ),
      ),
    );
  }
}
