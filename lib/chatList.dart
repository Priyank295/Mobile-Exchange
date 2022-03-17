import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbx/chatScreen.dart';
import 'package:mbx/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;

String chatUser = "";

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Widget chatRoomList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("ChatRoom")
            .where("users", arrayContains: user!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    String userName = snapshot.data!.docs[index]["chatroomId"]
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(user!.uid, "");

                    DatabaseMethods()
                        .getUserByUid(user!.uid, userName)
                        .then((value) {
                      setState(() {
                        chatUser = value["Fname"];
                        chatUser = chatUser + " " + value["Lname"];
                      });
                    });

                    return ChatRoomTile(
                        chatUser, snapshot.data?.docs[index]["chatroomId"]);
                  },
                )
              : Container();
        });
  }

  // @override
  // initState() {
  //   WidgetsBinding.instance!.addObserver(this);
  //   // DatabaseMethods().getUserInfogetChatsFromFirebase().then((value) {
  //   //   setState(() {
  //   //     chatRooms=value;
  //   //   });
  //   // });
  //   getUserInfogetChats();
  //   DatabaseMethods().updateUserStatusToOnline();
  //   new Timer.periodic(Duration(seconds: 10), (Timer t) {
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   });
  //   final fbm = FirebaseMessaging();
  //   fbm.requestNotificationPermissions();
  //   fbm.configure(
  //     onMessage: (message) {. n
  //       print(message);
  //     },
  //     onLaunch: (message) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => Chat(
  //                     chatRoomId: message['chatRoomId'],
  //                     userId: message['userName'],
  //                   )));
  //       print(message);
  //     },
  //     onResume: (message) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => Chat(
  //                       chatRoomId: message["data"]["chatRoomId"],
  //                       userId: message["data"]["userId"],
  //                     )));
  //       });
  //       print(message);
  //     },
  //   );
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xfffE7E3F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("CHAT",
            style: TextStyle(fontFamily: "Lato", color: Colors.black)),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => ChatScreen(chatRoomId, userName)));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 56,
                  height: 55,
                  alignment: Alignment.center,
                  child: ClipOval(
                    child: SvgPicture.asset("assets/male.svg"),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  chatUser,
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 0.5,
          width: double.infinity,
          color: Color(0xfffC4c4c4),
        )
      ],
    );
  }
}
