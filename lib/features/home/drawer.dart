import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news/core/gen/assets.gen.dart';
import 'package:news/core/theme/appcolors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _list = ["dark", "light"];
    return Column(
      children: [
        Container(
          color: Appcolors.MainBackWhite,
          height: 166,

          width: double.infinity,
          child: Center(
            child: Text(
              "News App",
              style: theme.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Appcolors.MainBackDark,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      context.go("home");
                    },
                    child: Row(
                      children: [
                        Assets.icons.home.image(),
                        SizedBox(width: 15),
                        Text(
                          "Go To Home",
                          style: theme.textTheme.bodyLarge!.copyWith(
                            color: Appcolors.MainBackWhite,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  color: Appcolors.MainBackWhite,
                ),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    children: [
                      Assets.icons.rollerPaintBrush.image(),
                      SizedBox(width: 15),
                      Text(
                        "Theme",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: Appcolors.MainBackWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomDropdown<String>(
                    hintText: _list[0],

                    items: _list,
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Appcolors.MainBackDark,
                      expandedFillColor: Appcolors.MainBackWhite,
                      closedSuffixIcon: Assets.icons.polygon1.svg(),
                      hintStyle: TextStyle(
                        color: Appcolors.MainBackWhite,
                        fontSize: 16,
                      ),
                      headerStyle: TextStyle(
                        color: Appcolors.MainBackWhite,
                        fontSize: 16,
                      ),
                      listItemStyle: TextStyle(
                        color: Appcolors.MainBackDark,
                        fontSize: 16,
                      ),
                      closedBorder: Border.all(color: Appcolors.MainBackWhite),
                    ),
                    animation: const CustomDropdownAnimation(
                      type: DropdownAnimationType
                          .scaleFade, // size, fade, sizeFade, scale, scaleFade, slide
                      duration: Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      staggerItems: true,
                    ),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(height: 15),
                Divider(
                  endIndent: 20,
                  indent: 20,
                  color: Appcolors.MainBackWhite,
                ),
                Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Row(
                    children: [
                      Assets.icons.earth.image(),
                      SizedBox(width: 15),
                      Text(
                        "Language",
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: Appcolors.MainBackWhite,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomDropdown<String>(
                    hintText: "Arabic",

                    items: ["Arabic", "english"],
                    decoration: CustomDropdownDecoration(
                      closedFillColor: Appcolors.MainBackDark,
                      expandedFillColor: Appcolors.MainBackWhite,
                      closedSuffixIcon: Assets.icons.polygon1.svg(),
                      hintStyle: TextStyle(
                        color: Appcolors.MainBackWhite,
                        fontSize: 16,
                      ),
                      headerStyle: TextStyle(
                        color: Appcolors.MainBackWhite,
                        fontSize: 16,
                      ),
                      listItemStyle: TextStyle(
                        color: Appcolors.MainBackDark,
                        fontSize: 16,
                      ),
                      closedBorder: Border.all(color: Appcolors.MainBackWhite),
                    ),
                    animation: const CustomDropdownAnimation(
                      type: DropdownAnimationType
                          .scaleFade, // size, fade, sizeFade, scale, scaleFade, slide
                      duration: Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      staggerItems: true,
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
