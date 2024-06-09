import 'package:flutter/material.dart';
import 'package:storage_management_app/controllers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/category_provider.dart';
import 'package:storage_management_app/views/category/category_page.dart';
import 'package:storage_management_app/controllers/category_provider.dart';


class FormCategoryPage extends StatefulWidget {
  const FormCategoryPage({super.key});

  @override
  State<FormCategoryPage> createState() => _FormCategoryPageState();
}

class _FormCategoryPageState extends State<FormCategoryPage> {
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var categoryProvider = context.watch<CategoryProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Insert Category'),),
      body: Form(
            key: categoryProvider.formKey,
            child: ListView(
              children: [
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                    controller: categoryProvider.nameController,
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
               
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, elevation: 5),
                  onPressed: () {
                    context.read<CategoryProvider>().insertCategory(context);
                  },
                  child: const Text("Submit",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                // bodyMessage()
              ],
            ),
          ),
    );
  }
}