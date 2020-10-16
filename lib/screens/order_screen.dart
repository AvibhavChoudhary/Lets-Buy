import 'package:flutter/material.dart';
import 'package:myshop/providers/order.dart';
import 'package:myshop/widgets/order_view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/orders";
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, index) => OrderItemView(orderData.orders[index])),
    );
  }
}
