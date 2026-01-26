// lib/data/core/models/paging_response.dart

class PagingResponse {
  final int page;
  final int size;
  final int totalItem;
  final int totalPage;

  PagingResponse({
    required this.page,
    required this.size,
    required this.totalItem,
    required this.totalPage,
  });

  factory PagingResponse.fromJson(Map<String, dynamic> json) => PagingResponse(
        page: json["page"],
        size: json["size"],
        totalItem: json["total_item"],
        totalPage: json["total_page"],
      );
}
