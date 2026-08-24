import 'package:hive_flutter/hive_flutter.dart';

class LocalDataSource {
  Box get box => Hive.box("news");

  Future<void> saveNews({
    required List<dynamic> newsJson,
    required String key,
  }) async {
    await box.put("news_$key", newsJson);
  }

  List<dynamic>? getSavedNews({required String key}) {
    final data = box.get("news_$key") ?? box.get(key);
    if (data is List) {
      return data;
    }
    return null;
  }

  Future<void> saveCategories({
    required List<dynamic> categoriesJson,
    required String key,
  }) async {
    await box.put("categories_$key", categoriesJson);
  }

  List<dynamic>? getSavedCategories({required String key}) {
    final data = box.get("categories_$key");
    if (data is List) {
      return data;
    }
    return null;
  }

  Future<void> saveRecentSearches(List<String> searches) async {
    await box.put("recent_searches", searches);
  }

  List<String> getRecentSearches() {
    final data = box.get("recent_searches");
    if (data is List) {
      return List<String>.from(data);
    }
    return [];
  }
}

