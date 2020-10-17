import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product-screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var product = Product(
      description: "",
      id: null,
      imageUrl: "",
      price: 0,
      title: "",
      isFavorite: false);
  var _isInit = true;
  var _initValues = {
    "title": '',
    "description": "",
    "price": 0,
    "imageUrl": "",
    "isFavorite": false,
  };

  @override
  void dispose() {
    super.dispose();
    _imageUrlFocusNode.removeListener(updateImageurl);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  void updateImageurl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          !_imageUrlController.text.startsWith("https") &&
              !_imageUrlController.text.startsWith("http") ||
          !_imageUrlController.text.endsWith("jpg") &&
              !_imageUrlController.text.endsWith("png") &&
              !_imageUrlController.text.endsWith("jpeg")) {
        return;
      }
      setState(() {});
    }
  }

  void saveForm() {
    var validate = _form.currentState.validate();
    if (!validate) {
      return;
    }
    _form.currentState.save();
    if (product.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(product.id, product);
    } else {
      print(product.title);
      print(product.description);
      print(product.price);
      print(product.imageUrl);
      print(product.isFavorite);
      Provider.of<Products>(context, listen: false).addProduct(product);
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlController.addListener(updateImageurl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final prodID = ModalRoute.of(context).settings.arguments as String;
      if (prodID != null) {
        product = Provider.of<Products>(context).findByID(prodID);
        _initValues = {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": "",
          "isFavorite": product.isFavorite,
        };
        _imageUrlController.text = product.imageUrl;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextFormField(
                initialValue: _initValues["title"],
                style: TextStyle(fontSize: 20, fontFamily: "Barlow"),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Field can't be empty.";
                  }
                  return null;
                },
                onSaved: (val) {
                  product = Product(
                      description: product.description,
                      id: product.id,
                      isFavorite: product.isFavorite,
                      imageUrl: product.imageUrl,
                      price: product.price,
                      title: val);
                },
              ),
              TextFormField(
                initialValue: _initValues["price"].toString(),
                style: TextStyle(fontSize: 20, fontFamily: "Barlow"),
                decoration: InputDecoration(
                  labelText: "Price",
                ),
                validator: (val) {
                  if (val.isEmpty) {
                    return "Field can't be empty";
                  }
                  if (int.tryParse(val) == null) {
                    return "Please enter a valid number";
                  }
                  if (int.parse(val) <= 0) {
                    return "Price can't be Zero";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onSaved: (val) {
                  product = Product(
                      description: product.description,
                      id: product.id,
                      imageUrl: product.imageUrl,
                      isFavorite: product.isFavorite,
                      price: int.parse(val),
                      title: product.title);
                },
              ),
              TextFormField(
                initialValue: _initValues["description"],
                style: TextStyle(fontSize: 20, fontFamily: "Barlow"),
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (val) {
                  if (val.isEmpty) {
                    return "Field can't be empty";
                  }
                  if (val.length < 10) {
                    return "Descripton should have atlest 10 characters";
                  }
                  return null;
                },
                onSaved: (val) {
                  product = Product(
                      description: val,
                      id: product.id,
                      imageUrl: product.imageUrl,
                      isFavorite: product.isFavorite,
                      price: product.price,
                      title: product.title);
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor)),
                    child: Container(
                        child: _imageUrlController.text.isEmpty
                            ? Text("Enter Url")
                            : FittedBox(
                                child: Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.contain,
                                ),
                              )),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "ImageUrl"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Field can't be empty.";
                        }
                        if (!val.startsWith("https") &&
                            !val.startsWith("http")) {
                          return "Please enter a valid url";
                        }
                        if (!val.endsWith("jpg") &&
                            !val.endsWith("png") &&
                            !val.endsWith("jpeg")) {
                          return "please enter valid url";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        product = Product(
                            description: product.description,
                            id: product.id,
                            imageUrl: val,
                            isFavorite: product.isFavorite,
                            price: product.price,
                            title: product.title);
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: 200,
                child: RaisedButton.icon(
                    onPressed: saveForm,
                    color: Colors.teal,
                    textColor: Colors.white,
                    icon: Icon(Icons.upload_sharp),
                    label: Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
                    )),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
