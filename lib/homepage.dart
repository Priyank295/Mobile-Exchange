// import "package:flutter/material.dart";
// import 'package:google_nav_bar/google_nav_bar.dart';
// import 'package:mbx/loginpage.dart';
// import 'package:quiver/core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         Center(
//           child: Text(
//             "WELCOME TO HOME PAGE",
//             style: TextStyle(
//               color: Colors.black,
//               fontFamily: "Lato",
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         Button(
//           onPressed: () {
//             _auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (ctx) => LoginPage()),
//                 (route) => false));
//           },
//           text: Text("SIGN OUT"),
//         ),
//       ],
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:mbx/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiver/core.dart  ';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("WELCOME TO HOME PAGE"),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _auth.signOut().then((value) => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (ctx) => LoginPage()),
                    (route) => false));
              },
              child: Container(
                height: 50,
                width: 120,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "SIGN OUT",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
