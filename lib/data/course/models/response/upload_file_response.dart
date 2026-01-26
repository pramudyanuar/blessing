class UploadFileResponse {
  final UploadFileData data;

  UploadFileResponse({required this.data});

  factory UploadFileResponse.fromJson(Map<String, dynamic> json) =>
      UploadFileResponse(
        data: UploadFileData.fromJson(json["data"]),
      );
}

class UploadFileData {
  final String filename;
  final String url;
  final int size;

  UploadFileData({
    required this.filename,
    required this.url,
    required this.size,
  });

  factory UploadFileData.fromJson(Map<String, dynamic> json) => UploadFileData(
        filename: json["filename"],
        url: json["url"],
        size: json["size"],
      );
}
