import 'package:dio/dio.dart';
import 'package:news/features/categories/model/category_model.dart';

class CategoryDataSource {
  Future<List<CategoryModel>> getCategories(String query) async {
    try {
      final response = await Dio().get(
        "https://newsapi.org/v2/top-headlines/sources?category=$query&apiKey=456497d3484f4088bc82d5fb167b0cfa",
      );
      final List data = response.data["sources"] ?? [];
      return data.map((cat) => CategoryModel.fromJson(cat)).toList();
    } on DioException {
      rethrow;
    }
  }
}

