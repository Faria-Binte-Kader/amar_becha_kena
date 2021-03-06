import 'package:amar_becha_kena/ModelProduct.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<User?> createAccount(String name, String mail, String pass, String phone) async{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try{
   User? user = (await firebaseAuth.createUserWithEmailAndPassword(email: mail, password: pass)).user;
   if(user != null)
     { print("login successful");
     Fluttertoast.showToast(
         msg: "Signed up successfully",
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 1,
         backgroundColor: Colors.white,
         textColor: Colors.black87,
         fontSize: 16.0
     );
      return user;
     }
   else{
     print("login failed");
     return user;
   }
  }catch(e){
   print(e);
   Fluttertoast.showToast(
       msg: e.toString(),
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.white,
       textColor: Colors.black87,
       fontSize: 16.0
   );
   return null;
  }
}

Future<User?> logIn(String mail, String pass) async{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try{
    User? user = (await firebaseAuth.signInWithEmailAndPassword(email: mail, password: pass)).user;
    if(user != null)
    { print("login successful");
     Fluttertoast.showToast(
        msg: "Login Syccessful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
    return user;
    }
    else{
      print("login failed");
      return user;
    }
  }catch(e){
    print(e);
    Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black87,
        fontSize: 16.0
    );
    return null;
  }
}

Future logOut() async{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try{
   await firebaseAuth.signOut();
  }catch(e){
    print(e);
  }
}

Future<void> storeUserData(String name, String mail, String pass, String phone)async {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid = firebaseAuth.currentUser!.uid.toString();
  users.add({
    'Name': name,
    'Uid': uid,
    'Phone': phone,
    'Mail': mail});
    return;
}

Future<void> storeProductData(String pname, String desc,String quantity, String price, String url) async {
  CollectionReference products = FirebaseFirestore.instance.collection('Products');
  //FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //String uid = firebaseAuth.currentUser!.uid.toString();
  products.add({
    'Name': pname.toUpperCase().trim(),
    'Description': desc,
    'Price': price,
    'Quantity': quantity,
    'Url': url});
  return;
}

Future<void> addToCart(String pname, String quantity, String TotalPrice) async {
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String uid = firebaseAuth.currentUser!.uid.toString();
CollectionReference cartitem = FirebaseFirestore.instance.collection('UserCarts').doc(uid).collection("user_orders");

  DocumentReference docs=cartitem.doc();
  docs.set({'Productname': pname,
  'Quantity': quantity,
  'Total': TotalPrice,
  'Uid': uid,
  'Itemid': docs.id
  });

return;
}

Future<void> deleteFromCart(String pname, String quantity, String TotalPrice, String itemid) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid = firebaseAuth.currentUser!.uid.toString();

  FirebaseFirestore.instance
      .collection('UserCarts')
      .doc(uid)
      .collection('user_orders')
      .doc(itemid)
      .delete();
  return;
}

Future<void> PlaceOrder(String pname, String quantity, String TotalPrice, String address, String phone) async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String uid = firebaseAuth.currentUser!.uid.toString();
  CollectionReference orders = FirebaseFirestore.instance.collection('UserOrders').doc(uid).collection("placed_orders");

  DocumentReference docs=orders.doc();
  docs.set({'Productname': pname,
    'Quantity': quantity,
    'Total': TotalPrice,
    'Uid': uid,
    'Itemid': docs.id,
    'Address': address,
    "Phone": phone
  });

  return;
}

