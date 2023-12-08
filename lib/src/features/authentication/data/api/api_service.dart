import 'dart:convert';
import 'dart:developer';

import 'package:bookihub/main.dart';
import 'package:bookihub/src/shared/constant/base_url.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final storage = locator<FlutterSecureStorage>();
  Future<String> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/auth/login");
    try {
      final response = await http.post(url, body: {
        "username": email,
        "password": password,
        "userType": "company"
      }).timeout(const Duration(seconds: 35));
      if (response.statusCode != 200) {
        // print(response.reasonPhrase);
        final errorMessage = json.decode(response.body)['error'];
        throw CustomException(errorMessage == 'bad request'
            ? 'User name or password is wrong'
            : 'Failed to login.');
      }
      final jsonData = jsonDecode(response.body)['data'];
      // await storage.write(key: 'accessToken', value: jsonData['accessToken']);
      await storage.write(key: 'refreshToken', value: jsonData['refreshToken']);
      //fetch user session after successfull login
      //within the fetchSession is return user id
      final user = await fetchSession(jsonData['accessToken']);
      return user.toString();
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<String> fetchSession(token) async {
    try {
      const url = '$baseUrl/auth/session';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        log(response.reasonPhrase.toString());
        throw CustomException('failed to get session');
      }
      log(response.body);
      final jsonID = jsonDecode(response.body)['data']['id'];
      return jsonID.toString();
    } catch (e) {
      rethrow;
    }
  }
}
