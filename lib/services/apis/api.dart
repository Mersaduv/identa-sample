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

  static Future<http.Response> sendDeleteRequest(String url) async {
    final client = RetryClient(http.Client());

    var response = await client.delete(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Authorization': _authService.getAuthHeader(),
      },
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.delete(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        headers: {
          'Authorization': _authService.getAuthHeader(),
        },
      );
    }

    return response;
  }

  static Future<http.Response> sendPutRequest(String url, dynamic body) async {
    final client = RetryClient(http.Client());

    var response = await client.put(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Authorization': _authService.getAuthHeader(),
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.put(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        headers: {
          'Authorization': _authService.getAuthHeader(),
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
    }

    return response;
  }

  static Future<http.Response> sendGetRequest(String url) async {
    final client = RetryClient(http.Client());

    var response = await client.get(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Authorization': _authService.getAuthHeader(),
      },
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.get(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        headers: {
          'Authorization': _authService.getAuthHeader(),
        },
      );
    }

    return response;
  }

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
    final response = await sendPostRequest("chat", {'message': message});

    if (response.statusCode == HttpStatus.ok) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse as String;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return null;
    }
  }

  static Future<bool> createNote(dynamic note) async {
    final response = await sendPostRequest("note", note);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return false;
    }
  }

  static Future<bool> editNote(dynamic note) async {
    final response = await sendPutRequest("note", note);

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return false;
    }
  }

  static Future<List<dynamic>> getNotes() async {
    final response = await sendGetRequest("note");

    if (response.statusCode == HttpStatus.ok) {
      var decodedResponse = jsonDecode(response.body);
      return decodedResponse["items"] as List<dynamic>;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return [];
    }
  }

  static Future<bool> deleteNote(
    String id,
  ) async {
    final response = await sendDeleteRequest("note/$id");

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return false;
    }
  }
}
