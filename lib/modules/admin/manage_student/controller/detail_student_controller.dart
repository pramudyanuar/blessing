import 'package:get/get.dart';

class DetailStudentController extends GetxController {
  var isEditMode = false.obs;

  // Data siswa
  var name = "John Doe".obs;
  var grade = "7".obs;
  var school = "Greenwood High School".obs;
  var birthDate = "2010-03-15".obs;

  // Nilai kuis (hanya tampil)
  final quizScores = {
    "Quiz 1": 85,
    "Quiz 2": 85,
    "Quiz 3": 85,
    "Quiz 4": 85,
  };

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
    
  }

  void updateName(String value) => name.value = value;
  void updateGrade(String value) => grade.value = value;
  void updateSchool(String value) => school.value = value;
  void updateBirthDate(String value) => birthDate.value = value;
}
