import "package:flutter/material.dart";

Widget appBarMain(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    title: Text("name", style: TextStyle(color: Colors.black, fontSize: 20)),
    leading: Container(
      margin: EdgeInsets.only(left: 15),
      width: 44,
      height: 45,
      child: ClipOval(
        child: Image.asset("assets/dp2.jpg"),
      ),
    ),
  );
}
