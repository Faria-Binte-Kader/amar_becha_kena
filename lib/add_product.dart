import 'dart:io';
import 'package:amar_becha_kena/auth_methods.dart';
import 'package:amar_becha_kena/background.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController description = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController productname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController price= TextEditingController();
  var dir = Directory.current.path;
  late File _image;
  bool load=false;
  Future<String>? imgurl;
  final ImagePicker _picker = ImagePicker();


  Future getimage() async{
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery
    );
    setState(() {
      _image=File(pickedFile!.path);
      load=true;
    });

  }

  Future uploadImageToFirebase(BuildContext context) async {
    String url;
    String fileName = _image.toString();
    firebase_storage.Reference firebaseStorageRef =
    firebase_storage.FirebaseStorage.instance.ref().child('ProductImages/$fileName');
    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    uploadTask.whenComplete(() async {
      url = await firebaseStorageRef.getDownloadURL();
      storeProductData(productname.text, description.text, quantity.text, price.text, url);
    }).catchError((onError) {
      print(onError);
    });

  }

  uploadProduct() async{
    await uploadImageToFirebase(context).then((value) =>
        storeProductData(productname.text, description.text, quantity.text, price.text, value));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Product"),
        ),
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30,80,30,0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child:
                  const Text("Add product to sell",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),),
                ),
                const SizedBox(height: 20,),
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: productname,
                    focusNode: FocusNode(),
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    focusNode: FocusNode(),
                    controller: description,
                    decoration: const InputDecoration(
                      labelText: 'Decription',
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    controller: quantity,
                    focusNode: FocusNode(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Quantity",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  //height: 40,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    controller: price,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price for a single product",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  //height: 40,
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextField(
                    controller: phone,
                    keyboardType: TextInputType.number,
                    focusNode: FocusNode(),
                    decoration: const InputDecoration(
                      labelText: "Bkash Number for payment",
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upload Image",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),
                      GestureDetector(
                          onTap: (){
                            getimage();
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(50, 0, 10, 0),
                            alignment: Alignment.center,
                            height: 40,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.deepPurpleAccent,),
                            child: Icon(Icons.add_photo_alternate_outlined),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                Container(
                  child: load==true? Image.file(_image):const Text("Please select product image"),
                ),
                const SizedBox(height: 50,),
                Container(
                  height: 50,
                  child: Material(
                    borderRadius: BorderRadius.circular(30.0),
                    shadowColor: Colors.deepPurpleAccent,
                    color: Colors.deepPurple,
                    elevation: 8.0,
                    child: GestureDetector(
                      onTap: (){
                        if(load==true){
                          uploadProduct();
                              setState(() {
                                Fluttertoast.showToast(
                                    msg: 'Product added for sale',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.black87,
                                    fontSize: 16.0
                                );
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  const BackGroundPage()),
                              );
                            }},
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text('Add to cart',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ));
  }
}
