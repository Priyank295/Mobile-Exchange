import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'product.dart';
import 'product_detail_page.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

// List<Product> product = [];

final FirebaseFirestore _fstore = FirebaseFirestore.instance;
var finalData;
String DocId = "";
String UserId = "";

var stream1 = _fstore.collection("users").snapshots();

class _MainWidgetState extends State<MainWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Products").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            DocumentSnapshot document = snapshot.data!.docs[i];
            if (document.id != null) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.7,
                ),
                itemCount: snapshot.data?.docs.length,
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
                                  DocId = document.id;
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
            }
          }
        }
        return Container();
      },
    )

        // body: StreamBuilder(
        //     stream: FirebaseFirestore.instance.collection("users").snapshots(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        //       if (snapshot.hasData) {
        //         print("Length:${snapshot.data!.docs.length}");
        //         for (int i = 0; i < snapshot.data!.docs.length; i++) {
        //           DocumentSnapshot document = snapshot.data!.docs[i];
        //           print(document.id);
        //           if (document.id != null) {
        //             return StreamBuilder(
        //                 stream: FirebaseFirestore.instance
        //                     .collection("users")
        //                     .doc(document.id)
        //                     .collection("Products")
        //                     .snapshots(),
        //                 builder: (BuildContext context,
        //                     AsyncSnapshot<QuerySnapshot> productSnapshot) {
        //                   if (productSnapshot.hasData) {
        //                     for (int j = 0;
        //                         j < productSnapshot.data!.docs.length;
        //                         j++) {
        //                       DocumentSnapshot productDoc =
        //                           productSnapshot.data!.docs[j];
        //                       if (productDoc.id != null) {
        //                         return GridView.builder(
        //                           gridDelegate:
        //                               SliverGridDelegateWithFixedCrossAxisCount(
        //                             crossAxisCount: 2,
        //                             crossAxisSpacing: 10,
        //                             mainAxisSpacing: 10,
        //                             childAspectRatio: 0.7,
        //                           ),
        //                           itemCount: productSnapshot.data?.docs.length,
        //                           itemBuilder: (context, index) {
        //                             List<dynamic> getImages = productSnapshot
        //                                 .data?.docs[index]
        //                                 .get("Product Photo");
        //                             return Column(children: [
        //                               Container(
        //                                 height: 208,
        //                                 width: 170,
        //                                 child: Card(
        //                                   shape: RoundedRectangleBorder(
        //                                       borderRadius:
        //                                           BorderRadius.circular(30)),
        //                                   color: Color(0xfffF1F4FB),
        //                                   child: ClipRRect(
        //                                       borderRadius:
        //                                           BorderRadius.circular(30),
        //                                       child: GestureDetector(
        //                                         onTap: () {
        //                                           var x = productSnapshot
        //                                               .data!.docs[index];
        //                                           setState(() {
        //                                             UserId = document.id;

        //                                             DocId = productDoc.id;

        //                                             print(UserId);
        //                                             print(DocId);
        //                                           });

        //                                           Navigator.push(
        //                                               context,
        //                                               MaterialPageRoute(
        //                                                   builder: (ctx) =>
        //                                                       ProductDetailPage(
        //                                                           UserId,
        //                                                           DocId,
        //                                                           productSnapshot
        //                                                                   .data!
        //                                                                   .docs[
        //                                                               index],
        //                                                           snapshot.data!
        //                                                               .docs[i])));
        //                                         },
        //                                         child: Image.network(
        //                                           getImages[0] ??
        //                                               "https://drive.google.com/file/d/1vn5SBl4PUzOoVFj6wyYMat-cXnu-3LN3/view?usp=sharing",
        //                                           // Lottie.asset("assets/loading.json",
        //                                           //     height: 50,
        //                                           //     frameRate: FrameRate(60)),
        //                                           loadingBuilder:
        //                                               (BuildContext context,
        //                                                   Widget child,
        //                                                   ImageChunkEvent?
        //                                                       loadingProgress) {
        //                                             if (loadingProgress == null)
        //                                               return child;
        //                                             return Center(
        //                                               child:
        //                                                   CircularProgressIndicator(
        //                                                 value: loadingProgress
        //                                                             .expectedTotalBytes !=
        //                                                         null
        //                                                     ? loadingProgress
        //                                                             .cumulativeBytesLoaded /
        //                                                         loadingProgress
        //                                                             .expectedTotalBytes!
        //                                                     : null,
        //                                               ),
        //                                             );
        //                                           },
        //                                           fit: BoxFit.cover,
        //                                         ),
        //                                       )),
        //                                 ),
        //                               ),
        //                               Text(
        //                                 productSnapshot.data?.docs[index].get(
        //                                   'Product Name',
        //                                 ),
        //                                 style: TextStyle(
        //                                     fontSize: 16,
        //                                     color: Colors.black,
        //                                     fontFamily: "Lato",
        //                                     fontWeight: FontWeight.bold),
        //                               ),
        //                               Text(
        //                                 "\u{20B9}" +
        //                                     productSnapshot.data!.docs[index]
        //                                         .get("Product Price")
        //                                         .toString(),
        //                                 style: TextStyle(
        //                                     fontSize: 18,
        //                                     color: Color(0xfffA1A1A1),
        //                                     fontFamily: "Lato"),
        //                               ),
        //                             ]);
        //                           },
        //                         );
        //                       }
        //                     }
        //                   }
        //                   return Center(
        //                     child: Text("NO DATA"),
        //                   );
        //                 });
        //           }
        //         }
        //         // return Center(
        //         //   child: Lottie.asset("assets/loading.json",
        //         //       frameRate: FrameRate(30)),
        //         // );
        //       }
        //       return Center(
        //         child: Text("NO DATA"),
        //       );
        //     }),
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
