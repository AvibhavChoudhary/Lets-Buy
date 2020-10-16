import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatelessWidget {
  static const routeName = "/product-detail";
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findByID(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            product.title,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Rs${product.price.toString()}",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
