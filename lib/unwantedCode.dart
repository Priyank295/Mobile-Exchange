import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Future<Brand> fetchBrand() async {
//   final response = await http
//       .get(Uri.parse('https://api-mobilespecs.azharimm.site/v2/brands'));

//   if (response.statusCode == 200) {
//     return Brand.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception("Failed to load brands");
//   }
// }

Future getUserData() async {
  var response = await http
      .get(Uri.parse("https://api-mobilespecs.azharimm.site/v2/brands"));

  Map<String, dynamic> jsonData = json.decode(response.body);
  var brands = [];

  //print(jsonData['data'][0]['brand_name']);

  for (var u in jsonData['data']) {
    Brand brand = Brand(bname: u["brand_name"]);
    brands.add(brand);
  }
  print(brands);

  // for (int i = 0; i < jsonData.length; i++)
  // {
  //   Brand(bname: bname)
  // }
  return brands;
}

class Brand {
  final String bname;

  Brand({required this.bname});

  // factory Brand.fromJson(Map<String, dynamic> json) {
  //   return Brand(bname: json['brand_name']);
  // }
}

class Unwanted extends StatefulWidget {
  const Unwanted({Key? key}) : super(key: key);

  @override
  State<Unwanted> createState() => _UnwantedState();
}

class _UnwantedState extends State<Unwanted> {
  late Future<Brand> futureBrand;
  var response =
      http.get(Uri.parse('https://api-mobilespecs.azharimm.site/v2/brands'));

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   futureBrand = fetchBrand();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:

          // SelectionMenu(
          //   itemBuilder: (context, item, onItemTapped) {
          //     return Material(
          //       child: InkWell(
          //         onTap: onItemTapped,
          //         child: Text(item.toString()),
          //       ),
          //     );
          //   },
          //   itemsList: response,
          //   onItemSelected: (selectedItem) {
          //     print(selectedItem);
          //   },
          // )

          Center(
        child: ElevatedButton(
          onPressed: () => getUserData(),
          child: Text("Click me"),
        ),
      ),
    );
  }
}
