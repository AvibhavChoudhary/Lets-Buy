import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:myshop/widgets/user_product.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product-screen";

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Products"),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              })
        ],
      ),
      drawer: MyDrwaer(),
      body: FutureBuilder(
        future: _onRefresh(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: Consumer<Products>(
                  builder: (ctx, productData, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: productData.manageproducts.length,
                        itemBuilder: (ctx, i) => productData
                                    .manageproducts.length >
                                0
                            ? UserProduct(
                                title: productData.manageproducts[i].title,
                                imageUrl:
                                    productData.manageproducts[i].imageUrl,
                                id: productData.manageproducts[i].id)
                            : Center(
                                child:
                                    Text("You have'nt added any product yet."),
                              )),
                  ),
                ),
              ),
      ),
    );
  }
}
