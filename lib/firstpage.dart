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
      body: Stack(
        children: [
          SvgPicture.asset(
            "vector1.svg",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                height: 30,
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
                height: 30,
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
        ],
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
