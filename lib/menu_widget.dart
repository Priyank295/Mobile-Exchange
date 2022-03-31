import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mbx/chatList.dart';
import 'package:mbx/loginpage.dart';
import 'package:mbx/profile.dart';
import 'package:mbx/sellpage.dart';
import 'package:mbx/settingsScreen.dart';
import './firstpage.dart';

class MenuWidget extends StatefulWidget {
  // final Function(String)? onItemClick;
  // MenuWidget({required this.onItemClick});
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    var uid = user!.uid;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end:
              Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
          colors: <Color>[
            Color(0xff7F77FE),
            Color(0xffA573FF)
          ], // red to yellow
          //tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData)
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 64,
                          width: 64,
                          child: CircleAvatar(
                            child: snapshot.data!["Profile Pic"] == ""
                                ? (snapshot.data!["Gender"] == "Male"
                                    ? SvgPicture.asset("assets/male.svg")
                                    : SvgPicture.asset("assets/female.svg"))
                                : Image.network(snapshot.data!["Profile Pic"]),
                            radius: 60,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                    "${snapshot.data!["Fname"]}" +
                                        " " +
                                        snapshot.data!["Lname"],
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Lato')),
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  child: SvgPicture.asset(
                                    'assets/edit.svg',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              snapshot.data!["Email"] == ""
                                  ? "+91 " + snapshot.data!["Phone"]
                                  : snapshot.data!["Email"],
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Lato',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => Profile())),
                      child: sliderItem(
                        'Profile',
                        LineIcons.user,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => ChatList())),
                      child: sliderItem(
                        'Chat',
                        Icons.message,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => SellPage())),
                      child: sliderItem(
                        'Sell',
                        LineIcons.plusCircle,
                      ),
                    ),
                    //sliderItem('Notification', LineIcons.bell),
                    InkWell(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => SettingScreen())),
                      child: sliderItem(
                        'Settings',
                        Icons.settings,
                      ),
                    ),
                    //sliderItem('About', LineIcons.exclamationCircle),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () => signOut(),
                            child: sliderItem(
                                'LOG OUT', LineIcons.alternateSignOut)),
                      ],
                    )
                  ],
                );
              return Container();
            },
          )),
    );
  }

  Widget sliderItem(String title, IconData icons) => ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold),
        ),
        leading: Icon(
          icons,
          color: Colors.white,
        ),
      );

  void signOut() async {
    await _auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    });
    _auth.currentUser;
  }
}
