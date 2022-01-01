import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbx/loginpage.dart';
import 'package:mbx/main_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

String finalEmail = "";

class FirstPage extends StatefulWidget {
  FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                "assets/vector.svg",
                height: MediaQuery.of(context).size.height / 5,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/logo.svg",
                  height: 100,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "M",
                        style: TextStyle(fontFamily: "Aquire", fontSize: 35),
                      ),
                    ),
                    Text(
                      "obile",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "E",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "X",
                        style: TextStyle(fontFamily: "Aquire", fontSize: 35),
                      ),
                    ),
                    Text(
                      "change",
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Container(
                    height: 54,
                    width: 222,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3),
                        borderRadius: BorderRadius.circular(56)),
                    child: const Center(
                      child: Text(
                        "LOG IN",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/Line.svg"),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: const Text(
                        "OR",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SvgPicture.asset("assets/Line.svg"),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Container(
                    height: 54,
                    width: 222,
                    decoration: BoxDecoration(
                        color: const Color(0xFFF6342E8),
                        borderRadius: BorderRadius.circular(56)),
                    child: const Center(
                      child: Text(
                        "REGISTER",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                "assets/vector2.svg",
                height: 220,
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future getValidationData() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   var obtainedEmail = sharedPreferences.getString('email');
  //   setState(() {
  //     finalEmail = obtainedEmail!.toString();
  //   });
  //   print(finalEmail);
  // }

  // _userIsSignIn() async {
  //   if (_auth.currentUser != null) {
  //     setState(() {
  //       Navigator.push(
  //           // ignore: prefer_const_constructors
  //           context,
  //           MaterialPageRoute(builder: (context) => const HomePage()));
  //     });
  //   } else {
  //     setState(() {
  //       Navigator.push(
  //           // ignore: prefer_const_constructors
  //           context,
  //           MaterialPageRoute(builder: (context) => FirstPage()));
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   getValidationData().whenComplete(() async {
  //     Get.to(finalEmail == null ? LoginPage() : NavBar());
  //   });
  //   // _userIsSignIn();
  //   super.initState();
  // }
}
