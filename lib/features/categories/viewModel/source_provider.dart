import 'package:flutter/material.dart';
import 'package:news/features/categories/dataSource/local_data_Source.dart';
import 'package:news/features/categories/dataSource/sources_data_source.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SourceProvider extends ChangeNotifier {
  List<SourcesModel> sources = [];
  final SourcesDataSource object = SourcesDataSource();
  final LocalDataSource localDataSource = LocalDataSource();

  Future<void> getSources(String query) async {
    final String cacheKey = query.isEmpty ? "default_sources" : query;

    // 1. Load cached news articles first (offline support)
    final cachedSources = localDataSource.getSavedNews(key: cacheKey);
    if (cachedSources != null && cachedSources.isNotEmpty) {
      sources = cachedSources
          .map((json) => SourcesModel.fromJson(Map<String, dynamic>.from(json as Map)))
          .toList();
      notifyListeners();
    }

    // 2. Fetch fresh news from network
    try {
      final freshSources = await object.getSources(query);
      if (freshSources.isNotEmpty) {
        sources = freshSources;
        final jsonList = freshSources.map((source) => source.toJson()).toList();
        await localDataSource.saveNews(newsJson: jsonList, key: cacheKey);
        notifyListeners();
      }
    } catch (e) {
      // Keep cached sources on network error
    }
  }
}

