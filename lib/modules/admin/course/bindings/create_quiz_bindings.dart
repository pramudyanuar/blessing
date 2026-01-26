import 'package:blessing/data/quiz/repository/question_option_repository.dart';
import 'package:blessing/data/quiz/repository/question_repository_impl.dart';
import 'package:blessing/data/quiz/repository/quiz_answer_repository_impl.dart';
import 'package:blessing/data/quiz/repository/quiz_repository_impl.dart';
import 'package:blessing/modules/admin/course/controllers/create_quiz_controller.dart';
import 'package:get/get.dart';

class CreateQuizBindings extends Bindings {
  @override
  void dependencies() {
    // Registrasi repository supaya bisa diakses via Get.find
    Get.lazyPut<QuizRepository>(() => QuizRepository());
    Get.lazyPut<QuestionRepository>(() => QuestionRepository());
    Get.lazyPut<QuestionOptionRepository>(() => QuestionOptionRepository());
    Get.lazyPut<QuizAnswerRepository>(() => QuizAnswerRepository());

    // Registrasi controller
    Get.lazyPut<CreateQuizController>(() => CreateQuizController());
  }
}
