import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:mbx/loadingScreen.dart';
import 'package:mbx/main_widget.dart';
import 'package:mbx/navbar.dart';
import 'package:mbx/otppage.dart';
import 'package:mbx/resetPasswordScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

enum SigInOptionState {
  SHOW_PHONE_VERIFICATION,
  SHOE_EMAIL_VERIFICATION,
}

bool _loading = false;
String uid = "";
var dataList;
var currentState = SigInOptionState.SHOE_EMAIL_VERIFICATION;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController _email = TextEditingController();
TextEditingController _pass = TextEditingController();
TextEditingController _phone = TextEditingController();
GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class _LoginPageState extends State<LoginPage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool value = false;
  String userEmail = "";
  bool _success = false;
  bool _isPhone = true;
  bool _isEmail = true;
  bool _isPass = true;
  String Email = "";
  String Pass = "";
  bool isPhone(String input) =>
      RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
          .hasMatch(input);
  bool isEmail(String input) => EmailValidator.validate(input);
  final _key = (GlobalKey<FormFieldState>());

  final FirebaseAuth _auth = FirebaseAuth.instance;

  getPhoneSignIn(context) {
    return _loading
        ? LoadingScreen()
        : Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                        color: const Color(0xFFF7F77FE),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 60, left: 20),
                          child: SvgPicture.asset(
                            "assets/arrow.svg",
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 100),
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
                        margin: const EdgeInsets.only(top: 150, left: 45),
                        child: const Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        width: 286,
                        margin: const EdgeInsets.only(top: 200, left: 45),
                        child: const Text(
                          "Yay! You're back! Thanks for shopping with us. We have excited deals and promotions going on, grab your pick now!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "Lato",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 45, top: 320),
                        child: const Text(
                          "LOG IN",
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
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 45, top: 65),
                    child: const Text(
                      "Phone number",
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
                    height: 80,
                    width: 300,
                    child: TextFormField(
                      onChanged: (value) {
                        _isPhone = value.length == 10;
                      },
                      key: _key,
                      // validator: (val) {
                      //   if (!isEmail(val!) && !isPhone(val)) {
                      //     setState(() {
                      //       _isEmail = false;
                      //     });
                      //   }
                      // },
                      controller: _phone,
                      maxLength: 10,
                      keyboardType: TextInputType.number,

                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/phone.svg",
                          ),
                        ),
                        suffixIcon:
                            _phone.text.isEmpty || _phone.text.length < 10
                                ? Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: SvgPicture.asset(
                                        "assets/WarningCircle.svg"),
                                  )
                                : SizedBox(),
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
                  const SizedBox(height: 20),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _loading = true;
                      });
                      _phone.text.isEmpty ? _isPhone = false : _isPhone = true;

                      if (_isPhone == false) {
                        setState(() {
                          _loading = false;
                        });
                      } else {
                        setState(() {
                          _loading = true;
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtpPage2(
                                    Phone: _phone.text,
                                    Email: Email,
                                    Pass: Pass)));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 45, top: 40),
                      height: 54,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color(0xFFF6342E8),
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: const Center(
                        child: Text(
                          "SEND OTP",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _phone.clear();
                        currentState = SigInOptionState.SHOE_EMAIL_VERIFICATION;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 45),
                      height: 54,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: const Center(
                        child: Text(
                          "SIGN IN WITH EMAIL",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text(
                            "Not registered yet?",
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 12,
                              color: Color(0xFFFA1A1A1),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Container(
                            child: const Text(
                              "Create an Account",
                              style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 12,
                                color: Color(0xFFF6342E8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  getEmailSignIn(context) {
    return _loading
        ? LoadingScreen()
        : Scaffold(
            key: _scaffoldKey,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.2,
                        color: const Color(0xFFF7F77FE),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 60, left: 20),
                          child: SvgPicture.asset(
                            "assets/arrow.svg",
                            height: 18,
                            width: 18,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 100),
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
                        margin: const EdgeInsets.only(top: 150, left: 45),
                        child: const Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        width: 286,
                        margin: const EdgeInsets.only(top: 200, left: 45),
                        child: const Text(
                          "Yay! You're back! Thanks for shopping with us. We have excited deals and promotions going on, grab your pick now!",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontFamily: "Lato",
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 45, top: 320),
                        child: const Text(
                          "LOG IN",
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
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 45,
                    ),
                    child: const Text(
                      "Email address",
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
                        dataList = FirebaseFirestore.instance
                            .collection("users")
                            .snapshots();
                      },
                      key: _key,
                      // validator: (val) {
                      //   if (!isEmail(val!) && !isPhone(val)) {
                      //     setState(() {
                      //       _isEmail = false;
                      //     });
                      //   }
                      // },
                      controller: _email,
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/mail.svg",
                          ),
                        ),
                        suffixIcon: _isEmail
                            ? SizedBox()
                            : Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SvgPicture.asset(
                                    "assets/WarningCircle.svg"),
                              ),
                        prefixIconConstraints: const BoxConstraints(
                          minHeight: 24,
                          minWidth: 24,
                        ),
                        hintText: "Enter your Email address",
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
                  const SizedBox(height: 20),
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
                      child: TextFormField(
                        // key: _formKey,
                        controller: _pass,
                        // validator: (val) {
                        //   if (val!.isEmpty) {
                        //     return "Please enter Password";
                        //   }
                        // },
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset(
                              "assets/Lock.svg",
                            ),
                          ),
                          suffixIcon: _isPass
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: SvgPicture.asset(
                                      "assets/WarningCircle.svg"),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30, top: 5),
                        child: Row(
                          children: [
                            CustomCheckBox(
                              value: value,
                              onChanged: (value) => setState(() {
                                this.value = value;
                              }),
                              borderColor: Color(0xFFFE0E0E0),
                              checkedIconColor: Color(0xFFF6342E8),
                              checkedFillColor: Colors.white,
                              borderWidth: 1,
                              shouldShowBorder: true,
                              splashRadius: 1,
                            ),
                            Container(
                              child: const Text(
                                "Remember me",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (ctx) => ResetPassword()));
                          setState(() {
                            _loading = true;
                          });
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ResetPassword()));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, right: 47),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Color(0xFFF6342E8),
                              fontSize: 12,
                              fontFamily: "Lato",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _loading = true;
                      });
                      // StreamBuilder(
                      //   stream: dataList,
                      //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      //     for (int i = 0; i < snapshot.data!.docs.length; i++) {
                      //       DocumentSnapshot doc = snapshot.data!.docs[i];
                      //       if (doc["Phone"] == _email.text) {
                      //         print("Phone is already exist");
                      //       } else {
                      //         print("success");
                      //       }
                      //     }
                      //     return Container();
                      //   },
                      // );
                      _email.text.isEmpty ? _isEmail = false : _isEmail = true;
                      _pass.text.isEmpty ? _isPass = false : _isPass = true;

                      if (_isEmail == false || _isPass == false) {
                        setState(() {
                          _loading = false;
                        });
                      } else {
                        try {
                          setState(() {
                            _loading = true;
                          });
                          _auth
                              .signInWithEmailAndPassword(
                                  email: _email.text, password: _pass.text)
                              .then((value) {
                            print(value.user!.uid +
                                "YOU ARE SUCCESSFULLY LOGED IN");
                            _email.clear();
                            _pass.clear();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (ctx) => NavBar()),
                                (route) => false);
                          });
                        } catch (e) {
                          setState(() {
                            _loading = false;
                          });
                          FocusScope.of(context).unfocus();
                          _scaffoldKey.currentState!.showSnackBar(
                              const SnackBar(
                                  content: Text("USER IS NOT VALID")));
                        }
                      }
                      // final uid = _auth.currentUser!.uid;
                      // if (!isEmail(_email.text) && !isPhone(_email.text)) {
                      //   setState(() {
                      //     _isEmail = false;
                      //   });
                      // }
                      // _email.text.isEmpty ? _isEmail = false : _isEmail = true;
                      // _pass.text.isEmpty ? _isPass = false : _isPass = true;

                      // if (_isEmail == false || _isPass == false) {
                      //   // } else if (_formKey.currentState!.validate()) {
                      // } else {
                      //   if (_email.text.contains("@")) {
                      //     _signInWithEmail();
                      //   } else {
                      //     //  signInWithPhone();

                      //   }

                      //   // if (_success == true) {
                      //   //   Navigator.push(context,
                      //   //       MaterialPageRoute(builder: (context) => HomePage()));
                      //   // }
                      // }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 45),
                      height: 54,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Color(0xFFF6342E8),
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: const Center(
                        child: Text(
                          "LOG IN",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _email.clear();
                        _pass.clear();
                        currentState = SigInOptionState.SHOW_PHONE_VERIFICATION;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 45),
                      height: 54,
                      width: 300,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(56),
                      ),
                      child: const Center(
                        child: Text(
                          "SIGN IN WITH PHONE NUMBER",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: const Text(
                            "Not registered yet?",
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 12,
                              color: Color(0xFFFA1A1A1),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Container(
                            child: const Text(
                              "Create an Account",
                              style: TextStyle(
                                fontFamily: "Lato",
                                fontSize: 12,
                                color: Color(0xFFF6342E8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return currentState == SigInOptionState.SHOE_EMAIL_VERIFICATION
        ? getEmailSignIn(context)
        : getPhoneSignIn(context);
    // return Scaffold(
    //   key: _scaffoldKey,
    //   body: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Stack(
    //           children: [
    //             Container(
    //               height: MediaQuery.of(context).size.height / 2,
    //               color: const Color(0xFFF7F77FE),
    //             ),
    //             GestureDetector(
    //               onTap: () {
    //                 Navigator.pop(context);
    //               },
    //               child: Container(
    //                 margin: const EdgeInsets.only(top: 60, left: 20),
    //                 child: SvgPicture.asset(
    //                   "assets/arrow.svg",
    //                   height: 18,
    //                   width: 18,
    //                 ),
    //               ),
    //             ),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.end,
    //               children: [
    //                 Container(
    //                   margin: EdgeInsets.only(top: 100),
    //                   child: Opacity(
    //                     opacity: 0.20,
    //                     child: Image.asset(
    //                       "assets/login2.png",
    //                       height: 250,
    //                       width: 200,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Container(
    //               margin: const EdgeInsets.only(top: 150, left: 45),
    //               child: const Text(
    //                 "Welcome Back",
    //                 style: TextStyle(
    //                     fontSize: 24,
    //                     color: Colors.white,
    //                     fontFamily: "Lato",
    //                     fontStyle: FontStyle.normal,
    //                     fontWeight: FontWeight.w700),
    //               ),
    //             ),
    //             Container(
    //               width: 286,
    //               margin: const EdgeInsets.only(top: 200, left: 45),
    //               child: const Text(
    //                 "Yay! You're back! Thanks for shopping with us. We have excited deals and promotions going on, grab your pick now!",
    //                 style: TextStyle(
    //                   fontSize: 14,
    //                   color: Colors.white,
    //                   fontFamily: "Lato",
    //                 ),
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.only(left: 45, top: 350),
    //               child: const Text(
    //                 "LOG IN",
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 18,
    //                   fontFamily: "Lato",
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //             )
    //           ],
    //         ),
    //         const SizedBox(height: 25),
    //         Container(
    //           margin: const EdgeInsets.only(
    //             left: 45,
    //           ),
    //           child: const Text(
    //             "Email address",
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: Colors.black87,
    //               fontFamily: "Lato",
    //               fontStyle: FontStyle.normal,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 15),
    //         Container(
    //           margin: EdgeInsets.only(left: 45),
    //           height: 50,
    //           width: 300,
    //           child: TextFormField(
    //             onChanged: (value) {
    //               dataList = FirebaseFirestore.instance
    //                   .collection("users")
    //                   .snapshots();
    //             },
    //             key: _key,
    //             // validator: (val) {
    //             //   if (!isEmail(val!) && !isPhone(val)) {
    //             //     setState(() {
    //             //       _isEmail = false;
    //             //     });
    //             //   }
    //             // },
    //             controller: _email,
    //             decoration: InputDecoration(
    //               prefixIcon: Padding(
    //                 padding: const EdgeInsets.all(10.0),
    //                 child: SvgPicture.asset(
    //                   "assets/mail.svg",
    //                 ),
    //               ),
    //               suffixIcon: _isEmail
    //                   ? SizedBox()
    //                   : Padding(
    //                       padding: EdgeInsets.all(12.0),
    //                       child: SvgPicture.asset("assets/WarningCircle.svg"),
    //                     ),
    //               prefixIconConstraints: const BoxConstraints(
    //                 minHeight: 24,
    //                 minWidth: 24,
    //               ),
    //               hintText: "Enter your phone number",
    //               hintStyle: const TextStyle(
    //                 color: Color(0xFFFAEAEAE),
    //                 fontFamily: "Lato",
    //                 fontSize: 12,
    //               ),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(8),
    //                 borderSide: const BorderSide(
    //                   color: Color(0xFFFD2D2D2),
    //                 ),
    //               ),
    //               focusedBorder: const OutlineInputBorder(
    //                 borderSide: BorderSide(
    //                   color: Color(0xFFF6342E8),
    //                 ),
    //               ),
    //               contentPadding: EdgeInsets.only(top: 5),
    //             ),
    //             style: const TextStyle(
    //               fontFamily: "Lato",
    //               fontSize: 12,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 25),
    //         Container(
    //           margin: const EdgeInsets.only(
    //             left: 45,
    //           ),
    //           child: const Text(
    //             "Password",
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: Colors.black87,
    //               fontFamily: "Lato",
    //               fontStyle: FontStyle.normal,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //         const SizedBox(height: 15),
    //         Container(
    //           margin: const EdgeInsets.only(left: 45),
    //           height: 50,
    //           width: 300,
    //           child: Material(
    //             shadowColor: Color(0xFFF6342E8),
    //             child: TextFormField(
    //               // key: _formKey,
    //               controller: _pass,
    //               // validator: (val) {
    //               //   if (val!.isEmpty) {
    //               //     return "Please enter Password";
    //               //   }
    //               // },
    //               decoration: InputDecoration(
    //                 prefixIcon: Padding(
    //                   padding: const EdgeInsets.all(10.0),
    //                   child: SvgPicture.asset(
    //                     "assets/Lock.svg",
    //                   ),
    //                 ),
    //                 suffixIcon: _isPass
    //                     ? SizedBox()
    //                     : Padding(
    //                         padding: EdgeInsets.all(12.0),
    //                         child: SvgPicture.asset("assets/WarningCircle.svg"),
    //                       ),
    //                 prefixIconConstraints: const BoxConstraints(
    //                   minHeight: 24,
    //                   minWidth: 24,
    //                 ),
    //                 hintText: "Enter your password",
    //                 hintStyle: const TextStyle(
    //                   color: Color(0xFFFAEAEAE),
    //                   fontFamily: "Lato",
    //                   fontSize: 12,
    //                 ),
    //                 border: OutlineInputBorder(
    //                   borderRadius: BorderRadius.circular(8),
    //                   borderSide: const BorderSide(
    //                     color: Color(0xFFFD2D2D2),
    //                   ),
    //                 ),
    //                 focusedBorder: const OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: Color(0xFFF6342E8),
    //                   ),
    //                 ),
    //                 contentPadding: const EdgeInsets.only(top: 5),
    //               ),
    //               style: const TextStyle(
    //                 fontFamily: "Lato",
    //                 fontSize: 12,
    //               ),
    //               obscureText: true,
    //             ),
    //           ),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             Container(
    //               margin: const EdgeInsets.only(left: 30, top: 10),
    //               child: Row(
    //                 children: [
    //                   CustomCheckBox(
    //                     value: value,
    //                     onChanged: (value) => setState(() {
    //                       this.value = value;
    //                     }),
    //                     borderColor: Color(0xFFFE0E0E0),
    //                     checkedIconColor: Color(0xFFF6342E8),
    //                     checkedFillColor: Colors.white,
    //                     borderWidth: 1,
    //                     shouldShowBorder: true,
    //                     splashRadius: 1,
    //                   ),
    //                   Container(
    //                     child: const Text(
    //                       "Remember me",
    //                       style: TextStyle(
    //                         fontFamily: "Lato",
    //                         fontSize: 12,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.only(top: 10, right: 47),
    //               child: const Text(
    //                 "Forgot Password?",
    //                 style: TextStyle(
    //                   color: Color(0xFFF6342E8),
    //                   fontSize: 12,
    //                   fontFamily: "Lato",
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 5,
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             // StreamBuilder(
    //             //   stream: dataList,
    //             //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //             //     for (int i = 0; i < snapshot.data!.docs.length; i++) {
    //             //       DocumentSnapshot doc = snapshot.data!.docs[i];
    //             //       if (doc["Phone"] == _email.text) {
    //             //         print("Phone is already exist");
    //             //       } else {
    //             //         print("success");
    //             //       }
    //             //     }
    //             //     return Container();
    //             //   },
    //             // );
    //             Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => OtpPage2(
    //                         Phone: _email.text, Email: Email, Pass: Pass)));
    //             // final uid = _auth.currentUser!.uid;
    //             // if (!isEmail(_email.text) && !isPhone(_email.text)) {
    //             //   setState(() {
    //             //     _isEmail = false;
    //             //   });
    //             // }
    //             // _email.text.isEmpty ? _isEmail = false : _isEmail = true;
    //             // _pass.text.isEmpty ? _isPass = false : _isPass = true;

    //             // if (_isEmail == false || _isPass == false) {
    //             //   // } else if (_formKey.currentState!.validate()) {
    //             // } else {
    //             //   if (_email.text.contains("@")) {
    //             //     _signInWithEmail();
    //             //   } else {
    //             //     //  signInWithPhone();

    //             //   }

    //             //   // if (_success == true) {
    //             //   //   Navigator.push(context,
    //             //   //       MaterialPageRoute(builder: (context) => HomePage()));
    //             //   // }
    //             // }
    //           },
    //           child: Container(
    //             margin: EdgeInsets.only(left: 45),
    //             height: 54,
    //             width: 300,
    //             decoration: BoxDecoration(
    //               color: Color(0xFFF6342E8),
    //               borderRadius: BorderRadius.circular(56),
    //             ),
    //             child: const Center(
    //               child: Text(
    //                 "LOG IN",
    //                 style: TextStyle(
    //                   fontFamily: "Lato",
    //                   fontSize: 12,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Container(
    //           margin: EdgeInsets.only(top: 15),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Container(
    //                 child: const Text(
    //                   "Not registered yet?",
    //                   style: TextStyle(
    //                     fontFamily: "Lato",
    //                     fontSize: 12,
    //                     color: Color(0xFFFA1A1A1),
    //                   ),
    //                 ),
    //               ),
    //               GestureDetector(
    //                 onTap: () {
    //                   Navigator.pushNamed(context, '/register');
    //                 },
    //                 child: Container(
    //                   child: const Text(
    //                     "Create an Account",
    //                     style: TextStyle(
    //                       fontFamily: "Lato",
    //                       fontSize: 12,
    //                       color: Color(0xFFF6342E8),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  Future<void> _signInWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      );
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => NavBar()));
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Ops! Login Failed"),
          content: Text('${e.message}'),
        ),
      );
    }

    // if (user != null) {
    //   setState(() {
    //     _success = true;
    //   });
    // } else {
    //   _success = false;
    // }
  }

  Future checkLogin() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString('email', _email.text);
  }

  void checkPhonenumber() {}

//  Future<void> _login() async {
//     /// This method is used to login the user
//     /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
//     /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
//     try {
//       await FirebaseAuth.instance
//           .signInWithCredential(PhoneAuthCredential credential)
//           .then((AuthResult authRes) {
//         _firebaseUser = authRes.user;
//         print(_firebaseUser.toString());
//       });
//       ...
//     } catch (e) {
//       ...
//       print(e.toString());
//     }
//   }

  // Future<void> checkNumber() async {
  //   QuerySnapshot result = FirebaseFirestore.instance
  //       .collection("users")
  //       .where("phone", isEqualTo: Email)
  //       .get();

  //       Stream<
  // }

  @override
  void initState() {
    super.initState();
    checkLogin();
    _auth.signOut();
    setState(() {
      _loading = false;
    });
  }
}
