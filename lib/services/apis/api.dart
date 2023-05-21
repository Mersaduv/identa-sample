import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

class ServiceApis {
  ServiceApis._();

  static Future<String?> chatResponse(
      String accessToken, String message) async {
    final response = await http.post(
      Uri.parse('${ServiceConfig.baseURL}/chat'),
      body: jsonEncode({'message': message}),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse as String;
    } else {
      print('API request failed with status code ${response.statusCode}');
      return null;
    }
  }
}
