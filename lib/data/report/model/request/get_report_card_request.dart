class GetReportCardRequest {
  final int? page;
  final int? size;

  GetReportCardRequest({
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

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
