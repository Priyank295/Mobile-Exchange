import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbx/chatList.dart';
import 'package:mbx/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mbx/widget.dart';

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
  Widget ChatMessageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .doc(widget.chatRoomId)
            .collection("chats")
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot doc = snapshot.data!.docs[index];
                    return MessageTile(
                        doc["message"], doc["send by"] == user!.uid);
                  },
                )
              : Container();
        });
  }

  sendMessage() {
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

      messageController.clear();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                child: ClipOval(
                  child: Image.asset("assets/dp2.jpg"),
                ),
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
          leading: Container(
            margin: EdgeInsets.only(left: 8),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          leadingWidth: 25,
        ),
        body: Stack(
          children: [
            SvgPicture.asset(
              "assets/back.svg",
            ),
            ChatMessageList(),
            Align(
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
                        sendMessage();
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
            )
          ],
        ));
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
