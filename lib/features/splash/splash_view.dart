import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news/core/gen/assets.gen.dart';
import 'package:news/core/theme/app_theme.dart';
import 'package:news/features/splash/controller/splash_cubit.dart';
import 'package:news/features/splash/controller/splash_state.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => SplashCubit()..startTimer(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashNavigateToHome) {
            context.go('/home');
          }
        },
        child: Scaffold(
          backgroundColor: isDark
              ? AppTheme.darkBackgroundColor
              : AppTheme.lightBackgroundColor,
          body: Center(
            child: isDark
                ? Assets.images.darkLogo.image()
                : Assets.images.mainLogo.image(),
          ),
        ),
      ),
    );
  }
}
