import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Base API service for communicating with the CodeIgniter 4 backend on XAMPP.
/// Connects strictly to the backend server and MySQL database.
class ApiService {
  static List<String> get _candidateUrls => kIsWeb
      ? [
          'http://localhost:8080/api',
          'http://localhost/cofeflow/coffeeflow-backend/public/api',
        ]
      : [
          'http://10.0.2.2:8080/api',
          'http://10.0.2.2/cofeflow/coffeeflow-backend/public/api',
        ];

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Perform a GET request strictly connecting to the backend
  static Future<dynamic> get(String endpoint) async {
    Object? lastError;
    for (final base in _candidateUrls) {
      try {
        final response = await http
            .get(
              Uri.parse('$base/$endpoint'),
              headers: _headers,
            )
            .timeout(const Duration(seconds: 3));
        return _processResponse(response);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Gagal terhubung ke database XAMPP: $lastError');
  }

  /// Perform a POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    Object? lastError;
    for (final base in _candidateUrls) {
      try {
        final response = await http
            .post(
              Uri.parse('$base/$endpoint'),
              headers: _headers,
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 4));
        return _processResponse(response);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Gagal terhubung ke database XAMPP: $lastError');
  }

  /// Perform a PUT request
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    Object? lastError;
    for (final base in _candidateUrls) {
      try {
        final response = await http
            .put(
              Uri.parse('$base/$endpoint'),
              headers: _headers,
              body: jsonEncode(body),
            )
            .timeout(const Duration(seconds: 4));
        return _processResponse(response);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Gagal terhubung ke database XAMPP: $lastError');
  }

  /// Perform a DELETE request
  static Future<dynamic> delete(String endpoint) async {
    Object? lastError;
    for (final base in _candidateUrls) {
      try {
        final response = await http
            .delete(
              Uri.parse('$base/$endpoint'),
              headers: _headers,
            )
            .timeout(const Duration(seconds: 4));
        return _processResponse(response);
      } catch (e) {
        lastError = e;
      }
    }
    throw Exception('Gagal terhubung ke database XAMPP: $lastError');
  }

  /// Process HTTP response and handle errors
  static dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'API Error ${response.statusCode}: ${response.body}',
      );
    }
  }
}
