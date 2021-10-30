import 'package:amar_becha_kena/Search.dart';
import 'package:amar_becha_kena/auth_methods.dart';
import 'package:amar_becha_kena/logout.dart';
import 'package:amar_becha_kena/product_list.dart';
import 'package:flutter/material.dart';
import 'package:amar_becha_kena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'my_cart.dart';

class BackGroundPage extends StatefulWidget {
  const BackGroundPage({Key? key}) : super(key: key);

  @override
  _BackGroundPageState createState() => _BackGroundPageState();
}

class _BackGroundPageState extends State<BackGroundPage> {
  int currentindex=0;
  final screens = [
    ProductListPage(),
    Search(),
    MyCartPage(),
    Log_Out()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: screens[currentindex],
     bottomNavigationBar: BottomNavigationBar(
      selectedItemColor: Colors.deepPurpleAccent,
      backgroundColor: Colors.black87,
      unselectedItemColor: Colors.white,
      showUnselectedLabels: false,
      currentIndex: currentindex,
      onTap: (index) => setState(() {
        currentindex = index;
      }),
      items:  const [
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          label: 'Shop',
           // backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: "Search",
          //backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: "My Cart",
          //backgroundColor: Colors.deepPurple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: "Log out",
          //backgroundColor: Colors.deepPurple,
        ),
      ],
    ),
    );


  }
}
