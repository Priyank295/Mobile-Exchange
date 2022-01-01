import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mbx/main_widget.dart';

// ignore: non_constant_identifier_names

class ProductDetailPage extends StatefulWidget {
  String DocId;
  String UserId;
  ProductDetailPage(this.DocId, this.UserId);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffF1F4FB),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.UserId)
            .collection("Products")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          DocumentSnapshot docSnapShot;
          if (snapshot.hasData) {
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              DocumentSnapshot document = snapshot.data!.docs[i];
              if (document.id == DocId) {
                // final Data = FirebaseFirestore.instance
                //     .collection("users")
                //     .doc(document.id)
                //     .collection("Products")
                //     .doc(DocId)
                //     .get()
                //     .then(
                //   (value) {
                //     setState(() {
                //       docSnapShot = value;
                //     });

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   height: MediaQuery.of(context).size.height,
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.white,
                      ),
                      height: 470,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.docs[i]["Product Name"])
                        ],
                      ),
                    ),
                  ],
                );
              }
            }

            // return Center(
            //   child: Lottie.asset("assets/loading.json",
            //       frameRate: FrameRate(30)),
            // );
          }
          return Container();
        },
      ),
    );
  }
}
