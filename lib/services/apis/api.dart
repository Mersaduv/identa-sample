import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'config.dart';

class ServiceApis {
  ServiceApis._();
  static final AuthService _authService = AuthService();

  static Future<http.Response> sendPostRequest(String url, dynamic body) async {
    final client = RetryClient(http.Client());

    var response = await client.post(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      body: jsonEncode(body),
      headers: {
        'Authorization': _authService.getAuthHeader(),
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.post(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        body: jsonEncode(body),
        headers: {
          'Authorization': _authService.getAuthHeader(),
          'Content-type': 'application/json; charset=UTF-8',
        },
      );
    }

    return response;
  }

  static Future<String?> chatResponse(String message) async {
    final response = await sendPostRequest("/chat", {'message': message});

    if (response.statusCode == HttpStatus.ok) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse as String;
    } 
    else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return null;
    }
  }
}
