import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int price;
  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(String prodId, String title, int price) {
    if (_items.containsKey(prodId)) {
      _items.update(
          prodId,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              price: cartItem.price,
              quantity: cartItem.quantity + 1));
    } else {
      _items.putIfAbsent(prodId,
          () => CartItem(id: prodId, title: title, price: price, quantity: 1));
    }
    notifyListeners();
  }

  void deleteItem(String id) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (cartitem) => CartItem(
              id: cartitem.id,
              title: cartitem.title,
              price: cartitem.price,
              quantity: cartitem.quantity > 0 ? cartitem.quantity - 1 : 0));
    }
    notifyListeners();
  }

  void increaseItem(String id) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (cartitem) => CartItem(
              id: cartitem.id,
              title: cartitem.title,
              price: cartitem.price,
              quantity: cartitem.quantity >= 0 ? cartitem.quantity + 1 : 0));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quantity > 1) {
      _items.update(
          id,
          (cartItem) => CartItem(
              id: cartItem.id,
              title: cartItem.title,
              price: cartItem.price,
              quantity: cartItem.quantity - 1));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  int get totalAmount {
    var total = 0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }
}
