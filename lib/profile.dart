import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mbx/profile_update.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
late Map<String, dynamic> userData;
User? user = FirebaseAuth.instance.currentUser;
var userid = user!.uid;
bool email = emailIsEmpty();
bool phone = phoneIsEmpty();

bool emailIsEmpty() {
  return user!.email!.isNotEmpty;
}

bool phoneIsEmpty() {
  return user!.phoneNumber!.isNotEmpty;
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // getData() async {
    //   // FirebaseFirestore.instance
    //   //     .collection("users")
    //   //     .doc(userid)
    //   //     .get()
    //   //     .then((DocumentSnapshot doc) {
    //   //   print(doc.data);
    //   // });
    //   final data = await FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(userid)
    //       .get();
    //   for (var docData in data["fname"]) {
    //     print(docData.data());
    //   }
    // }

    // if (userid != null) {
    //   getData();
    // }

    //  Map<String,dynamic>? data = snapshot.data!();

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            // Map<String, dynamic> data = snapshot.data! as Map<String, dynamic>;
            //  final List<String> nameList = snapshot.data;
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/rectangle3.svg",
                          height: 300,
                          alignment: Alignment.topLeft,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 40, left: 20),
                            //   child: SvgPicture.asset("assets/arrow.svg"),
                            // ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40, right: 20),
                              child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => ProfileUpdate())),
                                  child: SvgPicture.asset("assets/edit2.svg")),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 120, left: 50),
                              child: Container(
                                child: Text(snapshot.data!["Fname"],
                                    style: TextStyle(
                                        fontFamily: "Lato",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 120),
                              child: Container(
                                child: Text(snapshot.data!["Lname"],
                                    style: TextStyle(
                                        fontFamily: "Lato",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 80, left: 220),
                          child: Container(
                            height: 130,
                            child: ClipOval(
                              child: snapshot.data!["Profile Pic"] == ""
                                  ? SvgPicture.asset("assets/male.svg")
                                  : Image.network(
                                      snapshot.data!["Profile Pic"]),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: SvgPicture.asset(
                              "assets/email.svg",
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Email",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfffABABAB))),
                              snapshot.data!["Email"] == ""
                                  ? Text("",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfff000000)))
                                  : Text(snapshot.data!["Email"],
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfff000000)))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: SvgPicture.asset(
                              "assets/phone2.svg",
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Phone",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfffABABAB))),
                              snapshot.data!["Phone"] == ""
                                  ? Text("",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfff000000)))
                                  : Text("+91-${snapshot.data!["Phone"]}",
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xfff000000)))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: SvgPicture.asset(
                              "assets/id.svg",
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Address",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfffABABAB))),
                              Text(snapshot.data!["Address"],
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff000000)))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: SvgPicture.asset(
                              "assets/gender.svg",
                              height: 30,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Gender",
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfffABABAB))),
                              Text(snapshot.data!["Gender"],
                                  style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xfff000000)))
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        color: Colors.black,
                        height: 0.2,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/mobile.svg",
                            height: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("My Products for sell",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfff000000))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        color: Colors.black,
                        height: 0.2,
                        width: double.infinity,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/settings.svg",
                            height: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Settings",
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xfff000000))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        color: Colors.black,
                        height: 0.2,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Text("LOading");
        });
  }

  // @override
  // void initState() {
  //   super.initState();

  //   setState(() {
  //     getData();
  //   });
  // }
}
