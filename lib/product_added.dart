import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mbx/navbar.dart';

class ProductAdded extends StatefulWidget {
  const ProductAdded({Key? key}) : super(key: key);

  @override
  _ProductAddedState createState() => _ProductAddedState();
}

class _ProductAddedState extends State<ProductAdded> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Lottie.asset(
              "assets/done.json",
              height: 400,
              width: 500,
              frameRate: FrameRate(60),
              repeat: true,
            ),
          ),
          Text(
            "Product added successfully...",
            style: TextStyle(
                fontFamily: "Lato", fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 3);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NavBar()));
  }
}
