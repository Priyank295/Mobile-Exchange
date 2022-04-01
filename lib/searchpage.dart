import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mbx/database.dart';
import 'package:mbx/notFound.dart';

import 'product_detail_page.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchFieldController = TextEditingController();
  String DocId = "";
  String UserId = "";
  bool haveUserSearched = false;
  late QuerySnapshot searchSnapshot;

  initiateSearch() async {
    if (searchFieldController.text.isNotEmpty) {
      await DatabaseMethods()
          .getProductsBySearch(searchFieldController.text)
          .then((snapshot) {
        searchSnapshot = snapshot;
        setState(() {
          haveUserSearched = true;
        });
      });
    }
  }

  Widget searchProduct(String searchField) {
    return haveUserSearched
        ? GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              // DocumentSnapshot document = snapshot.data!.docs[index];

              return productGrid(
                searchSnapshot.docs[index],
              );
            },
          )
        : NotFound();
  }

  Widget productGrid(QueryDocumentSnapshot snapshot) {
    List<dynamic> getImages = snapshot["Product Photo"];
    return Column(children: [
      Container(
        height: 208,
        width: 170,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Color(0xfffF1F4FB),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: GestureDetector(
                onTap: () {
                  var x = snapshot;
                  setState(() {
                    DocId = snapshot.id;
                    UserId = snapshot["User Id"];

                    print(UserId);
                    print(DocId);
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              ProductDetailPage(UserId, DocId, snapshot)));
                },
                child: Image.network(
                  getImages[0] ??
                      "https://drive.google.com/file/d/1vn5SBl4PUzOoVFj6wyYMat-cXnu-3LN3/view?usp=sharing",
                  // Lottie.asset("assets/loading.json",
                  //     height: 50,
                  //     frameRate: FrameRate(60)),
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
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
        snapshot['Product Name'],
        style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontFamily: "Lato",
            fontWeight: FontWeight.bold),
      ),
      Text(
        "\u{20B9}" + snapshot["Product Price"].toString(),
        style: TextStyle(
            fontSize: 18, color: Color(0xfffA1A1A1), fontFamily: "Lato"),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffF9F9F9),
        // title: Text(
        //   widget.userName,
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 20,
        //     fontFamily: "Lato",
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        centerTitle: true,
        title: Text("Find Products",
            style: TextStyle(
                color: Colors.black,
                fontFamily: "Lato",
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                    color: Color(0xfffF2F3F2),
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset("assets/search2.svg"),
                      ),
                    ),
                    Container(
                      width: 250,
                      child: TextField(
                        controller: searchFieldController,
                        onSubmitted: (value) {
                          initiateSearch();
                        },
                        decoration: InputDecoration(
                            hintText: "Search Products",
                            hintStyle:
                                TextStyle(fontFamily: "Lato", fontSize: 16),
                            border: InputBorder.none),
                      ),
                    ),
                    // PopupMenuButton(
                    //     child: SvgPicture.asset("assets/filter.svg"),
                    //     itemBuilder: (_) {
                    //       return [
                    //         PopupMenuItem(
                    //           child: PopupMenuButton(
                    //             child: Text("Price"),
                    //             itemBuilder: (_) {
                    //               return [
                    //                 PopupMenuItem(
                    //                   child: Text("5000-10000"),
                    //                   value: 5000,
                    //                 ),
                    //                 PopupMenuItem(
                    //                   child: Text("11000-20000"),
                    //                   value: 11000,
                    //                 ),
                    //                 PopupMenuItem(
                    //                   child: Text("21000-30000"),
                    //                   value: 21000,
                    //                 ),
                    //               ];
                    //             },
                    //           ),
                    //         ),
                    //       ];
                    //     }),
                    // InkWell(
                    //   onTap: () {

                    //   },
                    //child: SvgPicture.asset("assets/filter.svg"),
                  ],
                ),
              ),

              // Row(
              //   children: [
              //     Container(
              //       margin: EdgeInsets.symmetric(horizontal: 25),
              //       child: Row(
              //         children: [
              //           SvgPicture.asset("assets/filter.svg"),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
              searchProduct(searchFieldController.text)
            ],
          ),
        ),
      ),
    );
  }
}
