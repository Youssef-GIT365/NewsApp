import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news/core/gen/assets.gen.dart';
import 'package:news/core/l10n/app_localizations.dart';
import 'package:news/core/theme/appcolors.dart';
import 'package:news/features/categories/model/sources_model.dart';
import 'package:news/features/search/viewModel/search_cubit.dart';
import 'package:news/features/search/viewModel/search_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchView extends StatefulWidget {
  final String? initialQuery;

  const SearchView({super.key, this.initialQuery});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _suggestedTopics = const [
    'Technology',
    'Sports',
    'Business',
    'Health',
    'Science',
    'Entertainment',
    'AI',
    'Crypto',
    'World',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.trim().isNotEmpty) {
      _searchController.text = widget.initialQuery!.trim();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<SearchCubit>().search(_searchController.text);
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTopicSelected(String topic) {
    _searchController.text = topic;
    _focusNode.unfocus();
    context.read<SearchCubit>().search(topic);
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchCubit>().clearSearch();
  }

  String _removeHtmlTags(String htmlString) {
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  void _showArticleBottomSheet(BuildContext context, SourcesModel item) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 450,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: item.UrlImage.isNotEmpty
                        ? Image.network(
                            item.UrlImage,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              height: 180,
                              color: Colors.grey.shade800,
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  color: Colors.white54,
                                  size: 40,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 180),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _removeHtmlTags(
                        item.content.isNotEmpty
                            ? item.content
                            : (item.title ?? ""),
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Appcolors.MainBackWhite,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(bottomSheetContext).pop();
                      if (item.url != null && item.url!.isNotEmpty) {
                        context.push(
                          "/ArticleWebViewScreen",
                          extra: item.url,
                        );
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)?.view_full_article ??
                          "View Full Article",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.grey.shade300,
              ),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: local?.search_news ?? "Search news...",
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade500,
                  fontSize: 15,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Assets.icons.searchIcon.image(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                suffixIcon: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _searchController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) return const SizedBox.shrink();
                    return IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                      onPressed: _clearSearch,
                    );
                  },
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
              onChanged: (val) {
                context.read<SearchCubit>().debounceSearch(val);
              },
              onSubmitted: (val) {
                _focusNode.unfocus();
                context.read<SearchCubit>().search(val);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SearchSuccess) {
            return _buildResultsList(context, state.articles);
          }

          if (state is SearchEmpty) {
            return _buildEmptyState(context, state.query);
          }

          if (state is SearchError) {
            return _buildErrorState(context, state.message);
          }

          final recentSearches = (state is SearchInitial)
              ? state.recentSearches
              : <String>[];

          return _buildInitialView(context, recentSearches);
        },
      ),
    );
  }

  Widget _buildInitialView(
    BuildContext context,
    List<String> recentSearches,
  ) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  local?.recent_searches ?? "Recent Searches",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<SearchCubit>().clearRecentSearches();
                  },
                  child: Text(
                    local?.clear_all ?? "Clear All",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recentSearches.map((term) {
                return InputChip(
                  label: Text(term),
                  backgroundColor:
                      isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F0),
                  labelStyle: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                  deleteIconColor:
                      isDark ? Colors.white54 : Colors.grey.shade600,
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    context.read<SearchCubit>().removeRecentSearch(term);
                  },
                  onPressed: () {
                    _onTopicSelected(term);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color:
                          isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
          Text(
            local?.suggested_topics ?? "Suggested Topics",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedTopics.map((topic) {
              return ActionChip(
                label: Text(topic),
                backgroundColor:
                    isDark ? const Color(0xFF262626) : const Color(0xFFF5F5F5),
                labelStyle: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                onPressed: () {
                  _onTopicSelected(topic);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList(BuildContext context, List<SourcesModel> articles) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.builder(
      itemCount: articles.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final item = articles[index];
        String time = "";
        try {
          if (item.publishedAt.isNotEmpty) {
            final parsedDate = DateTime.parse(item.publishedAt);
            time = timeago.format(parsedDate);
          }
        } catch (_) {
          time = item.publishedAt;
        }

        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF202020) : Colors.white,
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _showArticleBottomSheet(context, item),
                child: item.UrlImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.UrlImage,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            height: 180,
                            color:
                                isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: isDark ? Colors.white54 : Colors.grey,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showArticleBottomSheet(context, item),
                child: Text(
                  item.title ?? "",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "By : ${item.author.trim().isNotEmpty ? item.author : 'Unknown'}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xffA0A0A0),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: const Color(0xffA0A0A0),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String query) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 72,
              color: isDark ? Colors.white38 : Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              "${local?.no_results_found ?? 'No news found'} for \"$query\"",
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              local?.try_different_search ??
                  "Try searching with different keywords or check for typos",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              "Something went wrong",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final query = _searchController.text.trim();
                if (query.isNotEmpty) {
                  context.read<SearchCubit>().search(query);
                } else {
                  context.read<SearchCubit>().loadRecentSearches();
                }
              },
              icon: const Icon(Icons.refresh),
              label: Text(local?.try_again ?? "Try Again"),
            ),
          ],
        ),
      ),
    );
  }
}
