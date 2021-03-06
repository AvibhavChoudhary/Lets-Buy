import 'package:flutter/material.dart';
import 'package:myshop/screens/order_screen.dart';
import 'package:myshop/screens/product_list.dart';
import 'package:myshop/screens/user_product_screen.dart';

class MyDrwaer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Let's Buy"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Main Shop"),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (ctx) => ProductList()));
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
