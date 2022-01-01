import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:mbx/main_widget.dart';
import 'package:mbx/navbar.dart';

enum Gender { male, female }

class Fill_Profile extends StatefulWidget {
  String uid;
  Fill_Profile({required this.uid});
  @override
  _Fill_ProfileState createState() => _Fill_ProfileState();
}

class _Fill_ProfileState extends State<Fill_Profile> {
  Gender? _gender = Gender.male;
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _zip = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  int _radioSelected = 1;
  late String _radioVal;
  bool male = false;
  bool female = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  color: Color(0xFFF7F77FE),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, left: 17),
                        child: const Text(
                          "PROFILE",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 50,
                        ),
                        child: SvgPicture.asset(
                          "assets/profile.svg",
                          height: 237,
                          width: 274,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "First Name",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 45),
              height: 50,
              width: 300,
              child: TextField(
                controller: _fname,
                decoration: InputDecoration(
                  suffixIcon: _fname.text.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        )
                      : SizedBox(),
                  hintText: "Enter your First Name",
                  hintStyle: const TextStyle(
                    color: Color(0xFFFAEAEAE),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFFD2D2D2),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 5, left: 15),
                ),
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "Last Name",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 45),
              height: 50,
              width: 300,
              child: TextField(
                controller: _lname,
                decoration: InputDecoration(
                  suffixIcon: _lname.text.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        )
                      : SizedBox(),
                  hintText: "Enter your Last Name",
                  hintStyle: const TextStyle(
                    color: Color(0xFFFAEAEAE),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFFD2D2D2),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 5, left: 15),
                ),
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "Address",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 45),
              height: 50,
              width: 300,
              child: TextField(
                controller: _address,
                decoration: InputDecoration(
                  suffixIcon: _address.text.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        )
                      : SizedBox(),
                  hintText: "Enter your address",
                  hintStyle: const TextStyle(
                    color: Color(0xFFFAEAEAE),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFFD2D2D2),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 5, left: 15),
                ),
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "Zip Code",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(left: 45),
              height: 80,
              width: 300,
              child: TextField(
                controller: _zip,
                // ignore: deprecated_member_use

                maxLength: 6,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: _zip.text.isEmpty && _zip.text.length <= 6
                      ? Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        )
                      : SizedBox(),
                  hintText: "Enter your Zipcode",
                  hintStyle: const TextStyle(
                    color: Color(0xFFFAEAEAE),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFFD2D2D2),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 5, left: 15),
                ),
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 12,
                ),
              ),
            ),
            //RADIO BUTTONS
            // Row(
            //   children: [
            //     RadioListTile(
            //         value: Gender.male,
            //         title: const Text(
            //           'Male',
            //           style: TextStyle(
            //             fontFamily: "Lato",
            //             fontSize: 12,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         groupValue: _gender,
            //         onChanged: (Gender? val) {
            //           setState(() {
            //             _gender = val;
            //           });
            //         }),
            //   ],
            // )
            // Container(
            //   child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text('Male'),
            //         Radio(
            //           value: 1,
            //           groupValue: _radioSelected,
            //           activeColor: Colors.blue,
            //           onChanged: (value) {
            //             setState(() {
            //               _radioSelected = value;
            //               _radioVal = 'male';
            //             });
            //           },
            //         ),
            //         Text('Female'),
            //         Radio(
            //           value: 2,
            //           groupValue: _radioSelected,
            //           activeColor: Colors.pink,
            //           onChanged: (value) {
            //             setState(() {
            //               _radioSelected = value;
            //               _radioVal = 'female';
            //             });
            //           },
            //         )
            //       ],
            //     ),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text(
                    "Male",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomCheckBox(
                  value: male,
                  onChanged: (value) => setState(() {
                    this.male = value;
                  }),
                  borderColor: Color(0xFFFE0E0E0),
                  checkedIconColor: Color(0xFFF6342E8),
                  checkedFillColor: Colors.white,
                  borderWidth: 2,
                  shouldShowBorder: true,
                  splashRadius: 2,
                ),
                Container(
                  child: const Text(
                    "Female",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomCheckBox(
                  value: female,
                  onChanged: (value) => setState(() {
                    this.female = value;
                  }),
                  borderColor: Color(0xFFFE0E0E0),
                  checkedIconColor: Color(0xFFF6342E8),
                  checkedFillColor: Colors.white,
                  borderWidth: 2,
                  shouldShowBorder: true,
                  splashRadius: 2,
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  log("DOC ID : + ${widget.uid}");
                  updateData();
                },
                child: Container(
                  height: 54,
                  width: 324,
                  decoration: BoxDecoration(
                      color: Color(0xFFF6342E8),
                      borderRadius: BorderRadius.circular(56)),
                  child: const Center(
                    child: Text(
                      "COMPLETE PROFILE",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> addData() async {
  //   final uid = firebaseUser!.uid;
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set(
  //     {
  //       "Fname": _fname.text,
  //       "Lname": _lname.text,
  //       "Address": _address.text,
  //       "Zip": _zip.text,
  //     },
  //     SetOptions(merge: true),
  //   ).then((_) => print("Data Stored successfully!"));
  // }

  Future<void> updateData() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.uid).update(
      {
        "Fname": _fname.text,
        "Lname": _lname.text,
        "Address": _address.text,
        "Zip": _zip.text,
      },
    ).then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    });
  }
}
