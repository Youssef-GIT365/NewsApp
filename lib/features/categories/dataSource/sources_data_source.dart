import 'package:dio/dio.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SourcesDataSource {
  Future<List<SourcesModel>> getSources(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }
      final response = await Dio().get(
        "https://newsapi.org/v2/top-headlines?sources=$query&apiKey=456497d3484f4088bc82d5fb167b0cfa",
      );
      final List data = response.data["articles"] ?? [];
      return data.map((source) => SourcesModel.fromJson(source)).toList();
    } on DioException {
      rethrow;
    }
  }
}

