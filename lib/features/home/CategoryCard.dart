import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:news/core/gen/assets.gen.dart';
import 'package:news/core/models/category_model.dart';
import 'package:news/core/theme/appcolors.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int index;
  const CategoryCard({super.key, required this.category, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          image: DecorationImage(
            image: AssetImage(category.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Directionality(
          textDirection: index % 2 == 0 ? TextDirection.ltr : TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  textAlign: TextAlign.start,
                  category.name,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Appcolors.MainBackWhite,
                    fontSize: 30,
                  ),
                ),
                Container(
                  height: 54,
                  width: 169,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(84),
                    color: Color(0xff8E8E8E),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.go("/categoryDetails", extra: category.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "View All",
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Appcolors.MainBackWhite,
                          ),
                          child: index % 2 == 0
                              ? Assets.icons.arrowRight.image()
                              : Assets.icons.arrowLeft.image(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
