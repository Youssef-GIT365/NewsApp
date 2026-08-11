import 'package:flutter/material.dart';
import 'package:news/features/categories/dataSource/sources_data_source.dart';
import 'package:news/features/categories/model/sources_model.dart';

class SourceProvider extends ChangeNotifier {
  List<SourcesModel> sources = [];
  SourcesDataSource object = SourcesDataSource();
  Future<void> getSources(query) async {
    print("getSources called with query: $query");
    sources = await object.getSources(query);
    print("sources fetched count: ${sources.length}");
    notifyListeners();
  }
}
