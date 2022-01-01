import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart';
import 'package:mbx/fill_profile.dart';
import 'package:mbx/firstpage.dart';
import 'package:mbx/home.dart';
import 'package:mbx/main_widget.dart';
import 'package:mbx/navbar.dart';
import 'package:mbx/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './otppage.dart';
import 'package:mbx/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './otppage.dart';
import './register.dart';
import './user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var email = sharedPreferences.getString('email');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print("User is currently Sign out");
      } else {
        print("User is sign in...");
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? FirstPage() : NavBar(),
      routes: {
        "/login": (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
