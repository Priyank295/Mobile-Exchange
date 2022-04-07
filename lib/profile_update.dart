import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({Key? key}) : super(key: key);

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
//User? user = _auth.currentUser;
FirebaseFirestore _fire = FirebaseFirestore.instance;
String fname = "";
String lname = "";
String address = "";
String phone = "";
String zipcode = "";
String email = "";

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

User? user = _auth.currentUser;

class _ProfileUpdateState extends State<ProfileUpdate> {
  bool _isLoading = false;
  String picUrl = "";
  File? _photo;
  List<String> imgUrl = [];
  List<XFile>? imagefileList = [];

  FirebaseFirestore _fire = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Reference _storage = FirebaseStorage.instance.ref();

  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = basename(_photo!.path);
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = _storage.child('Users/${_photo!.path}');
  //     await ref.putFile(_photo!);

  //     UploadTask uploadTask = _storage.putFile(File(_photo!.path));
  //     final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
  //       picUrl = await uploadTask.then((_) => ref.getDownloadURL());

  //       log(picUrl);
  //     });
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  Future uploadProfilePic() async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({
      "Profile Pic": picUrl,
    });
  }

  // Future getImage() async {
  //   final _picker = ImagePicker();

  //   await Permission.photos.request();

  //   var permissionStatus = await Permission.photos.status;

  //   if (permissionStatus.isGranted) {
  //     //final Future<XFile?> selectedImages =  _picker.pickImage();

  //     XFile? selectImage = await _picker.pickImage(source: ImageSource.gallery);
  //     if (selectImage != null) {
  //       _photo = File(selectImage.path);
  //       //imagefileList!.add(selectImage);
  //       print("Image List Length:" + imagefileList!.length.toString());
  //       setState(() {
  //         _isLoading = true;
  //       });
  //       if (imagefileList != null) {
  //         setState(() {
  //           _isLoading = true;
  //         });
  //         uploadFile();

  //         setState(() {
  //           _isLoading = false;
  //         });
  //         // setState(() {
  //         //   imgUrl =
  //         // });
  //       }
  //     } else {
  //       print("no selection");
  //     }
  //   }
  // }

  Future selectFile() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result == null) return;
    final path = result.path;
    uploadFile();

    setState(() {
      _photo = File(path);
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;

    final filename = basename(_photo!.path);
    final destination = 'photo/$_photo';

    var task = uploadTask(destination, _photo!);

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    setState(() {
      picUrl = urlDownload;
    });

    print('Download-Link: $urlDownload');
  }

  static UploadTask? uploadTask(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filename =
        _photo != null ? basename(_photo!.path) : 'No File Selected';
    final User? user = _auth.currentUser;
    var userid = user!.uid;
    return StreamBuilder(
        stream: _fire.collection("users").doc(userid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            // fname = snapshot.data!["Fname"];
            // lname = snapshot.data!["Lname"];
            // address = snapshot.data!["Address"];
            // zipcode = snapshot.data!["Zip"];
            // email = snapshot.data!["Email"];
            // phone = snapshot.data!["Phone"];

            return Scaffold(
              key: _scaffoldKey,
              body: Column(
                children: [
                  Stack(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 55, left: 30),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: SvgPicture.asset(
                            "assets/arrow.svg",
                            color: Colors.black,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    height: 0.1,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.9),
                          spreadRadius: 0.4,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Stack(
                          //   children: [
                          //     Container(
                          //       margin: EdgeInsets.only(top: 50),
                          //       child: Container(
                          //         height: 130,
                          //         child: ClipOval(
                          //           child: Stack(
                          //             children: [
                          //               Image.asset(
                          //                 "assets/dp2.jpg",
                          //                 fit: BoxFit.cover,
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          InkWell(
                            onTap: selectFile,
                            child: Container(
                              height: 120,
                              width: 120,
                              margin: EdgeInsets.only(top: 40),
                              child: Stack(children: [
                                CircleAvatar(
                                  radius: 120,
                                  child: picUrl.isEmpty
                                      ? (snapshot.data!["Gender"] == "Male"
                                          ? SvgPicture.asset("assets/male.svg")
                                          : SvgPicture.asset(
                                              "assets/female.svg"))
                                      : Image.network(
                                          snapshot.data!["Profile Pic"]),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.transparent,
                                      child: SvgPicture.asset(
                                          "assets/square.svg")),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: TextFormField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"Fname": value});
                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc('admin1')
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({"Fname": value});
                              },
                              initialValue: snapshot.data!["Fname"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Lato",
                              ),
                              decoration: InputDecoration(
                                label: Text("First Name"),
                                labelStyle: TextStyle(
                                  color: Color(0xfffababab),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato",
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF6342E8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: TextFormField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"Lname": value});
                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc('admin1')
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({"Lname": value});
                              },
                              initialValue: snapshot.data!["Lname"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Lato",
                              ),
                              decoration: InputDecoration(
                                label: Text("Last Name"),
                                labelStyle: TextStyle(
                                  color: Color(0xfffababab),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato",
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF6342E8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: TextFormField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"Email": value});

                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc('admin1')
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({"Email": value});
                              },
                              initialValue: snapshot.data!["Email"] == ""
                                  ? ""
                                  : snapshot.data!["Email"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Lato",
                              ),
                              decoration: InputDecoration(
                                label: Text("Email"),
                                labelStyle: TextStyle(
                                  color: Color(0xfffababab),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato",
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF6342E8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: TextFormField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"Phone": value});
                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc('admin1')
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({"Phone": value});
                              },
                              initialValue: snapshot.data!["Phone"] == ""
                                  ? ""
                                  : snapshot.data!["Phone"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Lato",
                              ),
                              decoration: InputDecoration(
                                label: Text("Phone"),
                                labelStyle: TextStyle(
                                  color: Color(0xfffababab),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato",
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF6342E8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: TextFormField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"Address": value});
                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc('admin1')
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({"Address": value});
                              },
                              initialValue: snapshot.data!["Address"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Lato",
                              ),
                              decoration: InputDecoration(
                                label: Text("Address"),
                                labelStyle: TextStyle(
                                  color: Color(0xfffababab),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato",
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF6342E8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 70),
                            child: TextFormField(
                              onChanged: (value) {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.uid)
                                    .update({"Zip": value});

                                FirebaseFirestore.instance
                                    .collection("Admin")
                                    .doc('admin1')
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({"Zip": value});
                              },
                              initialValue: snapshot.data!["Zip"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontFamily: "Lato",
                              ),
                              decoration: InputDecoration(
                                label: Text("Zipcode"),
                                labelStyle: TextStyle(
                                  color: Color(0xfffababab),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Lato",
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFF6342E8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  uploadProfilePic();
                                  // FirebaseFirestore.instance
                                  //     .collection("users")
                                  //     .doc(user.uid)
                                  //     .update({
                                  //   "Fname": fname,
                                  //   "Lname": lname,
                                  //   "Email": email,
                                  //   "Address": address,
                                  //   "Zip": zipcode,
                                  //   "Phone": phone,
                                  // }).then((value) {

                                  // });

                                  print(picUrl);
                                  _scaffoldKey.currentState!.showSnackBar(
                                      new SnackBar(
                                          content: Text(
                                              "Profile is Successfully updated...",
                                              style: TextStyle(
                                                  fontFamily: "Lato",
                                                  fontSize: 14))));
                                },
                                child: Container(
                                  height: 50,
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF6342E8),
                                    borderRadius: BorderRadius.circular(56),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "UPDATE PROFILE",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container();
        });
  }
}
