// lib/data/course/models/response/user_course_response.dart

import '../../../user/models/response/user_response.dart';
import 'course_response.dart';

class UserCourseResponse {
  final String id;
  final UserResponse user;
  final CourseResponse course;
  final DateTime accessedAt;

  UserCourseResponse({
    required this.id,
    required this.user,
    required this.course,
    required this.accessedAt,
  });

  factory UserCourseResponse.fromJson(Map<String, dynamic> json) =>
      UserCourseResponse(
        id: json["id"],
        user: UserResponse.fromJson(json["user"]),
        course: CourseResponse.fromJson(json["course"]),
        accessedAt: DateTime.parse(json["accessed_at"]),
      );
}
