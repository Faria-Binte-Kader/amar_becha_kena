import 'package:amar_becha_kena/auth_methods.dart';
import 'package:amar_becha_kena/background.dart';
import 'package:amar_becha_kena/my_cart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({Key? key, required this.pname, required this.price, required this.quantity, required this.cartItem}) : super(key: key);
  final String pname, cartItem;
  final int price,quantity;

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();

  Future<void>CheckandUpdateProductDetails() async{
    FirebaseFirestore.instance
        .collection('Products')
        .where('Name', isEqualTo: widget.pname.toUpperCase())
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((item) {
        if(int.parse(item['Quantity'])>=widget.quantity)
          {
            int q=int.parse(item['Quantity'])-widget.quantity;
            String id=item['ItemID'];
            FirebaseFirestore.instance
                .collection('Products')
                .doc(id)
                .update({'Quantity': q.toString()})
                .then((value) => print("Product Updated"))
                .catchError((error) => print("Failed to update product: $error"));
          } else {
          setState(() {
            Fluttertoast.showToast(
                msg: 'Sorry, not enough products available!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                fontSize: 16.0
            );
          });
      }
    });
  });}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Check Out"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
          Card(
          child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.pname ?? "",
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
                    Text(widget.quantity.toString(),
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
                          Text(widget.price.toString(),
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
            ],
          ),
        ),
          ),
            Container(
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            //color: Colors.deepPurpleAccent,
            child:
             Text("Input shipping information",
             style: const TextStyle(
            decoration: TextDecoration.underline,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
               ),),),
              Container(
                //height: 40,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: address,
                  focusNode: FocusNode(),
                  decoration: const InputDecoration(
                    labelText: 'Shipping address',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              Container(
                //height: 40,
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: phone,
                  focusNode: FocusNode(),
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                //color: Colors.deepPurpleAccent,
                child:
                Text("Payment method:  Cash on delivery",
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.deepPurpleAccent,
                    fontWeight: FontWeight.bold,
                  ),),),
              Container(
                margin: const EdgeInsets.fromLTRB(40, 80, 40, 0),
                height: 50,
                child: Material(
                  borderRadius: BorderRadius.circular(30.0),
                  shadowColor: Colors.deepPurpleAccent,
                  color: Colors.deepPurple,
                  elevation: 8.0,
                  child: GestureDetector(
                    onTap: (){
                      Alert(
                        style: AlertStyle(
                          overlayColor: Colors.black87,
                          titleStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          descStyle: TextStyle(color: Colors.white),
                        ),
                        context: context,
                        type: AlertType.none,
                        title: "Confirm Order?",
                        desc: "After agreeing, this cannot be undone",
                        buttons: [
                          DialogButton(
                            highlightColor: Colors.deepPurpleAccent,
                            color: Colors.deepPurple,
                            child: const Text(
                              "No",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            width: 60,
                          ),
                          DialogButton(
                            highlightColor: Colors.deepPurpleAccent,
                            color: Colors.deepPurple,
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              if(address.text.isNotEmpty && phone.text.isNotEmpty) {
                                CheckandUpdateProductDetails().then((value) => setState(() {
                                  deleteFromCart( widget.pname, widget.quantity.toString(),
                                      widget.price.toString(),widget.cartItem);
                                  Fluttertoast.showToast(
                                      msg: 'Congratulations. Your order is placed!',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black87,
                                      fontSize: 16.0
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  const BackGroundPage()),
                                  );
                                }));
                                PlaceOrder(
                                    widget.pname, widget.quantity.toString(),
                                    widget.price.toString(), address.text,
                                    phone.text);
                              }
                              else{
                                setState(() {
                                  Fluttertoast.showToast(
                                      msg: 'Please input shipping information first.',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black87,
                                      fontSize: 16.0
                                  );
                                });
                              }
                            },
                            width: 60,
                          )
                        ],
                      ).show();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Text('PLACE ORDER',
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
        ),
      ),
    );

  }
}
