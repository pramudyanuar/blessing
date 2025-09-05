import 'package:blessing/data/core/models/paging_response.dart';
import 'package:blessing/data/report/datasource/report_remote_datasource.dart';
import 'package:blessing/data/report/model/response/all_report_cards_response.dart';
import 'package:blessing/data/report/model/response/user_report_card_response.dart';

class ReportCardRepository {
  final ReportCardDataSource _dataSource = ReportCardDataSource();

  Future<({UserReportCardResponse reportCard, PagingResponse paging})?>
      getMyReportCard({
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getMyReportCard(page: page, size: size);
  }

  Future<({UserReportCardResponse reportCard, PagingResponse paging})?>
      getUserReportCard(
    String userId, {
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getUserReportCard(
      userId,
      page: page,
      size: size,
    );
  }

  Future<({AllReportCardsResponse data, PagingResponse paging})?>
      getAllReportCards({
    String? quizId,
    String? userId,
    String? sortByScore,
    int page = 1,
    int size = 10,
  }) async {
    return await _dataSource.getAllReportCards(
      quizId: quizId,
      userId: userId,
      sortByScore: sortByScore,
      page: page,
      size: size,
    );
  }
}
