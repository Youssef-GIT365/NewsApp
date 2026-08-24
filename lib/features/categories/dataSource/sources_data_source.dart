import 'package:dio/dio.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SourcesDataSource {
  static const String _baseUrl = "https://newsapi.org/v2/top-headlines";
  static const String _apiKey = "456497d3484f4088bc82d5fb167b0cfa";

  Future<List<SourcesModel>> getSources(
    String query, {
    int page = 1,
    int pageSize = 10,
  }) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return [];
    }

    try {
      final response = await Dio().get(
        _baseUrl,
        queryParameters: {
          'sources': cleanQuery,
          'page': page,
          'pageSize': pageSize,
          'apiKey': _apiKey,
        },
      );
      final List data = response.data["articles"] ?? [];
      return data
          .map((source) => SourcesModel.fromJson(Map<String, dynamic>.from(source as Map)))
          .where(
            (item) =>
                (item.title != null && !item.title!.contains("[Removed]")) &&
                (item.content.isNotEmpty || item.title!.isNotEmpty),
          )
          .toList();
    } on DioException {
      rethrow;
    }
  }
}


