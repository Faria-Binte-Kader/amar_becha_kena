import 'package:amar_becha_kena/ModelProduct.dart';
import 'package:amar_becha_kena/auth_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amar_becha_kena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  ProductDetails({Key? key, String? this.name, int? this.quantity,String? this.desc, String? this.url, int? this.price}) : super(key: key);
  final String? name,desc,url;
  final int? quantity,price;
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int calculateQuantity=0;
  int calculatePrice=0;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body:
           SingleChildScrollView(
             child: Column(
               children: [
                 Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.network(widget.url ?? "No images",
                          fit: BoxFit.cover,),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.black12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Product Name: ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    Text(widget.name ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    /*GestureDetector(
                                        onTap: (){},
                                        child: Icon(Icons.arrow_right)),*/
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Text("Description: ",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 320,
                                      child: Text(widget.desc ?? "",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),),
                                    ),
                                    /*GestureDetector(
                                        onTap: (){},
                                        child: Icon(Icons.arrow_right)),*/
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Price: ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    Text(widget.price.toString() ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Quantity available: ",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    Text(widget.quantity.toString() ?? "",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    /*GestureDetector(
                                        onTap: (){},
                                        child: Icon(Icons.arrow_right)),*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
                 Container(
                   margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                   child: Row(
                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Order amount: ",
                         style: const TextStyle(
                           fontSize: 17,
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),),
                       Text(calculateQuantity.toString(),
                         style: const TextStyle(
                           decoration: TextDecoration.underline,
                           fontSize: 17,
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),),
                       GestureDetector(
                           onTap: (){
                             if(calculateQuantity<widget.quantity!){
                             setState(() {
                               calculateQuantity++;
                               calculatePrice=calculateQuantity*widget.price!;
                             });
                           }},
                           child: Container(
                             margin: EdgeInsets.fromLTRB(50, 0, 10, 0),
                             alignment: Alignment.center,
                             height: 40,
                             width: 60,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(30),
                                 color: Colors.deepPurpleAccent,),
                                   child: Icon(Icons.add),
                           )),
                       GestureDetector(
                           onTap: (){
                            if(calculateQuantity>0) {
                              setState(() {
                                calculateQuantity--;
                                calculatePrice =
                                    calculateQuantity * widget.price!;
                              });
                            }},
                           child: Container(
                             margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
                             alignment: Alignment.center,
                             height: 40,
                             width: 60,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(30),
                               color: Colors.deepPurpleAccent,),
                             child: Icon(Icons.remove),
                           )),
                     ],
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                   child: Row(
                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text("Order Price: ",
                         style: const TextStyle(
                           fontSize: 17,
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),),
                       Text(calculatePrice.toString(),
                         style: const TextStyle(
                           decoration: TextDecoration.underline,
                           fontSize: 17,
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),),
                     ],
                   ),
                 ),
                 Container(
                   margin: EdgeInsets.fromLTRB(20, 30, 20, 40),
                   height: 50,
                   child: Material(
                     borderRadius: BorderRadius.circular(30.0),
                     shadowColor: Colors.deepPurpleAccent,
                     color: Colors.deepPurple,
                     elevation: 8.0,
                     child: GestureDetector(
                       onTap:(){
                         if(calculateQuantity==0){
                           Fluttertoast.showToast(
                               msg: 'You must choose at least 1 item to add to your cart',
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.white,
                               textColor: Colors.black87,
                               fontSize: 16.0
                           );
                         }
                         else {
                           addToCart(widget.name!, calculateQuantity.toString(),
                               calculatePrice.toString());
                           Fluttertoast.showToast(
                               msg: 'Item added to your cart',
                               toastLength: Toast.LENGTH_SHORT,
                               gravity: ToastGravity.CENTER,
                               timeInSecForIosWeb: 1,
                               backgroundColor: Colors.white,
                               textColor: Colors.black87,
                               fontSize: 16.0
                           );
                         }
                       },
                       child: Container(
                         alignment: Alignment.center,
                         child: const Text('ADD TO CART',
                           style: TextStyle(
                               color: Colors.white,
                               fontWeight: FontWeight.bold
                           ),),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           )
    );
  }
}
