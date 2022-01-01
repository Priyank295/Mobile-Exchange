import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:snapshot/snapshot.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbx/navbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

// List<Product> product = [];

final FirebaseFirestore _fstore = FirebaseFirestore.instance;
var finalData;

class _MainWidgetState extends State<MainWidget> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   readData();
  // }

  // // Future<void> readData() async {
  // //   final doc = _fstore
  // //       .collection("users")
  // //       .doc("5N0XbO0lGTKIPV0K5B7l")
  // //       .collection("product");

  // //   QuerySnapshot querySnapshot = await doc.get();

  // //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  // //   Product(Description: )
  // // }

  // Future<List<Product>> fetchProduct() async {
  //   final product = <Product>[];
  //   final doc = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc("5N0XbO0lGTKIPV0K5B7l")
  //       .collection("product")
  //       .doc("KYYlVMBFPyAvd2uDoz0k")
  //       .get();
  //   final productTmp = doc.data().forEach((pro) {
  //     product.add(Product.fromMap(pro));
  //   });
  // }

  // Future<void> readData() async {
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance.collection('users').doc('uid').collection('product').;

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                DocumentSnapshot document = snapshot.data!.docs[i];
                if (document.id != null) {
                  final productData = FirebaseFirestore.instance
                      .collection("users")
                      .doc(document.id)
                      .collection("Products")
                      .snapshots();
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(document.id)
                          .collection("Products")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> productSnapshot) {
                        if (productSnapshot.hasData) {
                          for (int j = 0;
                              j < productSnapshot.data!.docs.length;
                              j++) {
                            DocumentSnapshot productDoc =
                                productSnapshot.data!.docs[j];
                            if (productDoc.id != null) {
                              final Data = FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(document.id)
                                  .collection("Products")
                                  .doc(productDoc.id);

                              return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: productSnapshot.data?.docs.length,
                                itemBuilder: (context, index) {
                                  List<dynamic> getImages = productSnapshot
                                      .data?.docs[index]
                                      .get("Product Photo");
                                  return Column(children: [
                                    Container(
                                      height: 208,
                                      width: 170,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        color: Color(0xfffF1F4FB),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Image.network(
                                              getImages[0] ??
                                                  "https://drive.google.com/file/d/1vn5SBl4PUzOoVFj6wyYMat-cXnu-3LN3/view?usp=sharing",
                                              // Lottie.asset("assets/loading.json",
                                              //     height: 50,
                                              //     frameRate: FrameRate(60)),
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    Text(
                                      productSnapshot.data?.docs[index]
                                          .get('Product Name'),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    Text(
                                      "\u{20B9}" +
                                          productSnapshot.data!.docs[index]
                                              .get("Product Price")
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                  ]);
                                },
                              );
                            }
                          }
                        }
                        return Container();
                      });
                }
              }
              // return Center(
              //   child: Lottie.asset("assets/loading.json",
              //       frameRate: FrameRate(30)),
              // );
            }
            return Container();
          }),
      // body: GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //     crossAxisSpacing: 10,
      //     mainAxisSpacing: 10,
      //   ),
      //   itemCount: product.length,
      //   itemBuilder: (context, index) {
      //     return Container(
      //         height: 208,
      //         width: 170,
      //         child: Column(
      //           children: [
      //             Card(
      //               color: Color(0xfffF1F4FB),
      //               shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(30)),
      //               child: Image.network(product[index].ImgUrl),
      //             ),
      //           ],
      //         ));
      //   },
      // ),
    );
  }
}
