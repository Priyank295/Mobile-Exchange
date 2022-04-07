import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbx/chatScreen.dart';
import 'package:mbx/database.dart';
import 'package:mbx/loginpage.dart';
import 'package:mbx/main_widget.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> imagesUrl = [];
String Fname = "";
String Lname = "";
String Email = "";
DatabaseMethods detabaseMethods = DatabaseMethods();
User? user = FirebaseAuth.instance.currentUser;

class ProductDetailPage extends StatefulWidget {
  String DocId;
  String UserId;
  QueryDocumentSnapshot proSnapshot;

  ProductDetailPage(
    this.UserId,
    this.DocId,
    this.proSnapshot,
  );

  //Create chatroom for user and seller
  // createChatRoomandStartConversation({required String userName}) {
  //   String chatRoomId = getChatRoomId(userName, user!.uid);

  //   List<String> users = [userName, user!.uid];
  //   Map<String, dynamic> chatRoomMap = {
  //     "users": users,
  //     "chatroomId": chatRoomId
  //   };

  //   DatabaseMethods().createChatroom(chatRoomId, chatRoomMap);

  //   Get.to(ChatScreen());
  // }

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  getImages() async {
    setState(() {
      imagesUrl = List.from(widget.proSnapshot.get("Product Photo"));
    });
  }

  void getUserId(String uid) {
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getImages();
    getUserId(user!.uid);
  }

