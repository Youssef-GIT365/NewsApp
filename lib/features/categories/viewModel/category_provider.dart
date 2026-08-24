import 'package:flutter/material.dart';
import 'package:news/features/categories/dataSource/category_data_source.dart';
import 'package:news/features/categories/dataSource/local_data_Source.dart';
import 'package:news/features/categories/model/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryDataSource object = CategoryDataSource();
  final LocalDataSource localDataSource = LocalDataSource();
  List<CategoryModel> SourceList = [];

  Future<void> getcategories(String query) async {
    // 1. Load cached categories first (offline support)
    final cachedCategories = localDataSource.getSavedCategories(key: query);
    if (cachedCategories != null && cachedCategories.isNotEmpty) {
      SourceList = cachedCategories
          .map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
      notifyListeners();
    }

    // 2. Fetch fresh data from network
    try {
      final freshCategories = await object.getCategories(query);
      if (freshCategories.isNotEmpty) {
        SourceList = freshCategories;
        final jsonList = freshCategories.map((c) => c.toJson()).toList();
        await localDataSource.saveCategories(categoriesJson: jsonList, key: query);
        notifyListeners();
      }
    } catch (e) {
      // If network fails and no cached data exists, keep SourceList as is
    }
  }
}

