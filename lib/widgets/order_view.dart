import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myshop/providers/order.dart';
import 'package:intl/intl.dart';

class OrderItemView extends StatefulWidget {
  final OrderItem order;
  OrderItemView(this.order);

  @override
  _OrderItemViewState createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  var isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text("₹"),
            ),
            title: Text("Total Amount:${widget.order.amount}"),
            subtitle:
                Text(DateFormat.MMMd().add_Hm().format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
          if (isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: min(widget.order.products.length * 20.0 + 100, 180),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          children: [
                            Text(prod.title),
                            Spacer(),
                            Chip(label: Text("${prod.quantity.toString()} x")),
                            Text(
                              " ${prod.price.toString()}",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
