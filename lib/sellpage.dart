import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:http/http.dart' as http;
import 'package:mbx/main_widget.dart';
import "./user_services.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:get/get.dart';
import './product_added.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'getApiData.dart';
import 'loadingScreen.dart';

class SellPage extends StatefulWidget {
  @override
  _SellPageState createState() => _SellPageState();
}

class _SellPageState extends State<SellPage> {
  TextEditingController _pName = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _ram = TextEditingController();
  TextEditingController _rom = TextEditingController();
  TextEditingController _back = TextEditingController();
  TextEditingController _front = TextEditingController();
  UserServices userServices = UserServices();

  bool _isName = true;
  bool _isPrice = true;
  bool _isModel = true;
  bool _isDes = true;
  bool _isLoading = false;
  List<String> imgUrl = [];
  List<XFile>? imagefileList = [];
  String DocId = "";

  FirebaseFirestore _fire = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  Reference _storage = FirebaseStorage.instance.ref();

  Future getImage() async {
    final _picker = ImagePicker();

    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      final List<XFile>? selectedImages = await _picker.pickMultiImage();
      if (selectedImages != null) {
        imagefileList!.addAll(selectedImages);
        print("Image List Length:" + imagefileList!.length.toString());
        setState(() {
          _isLoading = true;
        });
        if (imagefileList != null) {
          setState(() {
            _isLoading = true;
          });
          uploadFiles(imagefileList!, imgUrl);

          setState(() {
            _isLoading = false;
          });
          // setState(() {
          //   imgUrl =
          // });
        }
      } else {
        print("no selection");
      }

      //   if (image != null) {
      //     setState(() {
      //       _isLoading = true;
      //     });
      //     _isLoading
      //         ? Center(
      //             child: Lottie.asset("assets/loading.json",
      //                 frameRate: FrameRate(30), height: 40))
      //         : null;
      //     var snapshot = await _storage.child("Product/imgname").putFile(file);
      //     var downloadUrl = await snapshot.ref.getDownloadURL();
      //     setState(() {
      //       imgUrl = downloadUrl;
      //       _isLoading = false;
      //     });
      //   } else {
      //     print("No Path Received");
      //   }
      // } else {
      //   print("Grant Permission and try again");
      // }

    }

