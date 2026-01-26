// lib/data/course/models/request/create_user_course_request.dart

class CreateUserCourseRequest {
  final List<String> courseIds;
  final String userId;

  CreateUserCourseRequest({
    required this.courseIds,
    required this.userId,
  });

  Map<String, dynamic> toJson() => {
        "course_ids": List<dynamic>.from(courseIds.map((x) => x)),
        "user_id": userId,
      };
}
