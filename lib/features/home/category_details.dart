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
      await context.read<CategoryProvider>().getcategories(widget.categoryId);
      final categories = context.read<CategoryProvider>().SourceList;
      if (categories.isNotEmpty) {
        final firstQuery =
            (categories.first.id != null && categories.first.id!.isNotEmpty)
            ? categories.first.id
            : categories.first.name;
        if (firstQuery != null && firstQuery.isNotEmpty) {
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
        title: Text("Genral"),
        actions: [
          IconButton(onPressed: () {}, icon: Assets.icons.searchIcon.image()),
        ],
      ),
      body: Column(
        children: [
          DefaultTabController(
            length: vm.SourceList.length,
            child: TabBar(
              isScrollable: true,
              padding: EdgeInsets.zero,
              tabAlignment: TabAlignment.start,

              labelColor: Colors.black,
              unselectedLabelColor: Colors.black,
              onTap: (index) {
                final selectedId = vm.SourceList[index].id;
                if (selectedId.isNotEmpty) {
                  context.read<SourceProvider>().getSources(selectedId);
                }
              },
              tabs: vm.SourceList.map((e) {
                return Tab(text: e.name);
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                final item = vmforsources.sources[index];
                DateTime parsedDate = DateTime.parse(item.publishedAt);
                String time = timeago.format(parsedDate);
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
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

                              print(removeHtmlTags(item.content));
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
                                              BorderRadiusGeometry.circular(16),
                                          child: Image.network(item.UrlImage),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            removeHtmlTags(item.content),
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(
                                                  color:
                                                      Appcolors.MainBackWhite,
                                                ),
                                          ),
                                        ),
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
                                          child: Text(
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
                        child: Image.network(item.UrlImage),
                      ),
                      Text(item.title!, style: theme.textTheme.bodyLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "By : ${item.author}",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Color(0xffA0A0A0),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            time,
                            style: theme.textTheme.bodyLarge!.copyWith(
                              color: Color(0xffA0A0A0),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },

              itemCount: vmforsources.sources.length,
            ),
          ),
        ],
      ),
    );
  }
}
