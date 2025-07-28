// lib/data/core/models/upload_response.dart

class UploadResponse {
  final String dataUrl;

  UploadResponse({required this.dataUrl});

  // The API spec shows "data" as the key in the response object
  factory UploadResponse.fromJson(Map<String, dynamic> json) => UploadResponse(
        dataUrl: json["data"],
      );
}
