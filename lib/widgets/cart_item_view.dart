import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class CartItemView extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final int price;
  CartItemView(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  content: Text("Do you want to remove item from the cart?"),
                  title: Text("Are you sure?"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                        child: Text("No")),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                        child: Text("Yes")),
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cart.removeItem(id);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Consumer<Products>(
            builder: (_, product, ch) => ListTile(
              leading: Image.network(
                product.findByID(id).imageUrl,
                fit: BoxFit.contain,
              ),
              title: Text(
                title,
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Text(
                product.findByID(id).description,
                style: TextStyle(fontSize: 13),
              ),
              trailing: Container(
                child: Row(children: [
                  Text(
                    "₹$price X $quantity",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      cart.deleteItem(id);
                      print("deleted");
                    },
                    color: Colors.red,
                    iconSize: 20,
                  )
                ]),
                width: 120,
                constraints: BoxConstraints(
                  maxWidth: 120,
                ),
              ),
            ),
          )),
    );
  }
}
