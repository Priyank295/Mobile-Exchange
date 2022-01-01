import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mbx/fill_profile.dart';
import 'package:mbx/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './otppage.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import './user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'navbar.dart';

String uid = "";

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final snackbar = SnackBar(content: Text("Please check details"));
  String verificationCode = "";

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _loading = false;
  bool _isemail = true;
  bool _ispass = true;
  bool _isPhone = true;
  bool _useEmail = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() async {
      return users.add({
        'email': email.text,
        'phone': _phone.text,
        'password': _pass.text,
      }).then((value) {
        setState(() {
          uid = value.id;
        });
        print("USER ADDED ${uid}");
      }).catchError((e) => print("Failed to add user: $e"));
    }

    void loading() {
      LottieBuilder.asset("assets/loading.json");
    }

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2 - 83,
                  color: const Color(0xFFF7F77FE),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Opacity(
                        opacity: 0.20,
                        child: Image.asset(
                          "assets/login2.png",
                          height: 250,
                          width: 200,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: SvgPicture.asset(
                      "assets/arrow.svg",
                      height: 18,
                      width: 18,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 150, left: 45),
                  child: const Text(
                    "Get’s started with MBX.",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    width: 286,
                    margin: const EdgeInsets.only(top: 200, left: 45),
                    child: Row(
                      children: const [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "Lato",
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "Lato",
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 45, top: 280),
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "Email Address",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 45),
              height: 50,
              width: 300,
              child: TextFormField(
                controller: email,
                onChanged: (value) {
                  setState(() {
                    _isemail = EmailValidator.validate(value);
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      "assets/mail.svg",
                    ),
                  ),
                  suffixIcon: _isemail
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        ),
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                  hintText: "Enter your email",
                  hintStyle: const TextStyle(
                    color: Color(0xFFFAEAEAE),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFFD2D2D2),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 5),
                ),
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 45),
              height: 50,
              width: 300,
              child: TextFormField(
                onChanged: (value) {
                  _isPhone = value.length == 10;
                  // _isPhone = value.isNotEmpty;
                },
                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      "assets/phone.svg",
                    ),
                  ),
                  suffixIcon: _isPhone
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.all(12.0),
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        ),
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                  hintText: "Enter your Phone number",
                  hintStyle: const TextStyle(
                    color: Color(0xFFFAEAEAE),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFFFD2D2D2),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                  contentPadding: EdgeInsets.only(top: 5),
                ),
                style: const TextStyle(
                  fontFamily: "Lato",
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Container(
              margin: const EdgeInsets.only(
                left: 45,
              ),
              child: const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: "Lato",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.only(left: 45),
              height: 50,
              width: 300,
              child: Material(
                shadowColor: Color(0xFFF6342E8),
                child: TextField(
                  controller: _pass,
                  onChanged: (value) {
                    _ispass = value.length > 6;
                  },
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        "assets/Lock.svg",
                      ),
                    ),
                    suffixIcon: _ispass
                        ? SizedBox()
                        : Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SvgPicture.asset("assets/WarningCircle.svg"),
                          ),
                    prefixIconConstraints: const BoxConstraints(
                      minHeight: 24,
                      minWidth: 24,
                    ),
                    hintText: "Enter your password",
                    hintStyle: const TextStyle(
                      color: Color(0xFFFAEAEAE),
                      fontFamily: "Lato",
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFFFD2D2D2),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFF6342E8),
                      ),
                    ),
                    contentPadding: const EdgeInsets.only(top: 5),
                  ),
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                  obscureText: true,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () async {
                // getUid();

                isEmailRegistred(email.text);
                setState(() {
                  _loading = true;
                });
                if (isEmailRegistred(email.text) == true) {
                  print("User already exist");
                } else if (_loading == true) {
                  loading();

                  _phone.text.isEmpty ? _isPhone = false : _isPhone = true;
                  email.text.isEmpty ? _isemail = false : _isemail = true;
                  _pass.text.isEmpty ? _ispass = false : _ispass = true;

                  if (_isPhone == false ||
                      // _useEmail == true ||
                      _isemail == false ||
                      _ispass == false) {
                  } else {
                    signUpWithEmail(email.text, _pass.text);
                    // phoneNumberVerification();
                    // addUser();

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtpPage2(
                              Phone: _phone.text,
                              uid: uid,
                              Email: email.text,
                              Pass: _pass.text,
                            )));

                    setState(() {
                      _loading = false;
                    });
                  }
                }
              },
              child: Center(
                child: Container(
                  height: 54,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(56),
                    color: Color(0xFFF6342E8),
                  ),
                  child: const Center(
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Lato",
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              child: const Center(
                child: Text(
                  "By  joining I agree to receive emails from MBX.",
                  style: TextStyle(
                    color: Color(0xFFFA1A1A1),
                    fontFamily: "Lato",
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {}
  }

  Future<bool> isEmailRegistred(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future checkLogin() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('email', email.text);
  }

  // Future<void> getUid() async {
  //   setState(() {
  //     uid = auth.currentUser!.uid;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }
}
