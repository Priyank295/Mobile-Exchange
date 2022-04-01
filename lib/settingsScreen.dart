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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: LineIcon.alternateSignOut(
                      color: Colors.black,
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
                ),
              ],
            ),

            /// SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
