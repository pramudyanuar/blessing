class Paging {
  final int page;
  final int size;
  final int totalItem;
  final int totalPage;

  Paging({
    required this.page,
    required this.size,
    required this.totalItem,
    required this.totalPage,
  });

  factory Paging.fromJson(Map<String, dynamic> json) {
    return Paging(
      page: json['page'] ?? 1,
      size: json['size'] ?? 10,
      totalItem: json['total_item'] ?? 0,
      totalPage: json['total_page'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'size': size,
      'total_item': totalItem,
      'total_page': totalPage,
    };
  }
}
