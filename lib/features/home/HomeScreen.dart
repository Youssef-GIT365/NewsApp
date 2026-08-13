import 'package:flutter/material.dart';
import 'package:news/core/gen/assets.gen.dart';
import 'package:news/core/l10n/app_localizations.dart';
import 'package:news/core/models/category_model.dart';
import 'package:news/features/home/CategoryCard.dart';
import 'package:news/features/home/drawer.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final List<CategoryModel> categories = [
      CategoryModel(
        id: 'general',
        name: 'General',
        image: Assets.images.general.path,
      ),
      CategoryModel(
        id: 'business',
        name: 'Business',
        image: Assets.images.busniess.path,
      ),
      CategoryModel(
        id: 'sports',
        name: 'Sports',
        image: Assets.images.sport.path,
      ),
      CategoryModel(
        id: 'technology',
        name: 'Technology',
        image: Assets.images.technology.path,
      ),
      CategoryModel(
        id: 'entertainment',
        name: 'Entertainment',
        image: Assets.images.entertainment.path,
      ),
      CategoryModel(
        id: 'health',
        name: 'Health',
        image: Assets.images.helth.path,
      ),
      CategoryModel(
        id: 'science',
        name: 'Science',
        image: Assets.images.science.path,
      ),
    ];
    final theme = Theme.of(context);
    return Scaffold(
      drawer: Drawer(child: CustomDrawer()),

      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Assets.icons.searchIcon.image()),
        ],

        title: Text(local.home, style: theme.textTheme.titleLarge),
        // leading: ,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              '''Good Morning
Here is Some News For You''',
              style: theme.textTheme.titleMedium!.copyWith(fontSize: 24),
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return CategoryCard(index: index, category: categories[index]);
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}
