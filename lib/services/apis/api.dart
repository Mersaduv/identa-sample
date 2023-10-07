import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:identa/core/models/model_core/profile_data%20.dart';
import 'package:identa/services/auth/auth_service.dart';
import 'package:path_provider/path_provider.dart';
import 'config.dart';

class ServiceApis {
  ServiceApis._();
  static final AuthService _authService = AuthService();

  static Future<http.Response> sendDeleteRequest(String url) async {
    final client = RetryClient(http.Client());

    var response = await client.delete(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Authorization': await _authService.getAuthHeader(),
      },
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.delete(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        headers: {
          'Authorization': await _authService.getAuthHeader(),
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
        'Authorization': await _authService.getAuthHeader(),
        'Content-type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.put(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        headers: {
          'Authorization': await _authService.getAuthHeader(),
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
        'Authorization': await _authService.getAuthHeader(),
      },
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.get(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        headers: {
          'Authorization': await _authService.getAuthHeader(),
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
        'Authorization': await _authService.getAuthHeader(),
        'Content-type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 401) {
      _authService.signInWithAutoCodeExchange();

      response = await client.post(
        Uri.parse('${ServiceConfig.baseURL}/$url'),
        body: jsonEncode(body),
        headers: {
          'Authorization': await _authService.getAuthHeader(),
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
      return [response.statusCode];
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

  static Future<bool> deleteNoteAudio(String noteId, String audioId) async {
    final response =
        await sendDeleteRequest("insights/note/$noteId/file/$audioId");

    if (response.statusCode == HttpStatus.ok) {
      return true;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return false;
    }
  }

  static Future<http.Response> sendAudioFile(String filePath) async {
    final client = RetryClient(http.Client());
    const url = 'insights/transcribe';

    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final response = await client.post(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Content-Type': 'audio/mpeg',
        'Authorization': await _authService.getAuthHeader(),
      },
      body: bytes,
    );

    return response;
  }

  static Future<String?> downloadAudio(String fileId) async {
    final client = RetryClient(http.Client());

    String url = 'insights/download-audio';

    var response = await client.get(
      Uri.parse('${ServiceConfig.baseURL}/$url/$fileId'),
      headers: {
        'Authorization': await _authService.getAuthHeader(),
      },
    );

    if (response.statusCode == 200) {
      Directory directory = await getApplicationDocumentsDirectory();

      String fileName = '$fileId.m4a';

      String filePath = '${directory.path}/$fileName';

      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      print('Audio file downloaded successfully! Path: $filePath');

      return filePath;
    } else {
      print('Failed to download audio file. Error: ${response.statusCode}');
      return response.toString();
    }
  }

  static Future<http.Response> sendPostProfileRequest(
      ProfileData profileData) async {
    // final client = RetryClient(http.Client());
    final response = await sendPostRequest("insights/profile", profileData);
    // var body = profileData.toJson();
    print("mapdata ${response.body}");

    if (response.statusCode == HttpStatus.ok) {
      return response;
    } else {
      if (kDebugMode) {
        print('API request failed with status code ${response.statusCode}');
      }
      return response;
    }
  }

  static Future<http.Response> sendGetProfileRequest() async {
    final client = RetryClient(http.Client());

    final response = await client.get(
      Uri.parse('${ServiceConfig.baseURL}/insights/profile'),
      headers: {
        'Authorization': await _authService.getAuthHeader(),
      },
    );

    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}');
    }

    return response;
  }

  static Future<http.Response> sendProfilePicture(String filePath) async {
    final client = RetryClient(http.Client());
    const url = 'insights/profile/picture';

    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final response = await client.post(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Content-Type': 'application/octet-stream',
        'Authorization': await _authService.getAuthHeader(),
      },
      body: bytes,
    );

    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}');
    }

    return response;
  }

  static Future<http.Response> getProfilePicture() async {
    final client = RetryClient(http.Client());
    const url = 'insights/profile/picture';

    final response = await client.get(
      Uri.parse('${ServiceConfig.baseURL}/$url'),
      headers: {
        'Authorization': await _authService.getAuthHeader(),
      },
    );

    if (response.statusCode != 200) {
      print('Request failed with status: ${response.statusCode}');
    }

    return response;
  }
}
