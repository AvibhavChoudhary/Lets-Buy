import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/order.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/screens/order_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/screens/product_list.dart';
import 'package:myshop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Products()),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProvider(create: (ctx) => Order()),
      ],
      child: MaterialApp(
        title: "Let's Buy",
        debugShowCheckedModeBanner: false,
        home: ProductList(),
        theme: ThemeData(primarySwatch: Colors.teal, fontFamily: "Quicksand"),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartView.routeName: (ctx) => CartView(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (ctx) => UserProductScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
