// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mbx/fill_profile.dart';
import 'package:mbx/main_widget.dart';
import 'package:mbx/navbar.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:otp_text_field/style.dart';
import './register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pin_put/pin_put_state.dart';
import './navbar.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class OtpPage2 extends StatefulWidget {
  String Phone = "";
  String Email;
  String Pass;
  late String uid;

  OtpPage2(
      {Key? key,
      required this.Phone,
      required this.uid,
      required this.Email,
      required this.Pass})
      : super(key: key);

  @override
  _OtpPage2State createState() => _OtpPage2State();
}

class _OtpPage2State extends State<OtpPage2> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController otptext = TextEditingController();
  final FocusNode _otpnode = FocusNode();
  String _verificationCode = "";

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.deepPurpleAccent),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      "assets/arrow.svg",
                      height: 18,
                      width: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 120,
            ),
            Column(
              children: [
                Container(
                  child: SvgPicture.asset(
                    "assets/msg.svg",
                    height: 170,
                    width: 189,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                child: const Text(
                  "OTP Verification",
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                child: Text(
                  "Enter the OTP sent to +91-${widget.Phone}",
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: PinPut(
                  onSubmit: (pin) async {
                    try {
                      await _auth
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                        if (value.user != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Fill_Profile(uid: uid),
                            ),
                          );
                        }
                      });
                    } catch (e) {
                      FocusScope.of(context).unfocus();
                      _scaffoldKey.currentState!.showSnackBar(
                          const SnackBar(content: Text('invalid OTP')));
                    }
                  },
                  fieldsCount: 6,
                  textStyle: const TextStyle(
                    fontSize: 17,
                    fontFamily: "Lato",
                    fontWeight: FontWeight.bold,
                  ),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 55.0,
                  controller: otptext,
                  focusNode: _otpnode,
                  selectedFieldDecoration: _pinPutDecoration,
                  submittedFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  followingFieldDecoration: _pinPutDecoration.copyWith(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(.5),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 54,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(56),
                color: Color(0xFFF6342E8),
              ),
              child: FlatButton(
                  onPressed: () async {
                    (pin) async {
                      try {
                        await _auth
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: _verificationCode,
                                smsCode: pin))
                            .then((value) async {
                          if (value.user != null) {
                            if (user == null) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Fill_Profile(uid: value.user!.uid)),
                                  (route) => false);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavBar()),
                                  (route) => false);
                            }
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        _scaffoldKey.currentState!.showSnackBar(
                            const SnackBar(content: Text('invalid OTP')));
                      }
                    };
                  },
                  child: const Text(
                    "VERIFY",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Don’t receive the OTP?",
                    style: TextStyle(fontFamily: "Lato", fontSize: 18),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    _verifyPhone();
                  },
                  child: Text(
                    "RESEND OTP",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 18,
                      color: Color(0xFFF6342E8),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void displayMessage(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  User? user = _auth.currentUser;

  _verifyPhone() async {
    await _auth.verifyPhoneNumber(
        phoneNumber: "+91${widget.Phone}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            FirebaseFirestore.instance
                .collection("users")
                .doc(value.user!.uid)
                .set({
              "Uid": value.user!.uid,
              "Email": widget.Email,
              "Phone": widget.Phone,
              "Password": widget.Pass,
            });
            if (value.user != null) {
              print(value.user!.uid);

              if (user == null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Fill_Profile(uid: value.user!.uid)),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => NavBar()),
                    (route) => false);
              }
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    super.initState();
    _verifyPhone();
  }
}
