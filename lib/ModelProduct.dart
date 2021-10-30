import 'package:cloud_firestore/cloud_firestore.dart';

class Modelproduct{
  String productName;
  int quantity;
  String description;
  String url;
  int price;

  Modelproduct(this.productName,this.quantity,this.description, this.url, this.price);

}