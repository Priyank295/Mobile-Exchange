import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GetData extends StatefulWidget {
  const GetData({ Key? key }) : super(key: key);

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {

   late Future<Map<String, dynamic>> futureData;
  Future<Map<String, dynamic>> fetchData() async {
  final response = await http.get(Uri.parse(
    'https://parseapi.back4app.com/classes/Cellphonedataset_Dataset_Cell_Phones_Model_Brand?limit=10&keys=Brand,Model,Internal_memory,RAM'),
    headers: {
      "X-Parse-Application-Id": "S7h3FIGQjiH17nHGJQqo4SIaJdnqmpMc7E1O3Kfk", // This is your app's application id
      "X-Parse-REST-API-Key": "D7mqcAWkRnj3iVtLPbVv39SW0PV2XW1v6pRrBdnO" // This is your app's REST API key
    }
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch data');
  }
}

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(future: futureData, builder: (ctx,snapshot){
        if(snapshot.hasData)
        {
          return Text(new JsonEncoder.withIndent('  ').convert(snapshot.data));
        }
        else if(snapshot.hasError)
        {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      }),
      
    );
  }
}
