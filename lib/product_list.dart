import 'package:amar_becha_kena/ModelProduct.dart';
import 'package:amar_becha_kena/add_product.dart';
import 'package:amar_becha_kena/auth_methods.dart';
import 'package:amar_becha_kena/product_details.dart';
import 'package:flutter/material.dart';
import 'package:amar_becha_kena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key? key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Modelproduct> productList = [];

   fetchProductList() async {
    String name, desc, url;
    int price, quantity;
    int i=0;

    FirebaseFirestore.instance.collection('Products').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((products) {
        name=products["Name"];
        desc=products["Description"];
        url=products["Url"];
        price=int.parse(products["Price"]);
        quantity=int.parse(products["Quantity"]);
        setState(() {
          productList.add(Modelproduct(name, quantity, desc, url, price));
        });
      });
    });
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    fetchProductList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All products"),
      ),
      body: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: (){
              String name= productList[i].productName;
              String des= productList[i].description;
              String u= productList[i].url;
              int q=productList[i].quantity;
              int pr=productList[i].price;
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ProductDetails(name: name, quantity: q, desc: des, url: u, price: pr)));},
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(productList[i].url ?? "No images",
                    fit: BoxFit.cover,),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      color: Colors.black12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(productList[i].productName ?? "",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),),
                          GestureDetector(
                              onTap: (){
                                String name= productList[i].productName;
                                String des= productList[i].description;
                                String u= productList[i].url;
                                int q=productList[i].quantity;
                                int pr=productList[i].price;
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
          );
        },
        itemCount: productList.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductPage()));
          },
        // tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
