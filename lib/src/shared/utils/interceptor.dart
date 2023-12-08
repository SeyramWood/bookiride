import 'dart:convert';

import 'package:bookihub/main.dart';
import 'package:bookihub/src/shared/constant/base_url.dart';
import 'package:bookihub/src/shared/errors/custom_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

final storage = locator<FlutterSecureStorage>();

class HttpClientWithInterceptor {
  final http.Client _inner;
  String? _accessToken; // Store the current access token

  HttpClientWithInterceptor(this._inner);

  Future<http.Response> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    //  interceptor logic before making the request
    headers ??= {};
    headers['Authorization'] = 'Bearer $_accessToken';
    body ??= {};

    final response =
        await _inner.post(Uri.parse(url), body: body, headers: headers);

    //  interceptor logic after receiving the response
    if (response.statusCode == 401) {
      try {
        _accessToken = await refreshAccessToken(); // Refresh the token
        // Retry the original request with the new token
        headers['Authorization'] = 'Bearer $_accessToken';
        return await _inner.get(Uri.parse(url), headers: headers);
      } catch (e) {
        rethrow; // Rethrow if token refresh fails
      }
    }

    return response;
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    //  interceptor logic before making the request
    headers ??= {};
    headers['Authorization'] = 'Bearer $_accessToken';

    final response = await _inner.get(Uri.parse(url), headers: headers);

    //  interceptor logic after receiving the response
    if (response.statusCode == 401) {
      try {
        _accessToken = await refreshAccessToken(); // Refresh the token
        // Retry the original request with the new token
        headers['Authorization'] = 'Bearer $_accessToken';
        return await _inner.get(Uri.parse(url), headers: headers);
      } on http.ClientException {
        throw 'You are not offline. Check your network.';
      } catch (e) {
        rethrow; // Rethrow if token refresh fails
      }
    }

    return response;
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    //  interceptor logic before making the request
    headers ??= {};
    headers['Authorization'] = 'Bearer $_accessToken';
    body ??= {};

    final response =
        await _inner.put(Uri.parse(url), body: body, headers: headers);

    //  interceptor logic after receiving the response
    if (response.statusCode == 401) {
      try {
        _accessToken = await refreshAccessToken(); // Refresh the token
        // Retry the original request with the new token
        headers['Authorization'] = 'Bearer $_accessToken';
        return await _inner.put(Uri.parse(url), body: body, headers: headers);
      } catch (e) {
        rethrow; // Rethrow if token refresh fails
      }
    }

    return response;
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    //  interceptor logic before making the request
    headers ??= {};
    headers['Authorization'] = 'Bearer $_accessToken';

    final response = await _inner.delete(Uri.parse(url), headers: headers);

    //  interceptor logic after receiving the response
    if (response.statusCode == 401) {
      try {
        _accessToken = await refreshAccessToken(); // Refresh the token
        // Retry the original request with the new token
        headers['Authorization'] = 'Bearer $_accessToken';
        return await _inner.get(Uri.parse(url), headers: headers);
      } catch (e) {
        rethrow; // Rethrow if token refresh fails
      }
    }

    return response;
  }

  Future<http.Response> sendMultipartRequest(
      {Map<String, String>? headers,
      Map<String, String>? fields,
      List<http.MultipartFile>? files,
      required MultipartRequest request,
      re}) async {
    try {
      // Set the authorization header with the current access token (if available)
      headers ??= {};
      headers['Authorization'] = 'Bearer $_accessToken';
      request.headers.addAll(headers);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 401) {
        try {
          _accessToken = await refreshAccessToken(); // Refresh the token
          // Retry the original request with the new token

          // Create a new request with the updated headers
          request.headers['Authorization'] = 'Bearer $_accessToken';
          request.headers.addAll(headers);

          // Send the new request
          final newStreamedResponse = await request.send();
          return await http.Response.fromStream(newStreamedResponse);
        } catch (e) {
          rethrow; // Rethrow if token refresh fails
        }
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

Future<String> refreshAccessToken() async {
  final url = Uri.parse('$baseUrl/auth/refresh');
  try {
    final token = await storage.read(
        key:
            'refreshToken'); //read or get the refresh token stored in the local db
    final response = await http.post(
      url,
      headers: {'X-Refresh-Token': token ?? ''},
    );
    if (response.statusCode != 200) {
      throw CustomException('Couldn\'t refresh token');
    }
    final jsonData = jsonDecode(response.body)['data'];
    await storage.write(key: 'accessToken', value: jsonData['accessToken']);
    await storage.write(key: 'refreshToken', value: jsonData['refreshToken']);
    return jsonData['accessToken'];
  } catch (e) {
    rethrow;
  }
}

//intialize one instance of the storage class
interceptorLocator() {
  locator.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  locator.registerLazySingleton<HttpClientWithInterceptor>(
      () => HttpClientWithInterceptor(http.Client()));
}
