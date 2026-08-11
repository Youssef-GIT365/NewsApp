import 'package:flutter/material.dart';
import 'package:news/features/categories/dataSource/category_data_source.dart';
import 'package:news/features/categories/model/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryDataSource object = CategoryDataSource();
  List<CategoryModel> SourceList = [];
  Future<void> getcategories(query) async {
    SourceList = await object.getCategories(query);
    notifyListeners();
  }
}
