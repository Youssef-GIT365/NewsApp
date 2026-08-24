import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news/features/categories/viewModel/category_provider.dart';
import 'package:news/features/categories/viewModel/source_provider.dart';
import 'package:news/features/home/HomeScreen.dart';
import 'package:news/features/home/article_web_view_screen.dart';
import 'package:news/features/home/category_details.dart';
import 'package:news/features/search/view/search_view.dart';
import 'package:news/features/search/viewModel/search_cubit.dart';
import 'package:news/features/splash/splash_view.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: "/",
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(path: '/home', builder: (context, state) => const Homescreen()),
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final initialQuery = state.extra as String?;
          return BlocProvider(
            create: (context) => SearchCubit(),
            child: SearchView(initialQuery: initialQuery),
          );
        },
      ),
      GoRoute(
        path: '/ArticleWebViewScreen',
        builder: (context, state) {
          final url = state.extra as String;
          return ArticleWebViewScreen(url: url);
        },
      ),
      GoRoute(
        path: '/categoryDetails',
        builder: (context, state) {
          final categoryId = state.extra as String;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => CategoryProvider()),
              ChangeNotifierProvider(create: (context) => SourceProvider()),
            ],

            child: CategoryDetails(categoryId: categoryId),
          );
        },
      ),
    ],
  );
}
