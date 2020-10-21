import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProduct extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  UserProduct(
      {@required this.title, @required this.imageUrl, @required this.id});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id);
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                      context: (context),
                      builder: (ctx) => AlertDialog(
                            title: Text("Delete Item?"),
                            content: Text("Are you sure want to delete?"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("No")),
                              FlatButton(
                                  onPressed: () {
                                    Provider.of<Products>(context,
                                            listen: false)
                                        .deleteProduct(id)
                                        .catchError(
                                            (error) => print(error.toString()));
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("Yes")),
                            ],
                          ));
                }),
          ],
        ),
      ),
    );
  }
}
