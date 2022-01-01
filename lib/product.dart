import 'package:firebase_database/firebase_database.dart';

class Product {
  String name;
  String Description;
  String ImgUrl;
  double Price;
  List<Product> product;

  Product({
    required this.Description,
    required this.ImgUrl,
    required this.Price,
    required this.name,
    required this.product,
  });
}
