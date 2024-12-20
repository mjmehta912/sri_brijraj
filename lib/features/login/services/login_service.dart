import 'dart:convert';

import 'package:brijraj_app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String fcmToken,
  }) async {
    final url = Uri.parse(
      '$kBaseUrl/Auth/login',
    );

    final headers = {
      'Content-Type': 'application/json',
    };

    final requestBody = json.encode(
      {
        'username': username,
        'password': password,
        'FCMToken': fcmToken,
      },
    );

    final response = await http.post(
      url,
      headers: headers,
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      final errorData = json.decode(response.body);
      throw errorData['error'] ?? 'An unknown error occurred';
    }
  }
}
