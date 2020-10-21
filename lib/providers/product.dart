import 'package:cloud_firestore/cloud_firestore.dart';
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
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(id)
        .update({"isFavorite": isFavorite}).catchError((error) {
      isFavorite = oldStatus;
      notifyListeners();
    });
  }
}
