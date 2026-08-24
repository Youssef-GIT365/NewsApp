import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:news/features/categories/dataSource/local_data_Source.dart';
import 'package:news/features/categories/dataSource/sources_data_source.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SourceProvider extends ChangeNotifier {
  static const int pageSize = 10;

  List<SourcesModel> sources = [];
  int page = 1;
  bool isLoading = false;
  bool hasMore = true;
  String currentQuery = "";

  final SourcesDataSource object = SourcesDataSource();
  final LocalDataSource localDataSource = LocalDataSource();

  Future<void> getSources(String query) async {
    final cleanQuery = query.trim();
    currentQuery = cleanQuery;
    page = 1;
    hasMore = true;
    isLoading = true;
    sources.clear();
    notifyListeners();

    if (cleanQuery.isEmpty) {
      isLoading = false;
      hasMore = false;
      notifyListeners();
      return;
    }

    final String cacheKey = cleanQuery;


    final cachedSources = localDataSource.getSavedNews(key: cacheKey);
    if (cachedSources != null && cachedSources.isNotEmpty) {
      sources = cachedSources
          .map(
            (json) =>
                SourcesModel.fromJson(Map<String, dynamic>.from(json as Map)),
          )
          .toList();
      notifyListeners();
    }

  
    try {
      final freshSources = await object.getSources(
        cleanQuery,
        page: page,
        pageSize: pageSize,
      );
      if (freshSources.isNotEmpty) {
        sources = freshSources;
        hasMore = freshSources.length >= pageSize;

        final jsonList = freshSources.map((source) => source.toJson()).toList();
        await localDataSource.saveNews(newsJson: jsonList, key: cacheKey);
      } else {
        if (cachedSources == null || cachedSources.isEmpty) {
          sources = [];
        }
        hasMore = false;
      }
    } catch (e) {
     
      if (sources.isEmpty) {
        hasMore = false;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore || currentQuery.isEmpty) return;

    isLoading = true;
    notifyListeners();

    final nextPage = page + 1;

    try {
      final newSources = await object.getSources(
        currentQuery,
        page: nextPage,
        pageSize: pageSize,
      );

      if (newSources.isNotEmpty) {
        page = nextPage;
        final existingUrls = sources.map((s) => s.url).toSet();
        final uniqueNewSources = newSources
            .where((s) => s.url.isEmpty || !existingUrls.contains(s.url))
            .toList();

        sources.addAll(uniqueNewSources);
        if (newSources.length < pageSize) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } on DioException {
      hasMore = false;
    } catch (e) {
      hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
