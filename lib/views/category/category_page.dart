import 'package:flutter/material.dart';
import 'package:storage_management_app/controllers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/views/category/edit_form_category_page.dart';
import 'package:storage_management_app/views/category/form_category_page.dart';
import 'package:storage_management_app/views/profile_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryProvider>().getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(128, 196, 233, 1),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormCategoryPage(),
              ));
              context.read<CategoryProvider>().getCategory();
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Consumer<CategoryProvider>(
                builder: (context, value, child) {
                  return bodyData(context, value.state);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyData(BuildContext context, CategoryState state) {
    Text('Category Page');
    switch (state) {
      case CategoryState.success:
        var dataResult = context.watch<CategoryProvider>().listCategory;
        return ListView.builder(
          itemCount: dataResult!.length,
          itemBuilder: (context, index) => Card(
            elevation: 2,
            color: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                side: BorderSide(color: Colors.black)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataResult[index].name ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditFormCategory(
                                  id: dataResult[index].id ?? 0,
                                ),
                              )),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Delete Confirmation',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to delete this category?',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(26, 33, 48, 1),
                                    ),
                                    child: Text('No', style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.red,
                                    ),
                                    child: Text('Yes', style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      context
                                          .read<CategoryProvider>()
                                          .deleteCategory(context,
                                              dataResult[index].id ?? 0);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      case CategoryState.nodata:
        return const Center(
          child: Text('No Data Category'),
        );
      case CategoryState.error:
        return Center(
          child: Text(context.watch<CategoryProvider>().messageError),
        );
      default:
        return Center(child: const CircularProgressIndicator());
    }
  }
}
