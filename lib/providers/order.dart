import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';

class OrderItem {
  final String id;
  final int amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  CollectionReference ref = FirebaseFirestore.instance.collection("Orders");

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchData() async {
    final List<OrderItem> loadedOrder = [];
    ref.get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        loadedOrder.add(OrderItem(
            amount: doc.data()["amount"],
            dateTime: DateTime.parse(doc.data()["dateTime"]),
            id: doc.id,
            products: (doc.data()["products"] as List<dynamic>)
                .map((cartItem) => CartItem(
                      id: cartItem["id"],
                      title: cartItem["title"],
                      quantity: cartItem["quantity"],
                      price: cartItem["price"],
                    ))
                .toList()));

        _orders = loadedOrder.reversed.toList();
        notifyListeners();
      });
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, int total) async {
    final timestamp = DateTime.now();
    ref.add({
      "id": DateTime.now().toString(),
      "amount": total,
      "dateTime": timestamp.toIso8601String(),
      "products": cartProducts
          .map((cp) => {
                "id": cp.id,
                "title": cp.title,
                "quantity": cp.quantity,
                "price": cp.price,
              })
          .toList(),
    }).then((response) {
      _orders.insert(
          0,
          OrderItem(
              amount: total,
              dateTime: timestamp,
              id: response.id,
              products: cartProducts));
      notifyListeners();
    });
  }
}
