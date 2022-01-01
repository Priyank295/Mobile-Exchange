import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mbx/cart.dart';
import 'package:mbx/edit_profile.dart';
import 'package:mbx/firstpage.dart';
import 'package:mbx/loginpage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mbx/searchpage.dart';
import './home.dart';
import './sellpage.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _index = 0;

  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 5;

  List<Color> colors = [
    Colors.purple,
    Colors.pink,
    Colors.red,
    Colors.grey,
    Colors.teal,
  ];

  // List<Text> text = [
  //   Text("Home"),
  //   Text("Search"),
  //   Text("Cart"),
  //   Text("Profile"),
  // ];

  List<Widget> screen = [
    Home(),
    Search(),
    SellPage(),
    Cart(),
    EditProfile(),
  ];
  PageController controller = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: GNav(
                curve: Curves.easeOutExpo, // tab animation curves
                duration: Duration(milliseconds: 900), // tab animation duration
                gap: 8, // the tab button gap between icon and text
                color: Colors.grey[800], // unselected icon color
                activeColor: Colors.purple, // selected icon and text color
                iconSize: 24, // tab button icon size
                tabBackgroundColor: Colors.purple
                    .withOpacity(0.1), // selected tab background color
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    iconColor: Colors.black,
                    iconActiveColor: Colors.purple,
                    text: 'Home',
                    textColor: Colors.purple,
                    backgroundColor: Colors.purple.withOpacity(0.2),
                    //  iconSize: 24,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                  GButton(
                    icon: LineIcons.search,
                    iconColor: Colors.black,
                    iconActiveColor: Colors.pink,
                    text: 'Search',
                    textColor: Colors.pink,
                    backgroundColor: Colors.pink.withOpacity(0.2),
                    // iconSize: 24,
                    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                  GButton(
                    icon: LineIcons.plusCircle,
                    iconColor: Colors.black,
                    iconActiveColor: Colors.red,
                    text: 'Sell',
                    textColor: Colors.red,
                    backgroundColor: Colors.red.withOpacity(0.2),
                    //iconSize: 24,
                    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                  GButton(
                    icon: LineIcons.shoppingCart,
                    iconColor: Colors.black,
                    iconActiveColor: Colors.grey,
                    text: 'Cart',
                    textColor: Colors.grey,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    //iconSize: 24,
                    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                  GButton(
                    icon: LineIcons.user,
                    iconColor: Colors.black,
                    iconActiveColor: Colors.teal,
                    text: 'Profile',
                    textColor: Colors.teal,
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    // iconSize: 24,
                    //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  ),
                ],

                selectedIndex: _index,
                onTabChange: (index) {
                  setState(() {
                    _index = index;
                    controller.jumpToPage(index);
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: Scaffold(
        body: PageView.builder(
            itemCount: 5,
            controller: controller,
            onPageChanged: (page) {
              setState(() {
                _index = page;
              });
            },
            itemBuilder: (context, position) {
              return Container(
                color: colors[position],
                child: Center(child: screen[position]),
              );
            }),
      ),
    );
  }

  void signOut() async {
    await _auth.signOut().then((value) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => FirstPage())));
    _auth.currentUser;
  }
}
