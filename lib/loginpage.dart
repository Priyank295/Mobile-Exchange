import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:custom_check_box/custom_check_box.dart';
import 'package:mbx/main_widget.dart';
import 'package:mbx/navbar.dart';
import 'package:mbx/otppage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

String uid = "";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController _email = TextEditingController();
TextEditingController _pass = TextEditingController();

class _LoginPageState extends State<LoginPage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool value = false;
  String userEmail = "";
  bool _success = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 2,
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
                  margin: EdgeInsets.only(left: 45, top: 350),
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
            const SizedBox(height: 25),
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
                          child: SvgPicture.asset("assets/WarningCircle.svg"),
                        ),
                  prefixIconConstraints: const BoxConstraints(
                    minHeight: 24,
                    minWidth: 24,
                  ),
                  hintText: "Enter your email or phone",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 10),
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
                Container(
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
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              onTap: () {
                // final uid = _auth.currentUser!.uid;
                if (!isEmail(_email.text) && !isPhone(_email.text)) {
                  setState(() {
                    _isEmail = false;
                  });
                }
                _email.text.isEmpty ? _isEmail = false : _isEmail = true;
                _pass.text.isEmpty ? _isPass = false : _isPass = true;

                if (_isEmail == false || _isPass == false) {
                  // } else if (_formKey.currentState!.validate()) {
                } else {
                  if (_email.text.contains("@")) {
                    _signInWithEmail();
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpPage2(
                                Phone: _email.text,
                                uid: uid,
                                Email: Email,
                                Pass: Pass)));
                  }

                  // if (_success == true) {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => HomePage()));
                  // }
                }
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

  void signInWithPhone() async {
    await _auth.signInWithPhoneNumber("+91${_email.text}");
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }
}
