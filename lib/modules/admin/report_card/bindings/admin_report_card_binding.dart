import 'package:blessing/modules/admin/report_card/controller/admin_report_card_controller.dart';
import 'package:blessing/data/report/repository/report_repository_impl.dart';
import 'package:get/get.dart';

class AdminReportCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportRepository>(() => ReportRepository());
    Get.lazyPut<AdminReportCardController>(() => AdminReportCardController());
  }
}
