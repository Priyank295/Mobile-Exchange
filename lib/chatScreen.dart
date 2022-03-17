import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:mbx/chatList.dart';
import 'package:mbx/constants.dart';
import 'package:mbx/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbx/widget.dart';
import './chatList.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

TextEditingController messageController = new TextEditingController();
User? user = FirebaseAuth.instance.currentUser;
late Stream chatMessagesStream;

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  String chatRoomId;
  String userName;
  ChatScreen(this.chatRoomId, this.userName);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int chatListLength = 20;
  double _scrollPosition = 560;
  final ScrollController _controller = ScrollController();
  var listViewKey = RectGetter.createGlobalKey();
  late DocumentSnapshot Docsnapshot;
  String tokenId = "";

  _scrollListener() {
    setState(() {
      if (_scrollPosition < _controller.position.pixels) {
        _scrollPosition = _scrollPosition + 560;
        chatListLength = chatListLength + 20;
      }
      //print('list view position is $_scrollPosition');
    });
  }

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": Constants
            .kAppId, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9976D2",

        "small_icon": "ic_stat_onesignal_default",

        "large_icon":
            "https://www.google.com/search?q=image&rlz=1C1CHBF_enIN976IN976&sxsrf=APq-WBsoKyxT4pjp5Amo2G6koXBcS-0-Bw:1647419270535&tbm=isch&source=iu&ictx=1&vet=1&fir=ItY9cBsepnqjwM%252C0JWe7yDOKrVFAM%252C_%253BDH7p1w2o_fIU8M%252CBa_eiczVaD9-zM%252C_%253Bn5hAWsQ-sgKo_M%252C-UStXW0dQEx4SM%252C_%253Bz4_uU0QB2pe-SM%252C7SySw5zvOgPYAM%252C_%253B2DNOEjVi-CBaYM%252CAOz9-XMe1ixZJM%252C_%253BMOAYgJU89sFKnM%252CygIoihldBPn-LM%252C_%253BxE4uU8uoFN00aM%252CpEU77tdqT8sGCM%252C_%253BqXynBYpZpHkhWM%252C4O2GvGuD-Cf09M%252C_%253B0DzWhtJoQ1KWgM%252CcIQ7wXCEtJiOWM%252C_%253BbDjlNH-20Ukm8M%252CG9GbNX6HcZ2O_M%252C_%253BY6pVL1x5vDTXyM%252C6CoFeFXzCIyxLM%252C_%253BA4G7eW2zetaunM%252Cl3NoP295SYrYvM%252C_%253BgOUAFhrbQ2nYQM%252COXvyXJop1qSGqM%252C_&usg=AI4_-kTgRCZODGPFumpxk-06nrzQR87r3w&sa=X&ved=2ahUKEwiUhqqDm8r2AhU4T2wGHZqBBTAQ9QF6BAgpEAE#imgrc=0DzWhtJoQ1KWgM",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  Widget ChatMessageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return MessageTile(
                          doc["message"], doc["send by"] == user!.uid);
                    },
                  ),
                )
              : Container();
        });
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "send by": user!.uid,
        "time": Timestamp.now().microsecondsSinceEpoch,
      };
      setState(() {
        DatabaseMethods()
            .addConverstationMessages(widget.chatRoomId, messageMap);
      });

      // await DatabaseMethods()
      //     .getFriendTokenId(widget.userName)
      //     .then((snapshot) {
      //   Docsnapshot = snapshot;
      //   setState(() {
      //     print(Docsnapshot["Fname"]);
      //   });
      // });

      messageController.clear();
      print("Hello");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(_scrollListener);
    DatabaseMethods().getConverstationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffF9F9F9),
        // title: Text(
        //   widget.userName,
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontSize: 20,
        //     fontFamily: "Lato",
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              // margin: EdgeInsets.only(left: 15),
              width: 40,
              height: 40,
              child: ClipOval(child: SvgPicture.asset("assets/male.svg")),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.userName,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Lato",
                    // fontWeight: FontWeight.bold,
                    fontSize: 17)),
          ],
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        leadingWidth: 25,
      ),
      body: Column(
        children: [
          // SvgPicture.asset(
          //   "assets/back.svg",
          // ),

          ChatMessageList(),
          Container(
            child: Align(
              alignment: Alignment.bottomRight,
              child: Container(
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
                        controller: messageController,
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
                    GestureDetector(
                      onTap: () {
                        print(widget.chatRoomId);

                        // setState(() {
                        //   sendMessage();
                        //   _scrollDown();
                        //   sendNotification(
                        //       ["e3acd5e6-a4fc-11ec-958f-16349383fd8f"],
                        //       messageController.text,
                        //       "PRiyank Vaghela ");

                        //   OneSignal.shared.setExternalUserId(widget.userName,
                        //       "e3acd5e6-a4fc-11ec-958f-16349383fd8f");

                        //       OneSignal.shared.
                        // });
                      },
                      child: Container(
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
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 0 : 20, right: isSendByMe ? 20 : 0, top: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSendByMe
                  ? [Color(0xfff7E72F2), Color(0xfff7E72F2).withOpacity(0.6)]
                  : [Color(0xfff2C3350), Color(0xfff2C3350)],
            ),
            borderRadius: BorderRadius.circular(8)),
        child: Text(message,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Lato",
              fontSize: 16,
            )),
      ),
    );
  }
}
