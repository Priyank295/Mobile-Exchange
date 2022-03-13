import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mbx/loadingScreen.dart';
import 'package:mbx/product_detail_page.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({Key? key}) : super(key: key);

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  String DocId = "";
  String UserId = "";
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fire = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    var uid = currentUser!.uid;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("YOUR PRODUCTS"),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: "Lato",
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: StreamBuilder(
          stream: _fire
              .collection("Products")
              .where("User Id", isEqualTo: uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingScreen();
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                List<dynamic> getImages =
                    snapshot.data?.docs[index].get("Product Photo");
                return Column(children: [
                  Container(
                    height: 208,
                    width: 170,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      color: Color(0xfffF1F4FB),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: GestureDetector(
                            onTap: () {
                              var x = snapshot.data!.docs[index];
                              setState(() {
                                DocId = snapshot.data!.docs[index].id;
                                UserId =
                                    snapshot.data!.docs[index].get("User Id");

                                print(UserId);
                                print(DocId);
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (ctx) => ProductDetailPage(
                                            UserId,
                                            DocId,
                                            snapshot.data!.docs[index],
                                          )));
                            },
                            child: Image.network(
                              getImages[0] ??
                                  "https://drive.google.com/file/d/1vn5SBl4PUzOoVFj6wyYMat-cXnu-3LN3/view?usp=sharing",
                              // Lottie.asset("assets/loading.json",
                              //     height: 50,
                              //     frameRate: FrameRate(60)),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                  ),
                  Text(
                    snapshot.data?.docs[index].get(
                      'Product Name',
                    ),
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: "Lato",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\u{20B9}" +
                        snapshot.data!.docs[index]
                            .get("Product Price")
                            .toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xfffA1A1A1),
                        fontFamily: "Lato"),
                  ),
                ]);
              },
            );
            ;
          },
        ));
  }
}
