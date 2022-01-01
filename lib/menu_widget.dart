import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mbx/loginpage.dart';
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
        body: Column(
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
                    backgroundImage: AssetImage('assets/dp.jpg'),
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
                        Text('Priyank Vaghela',
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
                      'priyankvaghela@gmail.com',
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
            sliderItem('Profile', LineIcons.user),
            sliderItem('Cart', LineIcons.shoppingCart),
            sliderItem('Sell', LineIcons.plusCircle),
            sliderItem('Notification', LineIcons.bell),
            sliderItem('Settings', Icons.settings),
            sliderItem('About', LineIcons.exclamationCircle),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () => signOut(),
                    child: sliderItem('LOG OUT', LineIcons.alternateSignOut)),
              ],
            )
          ],
        ),
      ),
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
