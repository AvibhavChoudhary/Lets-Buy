import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        description: "This is the tshirt",
        id: "p1",
        imageUrl:
            "https://cdn.pixabay.com/photo/2017/08/10/08/00/shirt-2619788__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Cool T-shirt"),
    Product(
        description: "This is the tshirt",
        id: "p2",
        imageUrl:
            "https://cdn.pixabay.com/photo/2016/08/15/19/57/red-devils-1596355__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Cool T-shirt"),
    Product(
        description: "Awesome jeans",
        id: "p3",
        imageUrl:
            "https://cdn.pixabay.com/photo/2016/08/15/19/57/red-devils-1596355__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Jeans"),
    Product(
        description: "Jeans",
        id: "p4",
        imageUrl:
            "https://cdn.pixabay.com/photo/2014/12/11/10/11/jeans-564061__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Jeans"),
    Product(
        description: "Shirt",
        id: "p5",
        imageUrl:
            "https://cdn.pixabay.com/photo/2015/09/02/13/18/person-918986__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Shirt"),
    Product(
        description: "Shirt",
        id: "p6",
        imageUrl:
            "https://cdn.pixabay.com/photo/2014/08/05/10/31/waiting-410328__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Shirt"),
    Product(
        description: "Hoodie",
        id: "p7",
        imageUrl:
            "https://cdn.pixabay.com/photo/2017/08/07/01/37/people-2598484__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Hoodie"),
    Product(
        description: "Hoodie",
        id: "p8",
        imageUrl:
            "https://cdn.pixabay.com/photo/2017/07/31/11/38/cold-2557518__340.jpg",
        price: 500,
        isFavorite: false,
        title: "Hoodie"),
  ];
  List<Product> get items {
    return [..._items];
  }

  Product findByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  void addProduct(product) {
    // _items.add(product);
    notifyListeners();
  }
}
