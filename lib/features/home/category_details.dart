import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news/core/gen/assets.gen.dart';
import 'package:news/core/theme/appcolors.dart';
import 'package:news/features/categories/viewModel/category_provider.dart';
import 'package:news/features/categories/viewModel/source_provider.dart';
import 'package:news/features/home/drawer.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class CategoryDetails extends StatefulWidget {
  final String categoryId;
  const CategoryDetails({super.key, required this.categoryId});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await context.read<CategoryProvider>().getcategories(widget.categoryId);
      if (!mounted) return;
      final categories = context.read<CategoryProvider>().SourceList;
      if (categories.isNotEmpty) {
        final firstQuery = categories.first.id.isNotEmpty
            ? categories.first.id
            : categories.first.name;
        if (firstQuery.isNotEmpty) {
          context.read<SourceProvider>().getSources(firstQuery);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<CategoryProvider>();
    final vmforsources = context.watch<SourceProvider>();

    return Scaffold(
      drawer: Drawer(child: CustomDrawer()),
      appBar: AppBar(
        title: Text(widget.categoryId.isNotEmpty
            ? widget.categoryId[0].toUpperCase() + widget.categoryId.substring(1)
            : "News"),
        actions: [
          IconButton(onPressed: () {}, icon: Assets.icons.searchIcon.image()),
        ],
      ),
      body: vm.SourceList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DefaultTabController(
                  length: vm.SourceList.length,
                  child: TabBar(
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    tabAlignment: TabAlignment.start,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    onTap: (index) {
                      final selectedSource = vm.SourceList[index];
                      final query = selectedSource.id.isNotEmpty
                          ? selectedSource.id
                          : selectedSource.name;
                      if (query.isNotEmpty) {
                        context.read<SourceProvider>().getSources(query);
                      }
                    },
                    tabs: vm.SourceList.map((e) {
                      return Tab(text: e.name);
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: vmforsources.sources.isEmpty
                      ? const Center(child: Text("No news available."))
                      : ListView.builder(
                          itemCount: vmforsources.sources.length,
                          itemBuilder: (context, index) {
                            final item = vmforsources.sources[index];
                            String time = "";
                            try {
                              if (item.publishedAt.isNotEmpty) {
                                DateTime parsedDate = DateTime.parse(item.publishedAt);
                                time = timeago.format(parsedDate);
                              }
                            } catch (_) {
                              time = item.publishedAt;
                            }
                            return Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          String removeHtmlTags(String htmlString) {
                                            return htmlString
                                                .replaceAll(RegExp(r'<[^>]*>'), '')
                                                .trim();
                                          }

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
                                                      borderRadius:
                                                          BorderRadius.circular(16),
                                                      child: item.UrlImage.isNotEmpty
                                                          ? Image.network(
                                                              item.UrlImage,
                                                              height: 180,
                                                              width: double.infinity,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context, error, stackTrace) =>
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
                                                        removeHtmlTags(item.content),
                                                        maxLines: 4,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: theme.textTheme.bodyLarge!
                                                            .copyWith(
                                                          color: Appcolors.MainBackWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.white,
                                                        foregroundColor: Colors.black,
                                                        minimumSize: const Size(
                                                          double.infinity,
                                                          56,
                                                        ),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(25),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        context.pop();
                                                        context.go(
                                                          "/ArticleWebViewScreen",
                                                          extra: item.url,
                                                        );
                                                      },
                                                      child: const Text(
                                                        "View Full Article",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
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
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.title ?? "",
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "By : ${item.author}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyLarge!.copyWith(
                                            color: const Color(0xffA0A0A0),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        time,
                                        style: theme.textTheme.bodyLarge!.copyWith(
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
                        ),
                ),
              ],
            ),
    );
  }
}

