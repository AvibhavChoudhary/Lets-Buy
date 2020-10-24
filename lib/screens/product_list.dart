import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:myshop/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductList extends StatefulWidget {
  static const routeName = "/product-list";

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  var _showFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _onRefresh() async {
    await Provider.of<Products>(context, listen: false).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Buy"),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
              color: Colors.red,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartView.routeName);
              },
            ),
          ),
          PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    _showFavorite = true;
                  } else {
                    _showFavorite = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text("Favorites"),
                      value: FilterOptions.Favorites,
                    ),
                    PopupMenuItem(
                      child: Text("All"),
                      value: FilterOptions.All,
                    ),
                  ]),
        ],
      ),
      drawer: MyDrwaer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh, child: ProductGrid(_showFavorite)),
      // body: FutureBuilder(
      //     future: _onRefresh(),
      //     builder: (ctx, snapshot) =>
      //         snapshot.connectionState == ConnectionState.waiting
      //             ? Center(
      //                 child: CircularProgressIndicator(),
      //               )
      //             : RefreshIndicator(
      //                 child: ProductGrid(_showFavorite),
      //                 onRefresh: _onRefresh)),
    );
  }
}
