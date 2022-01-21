import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mbx/checkEmail.dart';
import 'package:mbx/loginpage.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _email = TextEditingController();

  bool _isemail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 60, left: 25),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: SvgPicture.asset(
              "assets/arrow.svg",
              color: Colors.black,
              height: 18,
              width: 18,
            ),
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Container(
          margin: EdgeInsets.only(left: 40),
          child: Text("Reset Password",
              style: TextStyle(
                  fontFamily: "Lato",
                  fontSize: 30,
                  fontWeight: FontWeight.w800)),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: 316,
          margin: EdgeInsets.only(left: 40),
          child: Text(
              "Enter the email associated with your account and we'll send an email with instructions to reset your password.",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 14,
              )),
        ),
        SizedBox(
          height: 60,
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
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
                height: 50,
                width: 320,
                child: TextFormField(
                  controller: _email,
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
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: GestureDetector(
            onTap: () {
              if (_email.text.isEmpty || _isemail == false) {
              } else {
                try {
                  // FirebaseAuth.instance
                  //     .sendPasswordResetEmail(email: _email.text)
                  //     .then((value) {
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (ctx) => CheckMail()));
                  // });

                  Navigator.push(context,
                      MaterialPageRoute(builder: (ctx) => CheckMail()));
                } catch (e) {
                  print(e);
                }
              }
            },
            child: Container(
              height: 54,
              width: 315,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xFFF6342E8),
              ),
              child: const Center(
                child: Text(
                  "SEND MAIL",
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
      ],
    ));
  }
}
