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
       backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      appBar: AppBar(
         backgroundColor: Color.fromRGBO(255, 247, 233, 1),
        title: const Text('Edit Data Category'),
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
                height: 10,
              ),
              // Text(categoryProvider.messageError),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(26, 33, 48, 1),
                      elevation: 5),
                  onPressed: categoryProvider.state == CategoryState.loading
                      ? null
                      : () {
                          context
                              .read<CategoryProvider>()
                              .updateCategory(context);
                        },
                  child: categoryProvider.state == CategoryState.loading
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