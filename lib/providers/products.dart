import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';

class Products with ChangeNotifier {
  CollectionReference ref = FirebaseFirestore.instance.collection("Products");
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Product> _items = [];
  List<Product> _manageProducts = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get manageproducts {
    return [..._manageProducts];
  }

  Product findByID(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favorites {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) {
    return ref.add({
      "description": product.description,
      "id": DateTime.now().toString(),
      "imageUrl": product.imageUrl,
      "price": product.price,
      "isFavorite": product.isFavorite,
      "title": product.title,
      "creatorId": auth.currentUser.uid,
    }).then((response) {
      print(response);
      final newProduct = Product(
          description: product.description,
          id: response.id,
          imageUrl: product.imageUrl,
          price: product.price,
          isFavorite: product.isFavorite,
          title: product.title);
      _items.add(newProduct);
      print(newProduct.id);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> fetchData([bool filterStatus = false]) async {
    final List<Product> loadedProducts = [];
    try {
      if (filterStatus) {
        await ref
            .where("creatorId", isEqualTo: auth.currentUser.uid)
            .get()
            .then((snapshot) => {
                  snapshot.docs.forEach((doc) {
                    loadedProducts.add(Product(
                      description: doc.data()["description"],
                      id: doc.id,
                      imageUrl: doc.data()["imageUrl"],
                      price: doc.data()["price"],
                      title: doc.data()["title"],
                      isFavorite: doc.data()["isFavorite"],
                    ));
                    _manageProducts = loadedProducts;
                    notifyListeners();
                  })
                });
      } else {
        await ref.get().then((snapshot) => {
              snapshot.docs.forEach((doc) {
                loadedProducts.add(Product(
                  description: doc.data()["description"],
                  id: doc.id,
                  imageUrl: doc.data()["imageUrl"],
                  price: doc.data()["price"],
                  title: doc.data()["title"],
                  isFavorite: doc.data()["isFavorite"],
                ));
                _items = loadedProducts;
                notifyListeners();
              })
            });
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingIndex = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingIndex];

    ref.doc(id).delete().then((_) {
      existingProduct = null;
    }).catchError((error) {
      print("error chala");
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
    });
    _items.removeAt(existingIndex);
    notifyListeners();
    // var index = _items.indexWhere((prod) => prod.id == id);
    // _items.removeAt(index);
  }

  Future<void> updateProduct(String id, Product product) async {
    var index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      await ref.doc(id).update({
        "title": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
      });
      _items[index] = product;
      notifyListeners();
    } else {
      print("error in updateProduct method");
    }
  }
}