    // Future<void> uploadFile() async {
    //   String fileName = basename(_imageFile!.path);
    //   Reference _storage =
    //       FirebaseStorage.instance.ref().child("Product/$fileName");
    //   UploadTask uploadTask = _storage.putFile(_imageFile!);
    //   TaskSnapshot taskSnapshot =
    //       await uploadTask.whenComplete(() => print("PICTURE UPLOADED"));
    //   taskSnapshot.ref.getDownloadURL().then((value) {
    //     print("Done: $value");
    //     setState(() {
    //       imgUrl = value;
    //     });
    //   });
    // }
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(
        Uri.parse(
          'https://parseapi.back4app.com/classes/Cellphonedataset_Dataset_Cell_Phones_Model_Brand?limit=10&keys=Brand,Model,Internal_memory,RAM',
        ),
        headers: {
          "X-Parse-Application-Id":
              "S7h3FIGQjiH17nHGJQqo4SIaJdnqmpMc7E1O3Kfk", // This is your app's application id
          "X-Parse-REST-API-Key":
              "D7mqcAWkRnj3iVtLPbVv39SW0PV2XW1v6pRrBdnO" // This is your app's REST API key
        });
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? userID = FirebaseAuth.instance.currentUser;
    return _isLoading
        ? LoadingScreen()
        : Scaffold(
            backgroundColor: Color(0xfffF1F4FB),
            body: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.start,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(left: 20, top: 60),
                        //       child: SvgPicture.asset(
                        //         'assets/arrow.svg',
                        //         color: Colors.black,
                        //         height: 18,
                        //         width: 18,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Column(
                          children: [
                            if (imgUrl.isNotEmpty)
                              Stack(children: [
                                Container(
                                  margin: EdgeInsets.only(top: 50),
                                  height: 270,
                                  width: 270,
                                  child: CarouselSlider(
                                    items: imgUrl
                                        .map(
                                          (e) => ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Container(
                                              child: Stack(
                                                children: [
                                                  Image.network(
                                                    e,
                                                    fit: BoxFit.cover,
                                                    height: 270,
                                                    width: 200,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    options: CarouselOptions(
                                      autoPlay: true,
                                      height: 270,
                                      reverse: false,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  height: 20,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        imgUrl.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Color(0xfff6342E8),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ])
                            else
                              GestureDetector(
                                onTap: getImage,
                                child: Container(
                                  child: Lottie.asset(
                                    'assets/image.json',
                                    height: 270,
                                    width: 270,
                                    frameRate: FrameRate(60),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "UPLOAD YOUR IMAGE",
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.white,
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 39),
                                        child: Text(
                                          "Product Name",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        height: 50,
                                        width: 170,
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {
                                              _isName = value.isNotEmpty;
                                            });
                                          },
                                          controller: _pName,
                                          decoration: InputDecoration(
                                            suffixIcon: _isName
                                                ? SizedBox()
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: SvgPicture.asset(
                                                        "assets/WarningCircle.svg"),
                                                  ),
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minHeight: 24,
                                              minWidth: 24,
                                            ),
                                            hintText: "Enter Product Name",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFFAEAEAE),
                                              fontFamily: "Lato",
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFD2D2D2),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF6342E8),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 39),
                                        child: Text(
                                          "Price",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        height: 50,
                                        width: 131,
                                        child: TextFormField(
                                          controller: _price,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            suffixIcon: _isPrice
                                                ? SizedBox()
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: SvgPicture.asset(
                                                        "assets/WarningCircle.svg"),
                                                  ),
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minHeight: 14,
                                              minWidth: 14,
                                            ),
                                            prefixIcon: Container(
                                              margin: EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: SvgPicture.asset(
                                                "assets/rupee.svg",
                                                height: 13,
                                                width: 13,
                                              ),
                                            ),
                                            hintText: "Price",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFFAEAEAE),
                                              fontFamily: "Lato",
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFD2D2D2),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF6342E8),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 39),
                                child: Text(
                                  "Phone Model",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Lato",
                                      fontSize: 14),
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model,
                                    // validator: (val) {
                                    //   if (!isEmail(val!) && !isPhone(val)) {
                                    //     setState(() {
                                    //       _isEmail = false;
                                    //     });
                                    //   }
                                    // },

                                    decoration: InputDecoration(
                                      // prefixIcon: Padding(
                                      //   padding: const EdgeInsets.all(10.0),
                                      //   child: SvgPicture.asset(
                                      //     "assets/mail.svg",
                                      //   ),
                                      // ),
                                      suffixIcon: _isModel
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: SvgPicture.asset(
                                                  "assets/WarningCircle.svg"),
                                            ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minHeight: 24,
                                        minWidth: 24,
                                      ),
                                      hintText: "Enter Phone Model Name",
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
                                      contentPadding: EdgeInsets.only(left: 10),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 39),
                                        child: Text(
                                          "RAM",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        height: 50,
                                        width: 131,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _ram,
                                          decoration: InputDecoration(
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minHeight: 24,
                                              minWidth: 24,
                                            ),
                                            hintText: "RAM",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFFAEAEAE),
                                              fontFamily: "Lato",
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFD2D2D2),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF6342E8),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 39, right: 39),
                                        child: Text(
                                          "ROM",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 30, right: 39),
                                        height: 50,
                                        width: 131,
                                        child: TextFormField(
                                          controller: _rom,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minHeight: 14,
                                              minWidth: 14,
                                            ),
                                            hintText: "ROM",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFFAEAEAE),
                                              fontFamily: "Lato",
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFD2D2D2),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF6342E8),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   height: 20,
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 39),
                                        child: Text(
                                          "BACK CAMERA",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 30),
                                        height: 50,
                                        width: 131,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _back,
                                          decoration: InputDecoration(
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minHeight: 24,
                                              minWidth: 24,
                                            ),
                                            hintText: "BACK CAMERA",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFFAEAEAE),
                                              fontFamily: "Lato",
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFD2D2D2),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF6342E8),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 39, right: 39),
                                        child: Text(
                                          "FRONT CAMERA",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 30, right: 39),
                                        height: 50,
                                        width: 131,
                                        child: TextFormField(
                                          controller: _front,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                              minHeight: 14,
                                              minWidth: 14,
                                            ),
                                            hintText: "FRONT CAMERA",
                                            hintStyle: const TextStyle(
                                              color: Color(0xFFFAEAEAE),
                                              fontFamily: "Lato",
                                              fontSize: 12,
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              borderSide: const BorderSide(
                                                color: Color(0xFFFD2D2D2),
                                              ),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xFFF6342E8),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.only(left: 10),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Lato",
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 39),
                                child: Text(
                                  "Description",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Lato",
                                      fontSize: 14),
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  height: 49,
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _description,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    // validator: (val) {
                                    //   if (!isEmail(val!) && !isPhone(val)) {
                                    //     setState(() {
                                    //       _isEmail = false;
                                    //     });
                                    //   }
                                    // },

                                    decoration: InputDecoration(
                                      // prefixIcon: Padding(
                                      //   padding: const EdgeInsets.all(10.0),
                                      //   child: SvgPicture.asset(
                                      //     "assets/mail.svg",
                                      //   ),
                                      // ),
                                      suffixIcon: _isDes
                                          ? SizedBox()
                                          : Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child: SvgPicture.asset(
                                                  "assets/WarningCircle.svg"),
                                            ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minHeight: 24,
                                        minWidth: 24,
                                      ),
                                      hintText:
                                          "Write Description about your phone",

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
                                      contentPadding: EdgeInsets.only(left: 10),
                                    ),
                                    style: const TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      _pName.text.isEmpty
                                          ? _isName = false
                                          : _isName = true;
                                      _model.text.isEmpty
                                          ? _isModel = false
                                          : _isModel = true;
                                      _price.text.isEmpty
                                          ? _isPrice = false
                                          : _isPrice = true;
                                      _description.text.isEmpty
                                          ? _isDes = false
                                          : _isDes = true;

                                      if (_isName == false ||
                                          _isDes == false ||
                                          _isModel == false ||
                                          _isPrice == false) {
                                      } else {
                                        //uploadProduct();
                                        newUploadProduct();
                                        //Navigator.push(context, MaterialPageRoute(builder: (ctx)=>GetData()) );

                                      }
                                    },
                                    child: Container(
                                      height: 54,
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
                                            SvgPicture.asset(
                                              'assets/cart.svg',
                                              color: Colors.white,
                                              height: 24,
                                              width: 24,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "PROCEED TO SELL",
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  // Future<void> uploadProduct() async {
  //   User? currentuser = FirebaseAuth.instance.currentUser;

  //   var userId = currentuser!.uid;

  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(userId)
  //       .collection("Products")
  //       .add({
  //     "Product Name": _pName.text,
  //     "Product Price": _price.text,
  //     "Product Model": _model.text,
  //     "Product Description": _description.text,
  //     "Product Photo": imgUrl,
  //     "User Id": userId,
  //   }).then((value) {
  //     print("Product is Successfully added");

  //     // Get.to(() => ProductAdded());
  //   });
  // }

  Future<void> newUploadProduct() async {
    User? currentuser = FirebaseAuth.instance.currentUser;

    var userId = currentuser!.uid;

    await FirebaseFirestore.instance.collection("Products").add({
      "Product Name": _pName.text,
      "Product Price": _price.text,
      "Product Model": _model.text,
      "Product Description": _description.text,
      "Product Photo": imgUrl,
      "User Id": userId,
      "ROM": _rom.text,
      "RAM": _ram.text,
      "Front": _front.text,
      "Back": _back.text,
    }).then((DocumentReference docRef) {
      setState(() {
        DocId = docRef.id;
      });
      docRef.update(
        {'documentID': docRef.id},
      );
    });

    setState(() {
      print("DOC ID:" + DocId);
    });
    await FirebaseFirestore.instance
        .collection('Admin')
        .doc('admin1')
        .collection("Products")
        .doc(DocId)
        .set({
      "Product Name": _pName.text,
      "Product Price": _price.text,
      "Product Model": _model.text,
      "Product Description": _description.text,
      "Product Photo": imgUrl,
      "User Id": userId,
      "ROM": _rom.text,
      "RAM": _ram.text,
      "Front": _front.text,
      "Back": _back.text,
      "documentId": DocId
    }).then((value) {
      print("New Product is Successfully added");

      Get.to(() => ProductAdded());
    });
  }

  Future<List<String>> uploadFiles(
      List<XFile> _images, List<String> url) async {
    setState(() {
      _isLoading = true;
    });
    List<String> imagesUrls = [];

    _images.forEach((_image) async {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('Product/${_image.path}');
      UploadTask uploadTask = storageReference.putFile(File(_image.path));
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      imagesUrls.add(await (await uploadTask).ref.getDownloadURL());

      setState(() {
        url.addAll(imagesUrls);
      });
    });
    print(imagesUrls);
    setState(() {
      _isLoading = false;
    });
    return imagesUrls;
  }
}
