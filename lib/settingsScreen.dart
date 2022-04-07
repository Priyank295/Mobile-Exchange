import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:mbx/loginpage.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Lato",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        height: 300,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: LineIcon.alternateSignOut(
                        color: Color(0xfff6342E8),
                        size: 30,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => LoginPage()));
                    },
                    child: Container(
                      child: Text(
                        "LOG OUT",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Lato",
                        ),
                      ),
                    ),

                    // Container
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              height: 1,
              width: double.infinity,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15, top: 5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      child: LineIcon.exclamationCircle(
                        color: Color(0xfff6342E8),
                        size: 30,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => LoginPage()));
                    },
                    child: Container(
                      child: Text(
                        "NEED HELP?",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontFamily: "Lato",
                        ),
                      ),
                    ),

                    // Container
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              height: 1,
              width: double.infinity,
            ),

            /// SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
