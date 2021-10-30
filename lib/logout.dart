import 'package:amar_becha_kena/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:amar_becha_kena/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Log_Out extends StatefulWidget {
  const Log_Out({Key? key}) : super(key: key);

  @override
  _Log_OutState createState() => _Log_OutState();
}

class _Log_OutState extends State<Log_Out> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Log Out"),
        ),
        body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Do you want to logout?",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),),
                          const SizedBox(height: 30,),
                          Container(
                            margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                            height: 50,
                            child: Material(
                              borderRadius: BorderRadius.circular(30.0),
                              shadowColor: Colors.deepPurpleAccent,
                              color: Colors.deepPurple,
                              elevation: 8.0,
                              child: GestureDetector(
                                onTap: (){
                                  logOut();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  const MyHomePage(title: 'Login')),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text('LOG OUT',
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
                  );
  }
}
