class GetUserReportCardRequest {
  final String userId;
  final int? page;
  final int? size;

  GetUserReportCardRequest({
    required this.userId,
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user_id': userId,
    };

    if (page != null) data['page'] = page;
    if (size != null) data['size'] = size;

    return data;
  }

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {};

    if (page != null) params['page'] = page.toString();
    if (size != null) params['size'] = size.toString();

    return params;
  }
}
