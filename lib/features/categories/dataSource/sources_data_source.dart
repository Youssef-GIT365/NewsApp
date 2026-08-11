import 'package:dio/dio.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SourcesDataSource {
  Future<List<SourcesModel>> getSources(query) async {
    try {
      print("Query sent to API: '$query'");
      if (query.trim().isEmpty) {
        print("Warning: Query is empty, API call skipped.");
        return [];
      }
      var responce = await Dio().get(
        "https://newsapi.org/v2/top-headlines?sources=$query&apiKey=456497d3484f4088bc82d5fb167b0cfa",
      );
      final List data = responce.data["articles"];
      return data.map((source) => SourcesModel.fromJson(source)).toList();
    } on DioException catch (e) {
      print("Error Response: ${e.response?.data}");
      rethrow;
    }
  }
}
