import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int price;
  bool isFavorite = false;

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite,
    @required this.title,
  });

  Future<void> toggleFavorite() async {
    print(isFavorite);
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
