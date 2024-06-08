import 'package:flutter/material.dart';
import 'package:storage_management_app/controllers/category_provider.dart';
import 'package:provider/provider.dart';
import 'package:storage_management_app/views/category/edit_form_category_page.dart';
import 'package:storage_management_app/views/category/form_category_page.dart';

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
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        title: const Text('Category Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormCategory(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'List Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              bodyData(context, context.watch<CategoryProvider>().state),
            ],
          ),
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
                              onTap: () => context
                                  .read<CategoryProvider>()
                                  .deleteCategory(
                                      context, dataResult[index].id ?? 0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ))
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