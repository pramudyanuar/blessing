import '../../../core/models/paging_response.dart';
import 'course_response.dart';

class CourseListResponse {
  final List<CourseResponse> data;
  final PagingResponse paging;

  CourseListResponse({
    required this.data,
    required this.paging,
  });

  factory CourseListResponse.fromJson(Map<String, dynamic> json) =>
      CourseListResponse(
        data: List<CourseResponse>.from(
          json["data"].map((x) => CourseResponse.fromJson(x)),
        ),
        paging: PagingResponse.fromJson(json["paging"]),
      );
}
