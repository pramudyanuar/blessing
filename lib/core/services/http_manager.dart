// lib/core/services/http_manager.dart

import 'dart:io';
import 'package:blessing/core/services/auth_interceptor.dart'; // Pastikan path ini benar
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

abstract class HttpMethods {
  static const String post = "POST";
  static const String get = "GET";
  static const String put = "PUT";
  static const String patch = "PATCH";
  static const String delete = "DELETE";
}

class HttpManager {
  HttpManager._privateConstructor() {
    _dio.interceptors.add(AuthInterceptor());
    // PENTING: Ganti dengan base URL API Anda yang sebenarnya
    // _dio.options.baseUrl = "https://api.blessing.com";
  }
  static final HttpManager _instance = HttpManager._privateConstructor();
  factory HttpManager() => _instance;

  final Dio _dio = Dio();

  String getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }

  /// Metode ini telah diperbaiki untuk menangani header dengan lebih baik.
  /// Secara otomatis menambahkan 'Content-Type: application/json' untuk request
  /// dengan body (POST, PUT, PATCH).
  Future<Map<String, dynamic>> restRequest({
    required String url,
    String method = HttpMethods.get,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    // --- PERUBAHAN UTAMA DI SINI ---
    // 1. Membuat map header dasar.
    final Map<String, dynamic> baseHeaders = {
      'Accept': 'application/json',
    };

    // 2. Jika ada body yang dikirim, otomatis tambahkan Content-Type JSON.
    // Ini adalah kunci untuk menyelesaikan masalah Anda.
    if (body != null) {
      baseHeaders['Content-Type'] = 'application/json';
    }

    // 3. Gabungkan header dasar dengan header kustom dari pemanggil (jika ada).
    // Header dari parameter `headers` akan menimpa header dasar jika ada key yang sama.
    baseHeaders.addAll(headers ?? {});
    // AuthInterceptor akan menambahkan header 'Authorization' secara otomatis.

    try {
      Response response = await _dio.request(
        url,
        options: Options(
          method: method,
          headers: baseHeaders, // Menggunakan header yang sudah digabungkan
        ),
        data: body,
        queryParameters: queryParameters,
      );

      return {
        'statusCode': response.statusCode,
        'statusMessage': response.statusMessage,
        'data': response.data,
      };
    } on DioException catch (e) {
      debugPrint(
          'HttpManager DioException [${e.requestOptions.path}]: ${e.response?.data}');
      return {
        'statusCode': e.response?.statusCode,
        'statusMessage': e.response?.statusMessage ?? e.message,
        'error': e.message,
        'data': e.response?.data,
      };
    } catch (e) {
      debugPrint('HttpManager Exception: $e');
      return {
        'error': e.toString(),
      };
    }
  }

  /// Metode ini secara khusus menangani pengiriman data multipart/form-data.
  /// Sangat ideal untuk mengunggah file. (Tidak ada perubahan di sini)
  Future<Map<String, dynamic>> uploadFileRequest({
    required String url,
    required File file,
    String fileFieldKey = 'file',
  }) async {
    final headersDefault = {'accept': 'application/json'};

    String fileName = file.path.split('/').last;
    String mimeType = getMimeType(file.path);
    List<String> mimeTypeParts = mimeType.split('/');

    FormData formData = FormData.fromMap({
      fileFieldKey: await MultipartFile.fromFile(
        file.path,
        filename: fileName,
        contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
      ),
    });

    try {
      Response response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headersDefault),
      );

      return {
        'statusCode': response.statusCode,
        'statusMessage': response.statusMessage,
        'data': response.data,
      };
    } on DioException catch (e) {
      debugPrint(
          'HttpManager (uploadFileRequest) DioException [${e.requestOptions.path}]: ${e.response?.data}');
      return {
        'statusCode': e.response?.statusCode,
        'statusMessage': e.response?.statusMessage ?? e.message,
        'error': e.message,
        'data': e.response?.data,
      };
    } catch (e) {
      debugPrint('HttpManager (uploadFileRequest) Exception: $e');
      return {
        'error': e.toString(),
      };
    }
  }
}
