import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class DatabaseMethods {
  createChatroom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getFriendTokenId(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(userName)
        .get();
  }

  addConverstationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConverstationMessages(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time', descending: false)
        .snapshots();
  }

  getChatRoom(String userName) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();
  }

  getUserByUid(String uid, String userName) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userName)
        .get();
  }

  getProductsBySearch(String searchField) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        // .where("Product Name", : searchField)
        .where(
          'Product Name',
          isGreaterThanOrEqualTo: searchField,
          isLessThan: searchField.substring(0, searchField.length - 1) +
              String.fromCharCode(
                  searchField.codeUnitAt(searchField.length - 1) + 1),
        )
        .get();
  }

  getProductBrand() async {
    return await FirebaseFirestore.instance
        .collection("Categories")
        .snapshots();
  }

  // removeProduct(String productId) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Products")
  //       .where(productId, isEqualTo: )
  //       .snapshots();
  // }

  removeProduct(String productId) async {
    return await FirebaseFirestore.instance
        .collection("Products")
        .doc(productId)
        .delete();
  }
}
