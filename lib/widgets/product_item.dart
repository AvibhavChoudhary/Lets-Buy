import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String imageUrl;
  // final String title;
  // final String id;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetail.routeName, arguments: product.id);
        },
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        title: Text(product.title),
        backgroundColor: Colors.black54,
        leading: IconButton(
          color: Colors.orange[500],
          icon: Icon(product.isFavorite == true
              ? Icons.favorite
              : Icons.favorite_border),
          onPressed: () {
            product.toggleFavorite();
          },
        ),
        trailing: IconButton(
          splashColor: Colors.tealAccent,
          splashRadius: 30,
          onPressed: () {
            cart.addItem(product.id, product.title, product.price);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Added to cart"),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: "Undo",
                onPressed: () {
                  cart.removeSingleItem(product.id);
                },
              ),
            ));
          },
          color: Colors.orange[100],
          icon: Icon(Icons.add_shopping_cart),
        ),
      ),
    );
  }
}
