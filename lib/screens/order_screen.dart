import 'package:flutter/material.dart';
import 'package:myshop/providers/order.dart';
import 'package:myshop/widgets/order_view.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _future;

  Future _obtainFuture() {
    return Provider.of<Order>(context, listen: false).fetchData();
  }

  @override
  void initState() {
    _future = _obtainFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
        ),
        body: FutureBuilder(
            future: _future,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  return Center(
                    child: Text("An error occured"),
                  );
                } else {
                  return Consumer<Order>(builder: (ctx, orderData, child) {
                    return ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, index) =>
                            OrderItemView(orderData.orders[index]));
                  });
                }
              }
            }));
  }
}
