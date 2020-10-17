import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;
  ProductGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(
      context,
    );
    final products = showFav ? productData.favorites : productData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
            value: products[index], child: ProductItem()));
  }
}
