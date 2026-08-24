import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/categories/dataSource/local_data_Source.dart';
import 'package:news/features/search/dataSource/search_data_source.dart';
import 'package:news/features/search/viewModel/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchDataSource dataSource;
  final LocalDataSource localDataSource;
  Timer? _debounceTimer;

  SearchCubit({SearchDataSource? dataSource, LocalDataSource? localDataSource})
    : dataSource = dataSource ?? SearchDataSource(),
      localDataSource = localDataSource ?? LocalDataSource(),
      super(SearchInitial()) {
    loadRecentSearches();
  }

  void loadRecentSearches() {
    final recent = localDataSource.getRecentSearches();
    emit(SearchInitial(recentSearches: recent));
  }

  void debounceSearch(String query) {
    _debounceTimer?.cancel();
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      loadRecentSearches();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      search(cleanQuery);
    });
  }

  Future<void> search(String query) async {
    if (isClosed) return;
    _debounceTimer?.cancel();
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      loadRecentSearches();
      return;
    }

    emit(SearchLoading());

    try {
      final articles = await dataSource.searchNews(cleanQuery);
      if (articles.isEmpty) {
        emit(SearchEmpty(query: cleanQuery));
      } else {
        await _saveRecentSearchTerm(cleanQuery);
        emit(SearchSuccess(articles: articles, query: cleanQuery));
      }
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  Future<void> _saveRecentSearchTerm(String query) async {
    final recent = localDataSource.getRecentSearches();
    recent.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    recent.insert(0, query);

    // Keep maximum 10 recent searches
    if (recent.length > 10) {
      recent.removeRange(10, recent.length);
    }

    await localDataSource.saveRecentSearches(recent);
  }

  Future<void> removeRecentSearch(String query) async {
    final recent = localDataSource.getRecentSearches();
    recent.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    await localDataSource.saveRecentSearches(recent);
    if (state is SearchInitial) {
      emit(SearchInitial(recentSearches: recent));
    }
  }

  Future<void> clearRecentSearches() async {
    await localDataSource.saveRecentSearches([]);
    if (state is SearchInitial) {
      emit(SearchInitial(recentSearches: const []));
    }
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    loadRecentSearches();
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
