import 'package:amar_becha_kena/CheckOut.dart';
import 'package:amar_becha_kena/ModelOrder.dart';
import 'package:amar_becha_kena/auth_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:amar_becha_kena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyCartPage extends StatefulWidget {
  const MyCartPage({Key? key}) : super(key: key);

  @override
  _MyCartPageState createState() => _MyCartPageState();
}

class _MyCartPageState extends State<MyCartPage> {
  List<ModelOrder> cartItemList = [];

  fetchCartList() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    String uid = firebaseAuth.currentUser!.uid.toString();
    String name,id,itemid;
    int price, quantity;
    int i=0;

    FirebaseFirestore.instance.collection('UserCarts').doc(uid).collection("user_orders").get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((cartitem) {
        name=cartitem["Productname"];
        id=cartitem["Uid"];
        itemid=cartitem["Itemid"];
        price=int.parse(cartitem["Total"]);
        quantity=int.parse(cartitem["Quantity"]);
        setState(() {
          cartItemList.add(ModelOrder(name, quantity,price,id,itemid));
        });
      });
    });
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    fetchCartList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(cartItemList[i].productName ?? "",
                    style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    color: Colors.black12,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount:  ",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                    Text(cartItemList[i].quantity.toString(),
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                        Text("x",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                        SizedBox(width: 60,),
                        Text("Price:  ",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.deepPurpleAccent,
                          child: Row(
                            children: [
                              Text(cartItemList[i].price.toString(),
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
                              Text("/=",
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: (){
                            deleteFromCart(cartItemList[i].productName, cartItemList[i].quantity.toString(), cartItemList[i].price.toString(), cartItemList[i].itemid)
                                .then((value) {
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  const MyCartPage()),
                              );
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            alignment: Alignment.center,
                            height: 40,
                            width: 40,
                            child: Icon(Icons.delete),
                          )),
                      GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>  CheckOut(pname: cartItemList[i].productName, price:  cartItemList[i].price, quantity:  cartItemList[i].quantity, cartItem: cartItemList[i].itemid))),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            alignment: Alignment.center,
                            //height: 40,
                            //width: 40,
                            child: Text('Check Out',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: cartItemList.length,
      ),
    );
  }
}