  createChatRoomandStartConversation({required String userName}) {
    print(userName);
    print(user!.uid);
    if (userName != user!.uid) {
      String chatRoomId = getChatRoomId(userName, user!.uid);

      List<String> users = [userName, user!.uid];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId
      };

      DatabaseMethods().createChatroom(chatRoomId, chatRoomMap);

      Get.to(ChatScreen(chatRoomId, userName));
      // () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (ctx) => ChatScreen(chatRoomId, userName)));
    } else {
      print("You cannot send message to yourself");
    }
  }

  @override
  Widget build(BuildContext context) {
    var userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.proSnapshot["User Id"]);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.UserId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            var userDocument = snapshot.data;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height,
                // ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.7,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 60, left: 25),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: InkWell(
                      //       onTap: () => Navigator.pop(context),
                      //       child: SvgPicture.asset(
                      //         "assets/arrow.svg",
                      //         height: 20,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      CarouselSlider(
                        items: imagesUrl
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(top: 70),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          e,
                                          // fit: BoxFit.fill,
                                          height: 300,
                                          width: 200,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          autoPlay: true,
                          height: 270,
                          reverse: false,
                          pageSnapping: true,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                  height: 500,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 16, top: 15),
                        child: Text(
                          widget.proSnapshot["Product Model"],
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Lato",
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 16),
                            child: Text(
                              widget.proSnapshot["Product Name"],
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 30),
                            child: Text(
                              "\u{20B9}" + widget.proSnapshot["Product Price"],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "RAM : ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.proSnapshot["RAM"] + " GB",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Lato",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Text(
                                  "ROM : ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.proSnapshot["ROM"] + " GB",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Lato",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Front Camera : ",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.proSnapshot["Front"] + " MP",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Lato",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Row(
                              children: [
                                Text(
                                  "Back Camera : ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.proSnapshot["Back"] + " MP",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Lato",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 16, top: 15),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 35, right: 16, top: 15),
                        child: Text(
                          widget.proSnapshot["Product Description"],
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Lato",
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3.6,
                            width: double.infinity,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Color(0xfffF1F4FB),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 18, top: 18),
                                        child: CircleAvatar(
                                          radius: 25,
                                          child: ClipOval(
                                            child: SvgPicture.asset(
                                                "assets/male.svg"),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!["Fname"],
                                                  style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(" "),
                                                Text(
                                                  snapshot.data!["Lname"],
                                                  style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              snapshot.data!["Email"],
                                              style: TextStyle(
                                                color: Color(0xfff848484),
                                                fontFamily: "Lato",
                                                fontSize: 14,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(top: 5, left: 75),
                                    child: Container(
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/location.svg",
                                            height: 22,
                                          ),
                                          Text(
                                            snapshot.data!["District"],
                                            style: TextStyle(
                                                fontFamily: "Lato",
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 30),
                                    child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          createChatRoomandStartConversation(
                                              userName: snapshot.data!["Uid"]);
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 340,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF6342E8),
                                            borderRadius:
                                                BorderRadius.circular(56),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/chat.svg',
                                                  color: Colors.white,
                                                  height: 24,
                                                  width: 24,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  "CHAT WITH SELLER",
                                                  style: TextStyle(
                                                    fontFamily: "Lato",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
    // return Scaffold(
    //   backgroundColor: Color(0xfffF1F4FB),
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       // Container(
    //       //   height: MediaQuery.of(context).size.height,
    //       // ),
    //       Container(
    //         height: MediaQuery.of(context).size.height / 2.5,
    //         width: double.infinity,
    //         child: Stack(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(top: 40, left: 25),
    //               child: GestureDetector(
    //                 onTap: () {
    //                   Navigator.pop(context);
    //                 },
    //                 child: SvgPicture.asset(
    //                   "assets/arrow.svg",
    //                   height: 20,
    //                   color: Colors.black,
    //                 ),
    //               ),
    //             ),
    //             CarouselSlider(
    //               items: imagesUrl
    //                   .map(
    //                     (e) => Padding(
    //                       padding: const EdgeInsets.only(top: 70),
    //                       child: ClipRRect(
    //                         borderRadius: BorderRadius.circular(20),
    //                         child: Container(
    //                           child: Stack(
    //                             children: [
    //                               Image.network(
    //                                 e,
    //                                 fit: BoxFit.fill,
    //                                 height: 300,
    //                                 width: 200,
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                   )
    //                   .toList(),
    //               options: CarouselOptions(
    //                 autoPlay: true,
    //                 height: 270,
    //                 reverse: false,
    //                 pageSnapping: true,
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       Container(
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(40),
    //           color: Colors.white,
    //         ),
    //         height: 470,
    //         width: double.infinity,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.only(left: 30, right: 16, top: 15),
    //               child: Text(
    //                 widget.proSnapshot["Product Model"],
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontFamily: "Lato",
    //                 ),
    //               ),
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.only(left: 25, right: 16),
    //                   child: Text(
    //                     widget.proSnapshot["Product Name"],
    //                     style: TextStyle(
    //                         fontSize: 25,
    //                         fontFamily: "Lato",
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(left: 16, right: 30),
    //                   child: Text(
    //                     "\u{20B9}" + widget.proSnapshot["Product Price"],
    //                     style: TextStyle(
    //                         fontSize: 20,
    //                         fontFamily: "Lato",
    //                         fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(
    //               height: 50,
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 30, right: 16, top: 15),
    //               child: Text(
    //                 "Description",
    //                 style: TextStyle(
    //                   fontSize: 16,
    //                   fontFamily: "Lato",
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.only(left: 35, right: 16, top: 15),
    //               child: Text(
    //                 widget.proSnapshot["Product Description"],
    //                 style: TextStyle(
    //                   fontSize: 12,
    //                   fontFamily: "Lato",
    //                 ),
    //               ),
    //             ),
    //             Align(
    //               alignment: Alignment.bottomRight,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Container(
    //                   height: MediaQuery.of(context).size.height / 4,
    //                   width: double.infinity,
    //                   child: Card(
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(20)),
    //                     color: Color(0xfffF1F4FB),
    //                     child: Column(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           children: [
    //                             Padding(
    //                               padding:
    //                                   const EdgeInsets.only(left: 18, top: 18),
    //                               child: CircleAvatar(
    //                                 radius: 25,
    //                                 child: ClipOval(
    //                                   child:
    //                                       SvgPicture.asset("assets/male.svg"),
    //                                 ),
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding:
    //                                   const EdgeInsets.only(left: 15, top: 10),
    //                               child: Column(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.start,
    //                                     children: [
    //                                       Text(
    //                                         userDoc.data["Fname"],
    //                                         style: TextStyle(
    //                                           fontFamily: "Lato",
    //                                           fontSize: 18,
    //                                           fontWeight: FontWeight.bold,
    //                                         ),
    //                                       ),
    //                                       Text(" "),
    //                                       Text(
    //                                         // widget.userSnapshot["Lname"],
    //                                         userDoc.data["Lname"],
    //                                         style: TextStyle(
    //                                           fontFamily: "Lato",
    //                                           fontSize: 18,
    //                                           fontWeight: FontWeight.bold,
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                   Text(
    //                                     userDoc.data["Email"],
    //                                     style: TextStyle(
    //                                       color: Color(0xfff848484),
    //                                       fontFamily: "Lato",
    //                                       fontSize: 14,
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                             ),
    //                             Padding(
    //                               padding:
    //                                   const EdgeInsets.only(top: 10, left: 20),
    //                               child: Container(
    //                                 child: Row(
    //                                   children: [
    //                                     SvgPicture.asset(
    //                                       "assets/location.svg",
    //                                       height: 22,
    //                                     ),
    //                                     Text(
    //                                       "Bhavnagar",
    //                                       style: TextStyle(
    //                                           fontFamily: "Lato",
    //                                           fontSize: 14,
    //                                           fontWeight: FontWeight.bold),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(
    //                               horizontal: 30, vertical: 30),
    //                           child: Center(
    //                             child: InkWell(
    //                               onTap: () {},
    //                               child: Container(
    //                                 height: 50,
    //                                 width: 340,
    //                                 decoration: BoxDecoration(
    //                                   color: Color(0xFFF6342E8),
    //                                   borderRadius: BorderRadius.circular(56),
    //                                 ),
    //                                 child: Center(
    //                                   child: Row(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     children: [
    //                                       SvgPicture.asset(
    //                                         'assets/chat.svg',
    //                                         color: Colors.white,
    //                                         height: 24,
    //                                         width: 24,
    //                                       ),
    //                                       SizedBox(width: 5),
    //                                       Text(
    //                                         "CHAT WITH SELLER",
    //                                         style: TextStyle(
    //                                           fontFamily: "Lato",
    //                                           fontSize: 12,
    //                                           fontWeight: FontWeight.bold,
    //                                           color: Colors.white,
    //                                         ),
    //                                       ),
    //                                     ],
    //                                   ),
    //                                 ),
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
