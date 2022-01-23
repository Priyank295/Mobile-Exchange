import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffff2f1f7),
        body: Stack(
          children: [
            SvgPicture.asset(
              "assets/back.svg",
              height: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  height: 90,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35, left: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/arrow.svg",
                          color: Colors.black,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          width: 44,
                          height: 45,
                          child: ClipOval(
                            child: Image.asset("assets/dp2.jpg"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            "PRIYANK VAGHELA",
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                            color: Color(0xfffF9F9F9),
                            border: Border.all(
                              width: 1,
                              color: Color(0xfffDFE4EA),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        height: 48,
                        width: 287,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Type your message",
                            border: InputBorder.none,
                            hintStyle: TextStyle(fontFamily: "Lato"),

                            // prefixIcon: SvgPicture.asset(
                            //   "assets/image.svg",
                            // ),
                            contentPadding: EdgeInsets.only(left: 15),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        height: 48,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Color(0xfff7E72F2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset("assets/send.svg"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ));
  }
}
