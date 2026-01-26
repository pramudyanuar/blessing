import 'package:blessing/main.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Exclude login and register routes from having the token attached
    if (options.path.contains('/login') || options.path.contains('/register')) {
      print('AuthInterceptor: Skipping token for ${options.path}');
      return handler.next(options);
    }

    final String? accessToken = await secureStorageUtil.getAccessToken();

    print(
        'AuthInterceptor: Retrieved token: ${accessToken?.substring(0, 8)}...'); // Log partial token for debugging

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = accessToken;
      print('AuthInterceptor: Added Authorization header for ${options.path}');
    } else {
      print('AuthInterceptor: No token available for ${options.path}');
    }

    // Continue with the request
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Example: Handle 401 Unauthorized errors globally
    if (err.response?.statusCode == 401) {
      print(
          'AuthInterceptor: Unauthorized request at ${err.requestOptions.path}');
      print('AuthInterceptor: Request headers: ${err.requestOptions.headers}');
      // For example, you could log the user out:
      // secureStorageUtil.deleteAccessToken();
      // Get.offAllNamed(AppRoutes.login);
    }

    // Continue with the error
    return handler.next(err);
  }
}
