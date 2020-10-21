import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:myshop/widgets/user_product.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product-screen";

  Future<void> _onRefresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
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
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: ListView.builder(
            itemCount: productData.items.length,
            itemBuilder: (ctx, i) => UserProduct(
                title: productData.items[i].title,
                imageUrl: productData.items[i].imageUrl,
                id: productData.items[i].id)),
      ),
    );
  }
}
