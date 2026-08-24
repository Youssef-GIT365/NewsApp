import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/categories/dataSource/local_data_Source.dart';
import 'package:news/features/categories/model/sources_model.dart';
import 'package:news/features/search/dataSource/search_data_source.dart';
import 'package:news/features/search/viewModel/search_cubit.dart';
import 'package:news/features/search/viewModel/search_state.dart';

class FakeSearchDataSource extends SearchDataSource {
  final List<SourcesModel> resultToReturn;
  final bool shouldThrow;

  FakeSearchDataSource({this.resultToReturn = const [], this.shouldThrow = false});

  @override
  Future<List<SourcesModel>> searchNews(String query) async {
    if (shouldThrow) {
      throw Exception("Network error");
    }
    return resultToReturn;
  }
}

class FakeLocalDataSource extends LocalDataSource {
  List<String> storedSearches = [];

  @override
  List<String> getRecentSearches() {
    return List<String>.from(storedSearches);
  }

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    storedSearches = List<String>.from(searches);
  }
}

void main() {
  group('SearchCubit Tests', () {
    late FakeLocalDataSource fakeLocalDataSource;

    setUp(() {
      fakeLocalDataSource = FakeLocalDataSource();
    });

    test('initial state has empty recent searches if none saved', () {
      final cubit = SearchCubit(
        dataSource: FakeSearchDataSource(),
        localDataSource: fakeLocalDataSource,
      );

      expect(cubit.state, isA<SearchInitial>());
      expect((cubit.state as SearchInitial).recentSearches, isEmpty);
      cubit.close();
    });

    test('search emits SearchLoading then SearchSuccess when results found', () async {
      final sampleArticle = SourcesModel(
        UrlImage: 'https://example.com/img.jpg',
        author: 'Author',
        content: 'Content',
        publishedAt: '2026-08-24T12:00:00Z',
        title: 'Breaking Tech News',
        url: 'https://example.com/article',
      );

      final cubit = SearchCubit(
        dataSource: FakeSearchDataSource(resultToReturn: [sampleArticle]),
        localDataSource: fakeLocalDataSource,
      );

      final expectedStates = [
        isA<SearchLoading>(),
        isA<SearchSuccess>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.search('tech');

      expect(cubit.state, isA<SearchSuccess>());
      final success = cubit.state as SearchSuccess;
      expect(success.articles.length, 1);
      expect(success.articles.first.title, 'Breaking Tech News');
      expect(fakeLocalDataSource.storedSearches, contains('tech'));

      cubit.close();
    });

    test('search emits SearchEmpty when no articles match', () async {
      final cubit = SearchCubit(
        dataSource: FakeSearchDataSource(resultToReturn: []),
        localDataSource: fakeLocalDataSource,
      );

      final expectedStates = [
        isA<SearchLoading>(),
        isA<SearchEmpty>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.search('nonexistent_query_xyz');
      expect(cubit.state, isA<SearchEmpty>());

      cubit.close();
    });

    test('search emits SearchError on exception', () async {
      final cubit = SearchCubit(
        dataSource: FakeSearchDataSource(shouldThrow: true),
        localDataSource: fakeLocalDataSource,
      );

      final expectedStates = [
        isA<SearchLoading>(),
        isA<SearchError>(),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.search('error_query');
      expect(cubit.state, isA<SearchError>());

      cubit.close();
    });

    test('recent searches management (add, remove, clear)', () async {
      final cubit = SearchCubit(
        dataSource: FakeSearchDataSource(
          resultToReturn: [
            SourcesModel(
              UrlImage: '',
              author: '',
              content: '',
              publishedAt: '',
              title: 'Flutter Update',
              url: '',
            ),
          ],
        ),
        localDataSource: fakeLocalDataSource,
      );

      await cubit.search('flutter');
      expect(fakeLocalDataSource.storedSearches, ['flutter']);

      await cubit.removeRecentSearch('flutter');
      expect(fakeLocalDataSource.storedSearches, isEmpty);

      cubit.close();
    });
  });
}
