import 'package:dio/dio.dart';
import 'package:news/core/constans/app_constans.dart';
import 'package:news/features/categories/model/category_model.dart';

class CategoryDataSource {
  Future<List<CategoryModel>> getCategories(query) async {
    var responce = await Dio().get(
      "https://newsapi.org/v2/everything?q=$query&apiKey=456497d3484f4088bc82d5fb167b0cfa",
    );
    final List data = responce.data["articles"];
    return data.map((cat) => CategoryModel.fromJson(cat["source"])).toList();
  }

}
