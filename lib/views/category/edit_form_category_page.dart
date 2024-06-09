import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/controllers/category_provider.dart';

class EditFormCategory extends StatefulWidget {
  final int id;
  const EditFormCategory({required this.id, super.key});

  @override
  State<EditFormCategory> createState() => _EditFormCategoryState();
}

class _EditFormCategoryState extends State<EditFormCategory> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryProvider>().detailCategory(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    var categoryProvider = context.watch<CategoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Category'),
      ),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))))),
            const SizedBox(
              height: 10,
            ),
            Text(categoryProvider.messageError),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CategoryProvider>().updateCategory(context);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}