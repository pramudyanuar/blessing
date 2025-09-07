class GetQuizReportCardRequest {
  final String quizId;
  final String? userId;
  final String? sortByScore; // asc / desc
  final int? page;
  final int? size;

  GetQuizReportCardRequest({
    required this.quizId,
    this.userId,
    this.sortByScore,
    this.page,
    this.size,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'quiz_id': quizId,
    };

    if (userId != null) data['user_id'] = userId;
    if (sortByScore != null) data['sort_by_score'] = sortByScore;
    if (page != null) data['page'] = page;
    if (size != null) data['size'] = size;

    return data;
  }

  Map<String, String> toQueryParameters() {
    final Map<String, String> params = {
      'quiz_id': quizId,
    };

    if (userId != null) params['user_id'] = userId!;
    if (sortByScore != null) params['sort_by_score'] = sortByScore!;
    if (page != null) params['page'] = page.toString();
    if (size != null) params['size'] = size.toString();

    return params;
  }
}
