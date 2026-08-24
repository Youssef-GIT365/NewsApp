import 'package:dio/dio.dart';
import 'package:news/features/categories/dataSource/local_data_Source.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SearchDataSource {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  final LocalDataSource localDataSource = LocalDataSource();

  static const String _apiKey = "456497d3484f4088bc82d5fb167b0cfa";
  static const String _baseUrl = "https://newsapi.org/v2/everything";

  Future<List<SourcesModel>> searchNews(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return [];
    }

    final cacheKey = "search_${cleanQuery.toLowerCase()}";

    try {
      final encodedQuery = Uri.encodeComponent(cleanQuery);
      final response = await dio.get(
        "$_baseUrl?q=$encodedQuery&sortBy=publishedAt&apiKey=$_apiKey",
      );

      final List rawArticles = response.data["articles"] ?? [];
      final List<SourcesModel> articles = rawArticles
          .map((json) => SourcesModel.fromJson(Map<String, dynamic>.from(json as Map)))
          .where((item) =>
              (item.title != null && !item.title!.contains("[Removed]")) &&
              (item.content.isNotEmpty || item.title!.isNotEmpty))
          .toList();

      // Save to local cache
      if (articles.isNotEmpty) {
        final jsonList = articles.map((source) => source.toJson()).toList();
        await localDataSource.saveNews(newsJson: jsonList, key: cacheKey);
      }

      return articles;
    } on DioException {
      // Offline fallback: load cached results if available
      final cachedData = localDataSource.getSavedNews(key: cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData
            .map((json) =>
                SourcesModel.fromJson(Map<String, dynamic>.from(json as Map)))
            .toList();
      }
      rethrow;
    } catch (e) {
      final cachedData = localDataSource.getSavedNews(key: cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData
            .map((json) =>
                SourcesModel.fromJson(Map<String, dynamic>.from(json as Map)))
            .toList();
      }
      rethrow;
    }
  }
}
