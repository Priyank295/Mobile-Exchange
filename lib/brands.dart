import 'dart:convert';
import 'package:http/http.dart' as http;

class URL {
  static const String BASE_URL = 'https://api-mobilespecs.azharimm.site/v2';
}

class ApiService {
  Future getBrand() async {
    final response = await http.get(Uri.parse('${URL.BASE_URL}/brands'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['brand_name'];
    } else {
      return null;
    }
  }

  static Future<List<dynamic>?> getModel(String brand) async {
    final response = await http.get(Uri.parse('${URL.BASE_URL}/${brand}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}
