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
      backgroundColor: Color.fromRGBO(255, 247, 233, 1),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(128, 196, 233, 1),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormProductPage(),
              ));
              context.read<ProductProvider>().getProduct();
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        dataResult[index].image_url ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset(
                            'lib/assets/images/default_image.png',
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataResult[index].name ?? '',
                          style: const TextStyle(
                            fontFamily: 'FontLato',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'lib/assets/images/quantity.png',
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(dataResult[index].qty.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'lib/assets/images/category.png',
                              width: 15,
                              height: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(dataResult[index].category!.name ?? ''),
                          ],
                        ),
                        Text(
                            'Created by: ${dataResult[index].createdBy!.username ?? ''}'),
                        Text(
                            'Updated by: ${dataResult[index].updatedBy!.username ?? ''}'),
                        const SizedBox(
                          height: 10,
                        ),
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
                                      title: Text(
                                        'Confirm Delete',
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete this product?',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(167, 230, 255, 1),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Color.fromRGBO(26, 33, 48, 1),
                                          ),
                                          child: Text('No',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red,
                                          ),
                                          child: Text('Yes',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                          ),
                                          onPressed: () {
                                            context
                                                .read<ProductProvider>()
                                                .deleteProduct(context,
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
                ],
              ),
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
        return Center(child: const CircularProgressIndicator());
    }
  }
}
