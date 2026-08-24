import 'package:news/features/categories/model/sources_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {
  final List<String> recentSearches;
  SearchInitial({this.recentSearches = const []});
}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<SourcesModel> articles;
  final String query;

  SearchSuccess({required this.articles, required this.query});
}

class SearchEmpty extends SearchState {
  final String query;

  SearchEmpty({required this.query});
}

class SearchError extends SearchState {
  final String message;

  SearchError({required this.message});
}
