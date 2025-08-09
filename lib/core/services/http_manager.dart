import 'dart:convert';
import 'dart:io';
import 'package:blessing/core/services/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

abstract class HttpMethods {
  static const String post = "POST";
  static const String get = "GET";
  static const String put = "PUT";
  static const String patch = "PATCH";
  static const String delete = "DELETE";
}

class HttpManager {
  // --- SINGLETON SETUP ---
  // This ensures there is only one instance of Dio and HttpManager in your app
  HttpManager._privateConstructor() {
    // Add the interceptor to the Dio instance when it's created
    _dio.interceptors.add(AuthInterceptor());
    _dio.options.baseUrl =
        "https://your.api.baseurl.com/api"; // IMPORTANT: Set your base URL here
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
      case 'pdf':
        return 'application/pdf';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  // --- REVISED restRequest METHOD ---
  // The 'useAuth' parameter is no longer needed. The interceptor handles it.
  Future<Map<String, dynamic>> restRequest({
    required String url,
    String method = HttpMethods.get,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final headersDefault = headers ?? {'accept': 'application/json'};

    dynamic requestBody = body;

    // FormData logic remains the same
    if (body != null && body['file'] != null && body['file'] is File) {
      FormData formData = FormData();

      body.forEach((key, value) {
        if (key == 'hashtags' && value is List<String>) {
          String hashtagsJson = jsonEncode(value);
          formData.fields.add(MapEntry('hashtags', hashtagsJson));
        } else if (key == 'file' && value is File) {
          File file = value;
          String mimeType = getMimeType(file.path);
          List<String> mimeTypeParts = mimeType.split('/');

          formData.files.add(MapEntry(
            'file',
            MultipartFile.fromFileSync(
              file.path,
              filename: file.path.split(Platform.pathSeparator).last,
              contentType: MediaType(mimeTypeParts[0], mimeTypeParts[1]),
            ),
          ));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });
      requestBody = formData;
    }

    try {
      Response response = await _dio.request(
        url,
        options: Options(method: method, headers: headersDefault),
        data: requestBody,
        queryParameters: queryParameters,
      );

      return {
        'statusCode': response.statusCode,
        'statusMessage': response.statusMessage,
        'data': response.data,
      };
    } on DioException catch (e) {
      // The interceptor's onError will run before this catch block for Dio-specific errors
      return {
        'statusCode': e.response?.statusCode,
        'statusMessage': e.response?.statusMessage ?? e.message,
        'error': e.message,
        'data': e.response?.data,
      };
    } catch (e) {
      return {
        'error': e.toString(),
      };
    }
  }
}
