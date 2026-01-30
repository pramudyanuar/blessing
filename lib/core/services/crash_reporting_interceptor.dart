import 'package:dio/dio.dart';
import 'crash_reporting_service.dart';

/// Dio interceptor untuk auto-report API errors ke Crashlytics
class CrashReportingInterceptor extends Interceptor {
  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Report API error ke Crashlytics
    await crashReporting.reportApiError(
      endpoint: err.requestOptions.path,
      statusCode: err.response?.statusCode ?? 0,
      message: err.message ?? 'Unknown error',
      responseBody: err.response?.toString(),
    );

    // Pass error to next interceptor
    handler.next(err);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Check for error status codes
    if (response.statusCode != null && response.statusCode! >= 400) {
      await crashReporting.reportApiError(
        endpoint: response.requestOptions.path,
        statusCode: response.statusCode!,
        message: 'HTTP ${response.statusCode}',
        responseBody: response.data.toString(),
      );
    }

    handler.next(response);
  }
}
