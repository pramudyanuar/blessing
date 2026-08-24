// lib/data/core/models/content_block.dart

class ContentBlock {
  final String type; // "text", "image", or "video_link" (YouTube URL)
  final String data;

  ContentBlock({
    required this.type,
    required this.data,
  });

  factory ContentBlock.fromJson(Map<String, dynamic> json) => ContentBlock(
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "data": data,
      };
}
