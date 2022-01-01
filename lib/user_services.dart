import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:connectivity/connectivity.dart';

class UserServices {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;

  UserServices() {
    initializeFirebaseApp();
  }

  void initializeFirebaseApp() async {
    bool internetConnection = await checkInternetConnectivity();
    if (internetConnection) {
      await Firebase.initializeApp();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
    }
  }

  Future<void> addUser(String email, String phone, String pass) async {
    CollectionReference users = _firestore.collection("users");
    return users.add({
      'email': email,
      'phone': phone,
      'password': pass,
    }).then((value) {
      final User? currentuser = _auth.currentUser;
      final uid = currentuser!.uid;
      print("USER ADDED ${currentuser}");
    }).catchError((e) => print("Failed to add user: $e"));
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {}
  }

  Future<bool> checkInternetConnectivity() async {
    final Connectivity _connectivity = Connectivity();
    ConnectivityResult result = await _connectivity.checkConnectivity();
    String connection = getConnectionValue(result);
    if (connection == 'None') {
      return false;
    } else {
      return true;
    }
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }
}
