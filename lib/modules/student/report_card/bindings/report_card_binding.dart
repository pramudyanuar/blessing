import 'package:blessing/modules/student/report_card/controllers/report_card_controller.dart';
import 'package:get/get.dart';

class ReportCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportCardController>(() => ReportCardController());
  }
}
