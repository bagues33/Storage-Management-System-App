import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/category_provider.dart';
import 'package:storage_management_app/controllers/product_provider.dart';


class EditFormProduct extends StatefulWidget {
  final int id;
  const EditFormProduct({required this.id, super.key});

  @override
  State<EditFormProduct> createState() => _EditFormProductState();
}

class _EditFormProductState extends State<EditFormProduct> {
  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().detailProduct(widget.id);
    context.read<CategoryProvider>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    var productProvider = context.watch<ProductProvider>();
    var categoryProvider = context.watch<CategoryProvider>().listCategory;
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 247, 233, 1),
        title: const Text('Edit Data Product'),
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
                      return 'please fill this field';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))))),
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
                    if (value!.isEmpty) {
                      return 'please fill this field';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))))),
              const Text(
                'Image Url',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                  controller: productProvider.imageController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please fill this field';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                value: productProvider.categoryIdController.text.isEmpty 
                      ? null 
                      : int.parse(productProvider.categoryIdController.text),
                items: categoryProvider!.map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                    child: Text(e.name.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  productProvider.categoryIdController.text = value.toString();
                },
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
                          context
                              .read<ProductProvider>()
                              .updateProduct(context);
                        },
                  child: productProvider.state == ProductState.loading
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Update',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
