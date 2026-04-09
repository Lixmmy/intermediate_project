import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intermediate_project/config/router_config.dart';
import 'package:intermediate_project/error/exceptions.dart';
import 'package:intermediate_project/model/add_new_story_response.dart';
import 'package:intermediate_project/model/get_all_stories_response.dart';
import 'package:intermediate_project/model/get_detail_story_response.dart';
import 'package:intermediate_project/model/login_response.dart';
import 'package:intermediate_project/model/register_response.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<bool> _ensureInternetConnection() async {
    if (kIsWeb) {
      return true;
    }
    var connectivityResult = await (Connectivity().checkConnectivity());

    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      if (!hasInternet) {
        throw NetworkException('Tidak ada WIFI atau internet yang tersambung');
      }
      return true;
    }
  }

  Future<dynamic> _requestGet(
    String endpoint,
    String message,
    bool authorized, {
    String? queryParameters,
  }) async {
    try {
      await _ensureInternetConnection();
      Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: '$basePath/$endpoint',
        queryParameters: {'id': queryParameters?.trim()},
      );

      final Map<String, String> headers = {'Accept': 'application/json'};
      if (authorized) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token') ?? '';
        if (token.isEmpty) {
          throw DoesNotFoundTokenException("Tidak ditemukan token untuk otorisasi");
        }
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 30));

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else if (response.statusCode == 401) {
        throw DoesNotFoundTokenException('Token tidak valid atau tidak ditemukan');
      } else {
        final errorMessage = responseBody['message'] ?? 'Failed with status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } on NetworkException {
      rethrow;
    } on DoesNotFoundTokenException {
      rethrow;
    } on TimeoutException {
      throw Exception('Koneksi timeout, silakan coba lagi.');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(message);
    }
  }

  Future<dynamic> _requestPost(
    String endpoint,
    String message,
    bool authorized, {
    Map<String, dynamic>? body,
  }) async {
    try {
      await _ensureInternetConnection();
      Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: '$basePath/$endpoint',
      );
      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
      if (authorized) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token') ?? '';
        if (token.isEmpty) {
          throw DoesNotFoundTokenException("Tidak ditemukan token untuk otorisasi");
        }
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http
          .post(uri, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 30));

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else if (response.statusCode == 401) {
        throw DoesNotFoundTokenException('Token tidak valid atau tidak ditemukan');
      } else {
        final errorMessage = responseBody['message'] ?? 'Failed with status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } on NetworkException {
      rethrow;
    } on DoesNotFoundTokenException {
      rethrow;
    } on TimeoutException {
      throw Exception('Koneksi timeout, silakan coba lagi.');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(message);
    }
  }

  Future<dynamic> _requestPostMultipart(
    String endpoint,
    String message,
    bool authorized, {
    Map<String, String>? fields,
    Map<String, String>? files,
  }) async {
    try {
      await _ensureInternetConnection();
      Uri uri = Uri(
        scheme: scheme,
        host: host,
        path: '$basePath/$endpoint',
      );
      final request = http.MultipartRequest('POST', uri);
      if (authorized) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token') ?? '';
        if (token.isEmpty) {
          throw DoesNotFoundTokenException("Tidak ditemukan token untuk otorisasi");
        }
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'multipart/form-data';
      if (fields != null) {
        request.fields.addAll(fields);
      }
      if (files != null) {
        for (var entry in files.entries) {
          request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value));
        }
      }
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseBody;
      } else if (response.statusCode == 401) {
        throw DoesNotFoundTokenException('Token tidak valid atau tidak ditemukan');
      } else {
        final errorMessage = responseBody['message'] ?? 'Failed with status code: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } on NetworkException {
      rethrow;
    } on DoesNotFoundTokenException {
      rethrow;
    } on TimeoutException {
      throw Exception('Koneksi timeout, silakan coba lagi.');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception(message);
    }
  }  


  Future<GetAllStoriesResponse> getAllStories() async {
    final response = await _requestGet(
      storyEndpoint, 
      'Gagal memuat cerita, silakan coba lagi.',
      true,
    );
    return GetAllStoriesResponse.fromJson(response);
  }

  Future<GetDetailStoryResponse> getDetailStory(String id) async {
    final response = await _requestGet(
      storyEndpoint, 
      'Gagal memuat detail cerita, silakan coba lagi.',
      true,
      queryParameters: id,
    );
    return GetDetailStoryResponse.fromJson(response);
  }

  Future<RegisterResponse> register(String name, String email, String password) async {
    final response = await _requestPost(
      registerEndpoint, 
      'Gagal melakukan registrasi, silakan coba lagi.',
      false,
      body: {'name': name, 'email': email, 'password': password},
    ); 
    return RegisterResponse.fromJson(response);
  }

  Future<LoginResponse> login(String email, String password) async {
    final response = await _requestPost(
      loginEndpoint, 
      'Gagal melakukan login, silakan coba lagi.',
      false,
      body: {'email': email, 'password': password},
    );
    return LoginResponse.fromJson(response);
  }

  Future<AddNewStoryResponse> addNewStoryWithGuest(String description,  File photo, {String? lat, String? lon}) async {
    Map<String, String> fields = {'description': description};
    if (lat != null) fields['lat'] = lat;
    if (lon != null) fields['lon'] = lon;

    Map<String, String> files = {'photo': photo.path};

    final response = await _requestPostMultipart(
      storyEndpoint, 
      'Gagal menambahkan cerita, silakan coba lagi.',
      false,
      fields: fields,
      files: files,
    );
    return AddNewStoryResponse.fromJson(response);
  }
  Future<AddNewStoryResponse> addNewStoryWithAuth(String description,  File photo, {String? lat, String? lon}) async {
    Map<String, String> fields = {'description': description};
    if (lat != null) fields['lat'] = lat;
    if (lon != null) fields['lon'] = lon;

    Map<String, String> files = {'photo': photo.path};

    final response = await _requestPostMultipart(
      storyEndpoint, 
      'Gagal menambahkan cerita, silakan coba lagi.',
      true,
      fields: fields,
      files: files,
    );
    return AddNewStoryResponse.fromJson(response);
  }
}
