import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storage_management_app/views/category/category_page.dart';
import 'package:storage_management_app/views/login_page.dart';
import 'package:storage_management_app/views/product/edit_form_product_page.dart';
import 'package:storage_management_app/views/product/form_product_page.dart';
import 'package:storage_management_app/controllers/product_provider.dart';
import 'package:storage_management_app/views/profile_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductProvider>().getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        // leading: IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
        title: const Text('Product Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () async {
             Navigator.push(
                context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ));
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.remove('token');
              // await prefs.remove('userId');
              // await prefs.remove('username');
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormProductPage(),
                ));
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: Consumer<ProductProvider>(
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

  Widget bodyData(BuildContext context, ProductState state) {
    switch (state) {
      case ProductState.success:
        var dataResult = context.watch<ProductProvider>().listProduct;
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
                  child: Image.network(
                    dataResult[index].image_url ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                      // You can return an Image.asset here
                      return Image.asset('lib/assets/images/default_image.png',
                          fit: BoxFit.cover, width: 100, height: 100
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataResult[index].name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(dataResult[index].qty.toString() ?? '0'),
                      
                      Text(dataResult[index].category!.name ?? ''),
                      Text(dataResult[index].createdBy!.username ?? ''),
                      Text(dataResult[index].updatedBy!.username ?? ''),
                      Row(
                        children: [
                          InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditFormProduct(
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
                                      title: Text('Confirm Delete'),
                                      content: Text('Are you sure you want to delete this product?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            context
                                                .read<ProductProvider>()
                                                .deleteProduct(context, dataResult[index].id ?? 0);
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
      case ProductState.nodata:
        return const Center(
          child: Text('No Data Product'),
        );
      case ProductState.error:
        return Center(
          child: Text(context.watch<ProductProvider>().messageError),
        );
      default:
        return const CircularProgressIndicator();
    }
  }
  
}