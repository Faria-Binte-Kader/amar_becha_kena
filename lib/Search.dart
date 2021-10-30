import 'package:amar_becha_kena/DataController.dart';
import 'package:amar_becha_kena/ModelProduct.dart';
import 'package:amar_becha_kena/add_product.dart';
import 'package:amar_becha_kena/auth_methods.dart';
import 'package:amar_becha_kena/product_details.dart';
import 'package:flutter/material.dart';
import 'package:amar_becha_kena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchcontroller = TextEditingController();
  QuerySnapshot? snapshotData;
  bool isExecuted=false;
  @override
  Widget build(BuildContext context) {
    Widget searchedData(){
      return snapshotData!.docs.length==0? Container(
        child: Center(
          child: Text("Sorry! No such products.", style: TextStyle(
              color: Colors.white,
              fontSize: 20
          ),),
        ),
      ): ListView.builder(
          itemCount: snapshotData!.docs.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(snapshotData!.docs[index]['Url'] ?? "No images",
                        fit: BoxFit.cover,),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.black12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(snapshotData!.docs[index]['Name'] ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),),
                            GestureDetector(
                                onTap: (){
                                  String name= snapshotData!.docs[index]['Name'];
                                  String des= snapshotData!.docs[index]['Description'];
                                  String u= snapshotData!.docs[index]['Url'];
                                  int q=snapshotData!.docs[index]['Quantity'];
                                  int pr=snapshotData!.docs[index]['Price'];
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  ProductDetails(name: name, quantity: q, desc: des, url: u, price: pr)));},
                                child: Icon(Icons.arrow_right)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: (){
                String name= snapshotData!.docs[index]['Name'];
                String des= snapshotData!.docs[index]['Description'];
                String u= snapshotData!.docs[index]['Url'];
                int q=int.parse(snapshotData!.docs[index]['Quantity']);
                int pr=int.parse(snapshotData!.docs[index]['Price']);
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  ProductDetails(name: name, quantity: q, desc: des, url: u, price: pr)));
              }
            );
          },);
    }

    return Scaffold(
       appBar: AppBar(
         actions: [
           GetBuilder<DataController>(
               init: DataController() ,
               builder: (val){
                 return IconButton(onPressed: (){
                   val.queryData(searchcontroller.text).then((value){
                     snapshotData = value;
                     setState(() {
                       isExecuted=true;
                     });
                   } );
                 }, icon: Icon(Icons.search));
               })
         ],
         title: TextField(style: TextStyle(color: Colors.white),
         controller: searchcontroller,
         decoration: InputDecoration(
           hintText: 'Search Products',
           hintStyle:  TextStyle(color: Colors.white),
         ),),
       ),
        body: isExecuted? searchedData(): Container(
          child: Center(
            child: Text("Search for any product.", style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          onPressed: (){
            setState(() {
              isExecuted=false;
              searchcontroller.text="";
            });
          },
          child: const Icon(Icons.clear),
        ),
    );
  }
}
