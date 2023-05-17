import 'dart:convert';

import 'package:http/http.dart' as http;
import 'config.dart';

class ServiceApis {
  ServiceApis._();

  static Map decodedResponse(http.Response responseResult) =>
      jsonDecode(responseResult.body) as Map;

  static Future<String?> aiResponse(String content) async {
    final response = await http.post(
      Uri.parse('${ServiceConfig.baseURL}/posts'),
      body: jsonEncode({'content': content}),
      headers: {
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      return response.body;
    } else {
      print('API request failed with status code ${response.statusCode}');
      return null;
    }
  }

  static Future<Map?> aiApi(String query) async {
    var client = http.Client();
    try {
      var response =
          await client.get(Uri.parse('${ServiceConfig.aiAPIUri}${query}'));
      return json.decode(response.body);
    } catch (e) {
      print('HTTP Response error : $e');
      return null;
    }
  }

  static Future<Map?> users() async {
    var client = http.Client();
    try {
      var response = await client.get(ServiceConfig.usersAPIUri);
      return decodedResponse(response);
    } catch (e) {
      print('HTTP Response error : $e');
      return null;
    }
  }

  static Future<List?> posts() async {
    var client = http.Client();
    try {
      var response = await client.get(ServiceConfig.postsAPIUri);
      return json.decode(response.body);
    } catch (e) {
      print('HTTP Response error ! : $e');
      return null;
    }
  }

  static Future<bool> login(String username, String password) async {
    var client = http.Client();
    try {
      var response = await client.post(ServiceConfig.loginAPIUri,
          body: {'username': username, 'password': password});
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('HTTP Response error : $e');
      return false;
    }
  }
}
