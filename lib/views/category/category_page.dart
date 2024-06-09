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
      appBar: AppBar(
        backgroundColor: Colors.amber,
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        title: const Text('Category Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
             Navigator.push(
                context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ));
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormCategoryPage(),
              ));
        },
        child: const Icon(Icons.add),
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
    Text('Product Page');
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
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataResult[index].name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
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
                                    title: Text('Delete Confirmation'),
                                    content: Text('Are you sure you want to delete this category?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          context
                                            .read<CategoryProvider>()
                                            .deleteCategory(context, dataResult[index].id ?? 0);
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
              ],
            ),
          ),
        );
      case CategoryState.nodata:
        return const Center(
          child: Text('No Data Product'),
        );
      case CategoryState.error:
        return Center(
          child: Text(context.watch<CategoryProvider>().messageError),
        );
      default:
        return const CircularProgressIndicator();
    }
  }
}