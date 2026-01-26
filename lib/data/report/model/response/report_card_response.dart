import 'package:blessing/data/report/model/response/report_card_data.dart';
import 'package:blessing/data/report/model/response/paging.dart';

class ReportCardResponse {
  final ReportCardData data;
  final Paging paging;

  ReportCardResponse({
    required this.data,
    required this.paging,
  });

  factory ReportCardResponse.fromJson(Map<String, dynamic> json) {
    return ReportCardResponse(
      data: ReportCardData.fromJson(json['data'] ?? {}),
      paging: Paging.fromJson(json['paging'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'paging': paging.toJson(),
    };
  }
}
