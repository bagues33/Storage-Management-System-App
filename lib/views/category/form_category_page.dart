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
    context.read<CategoryProvider>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = context.watch<CategoryProvider>();
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 247, 233, 1),
        title: const Text('Insert Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
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
                          borderRadius: BorderRadius.all(Radius.circular(10))))),
              const SizedBox(
                height: 20,
              ),
              Text(categoryProvider.messageError),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(26, 33, 48, 1), elevation: 5),
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
      ),
    );
  }
}
