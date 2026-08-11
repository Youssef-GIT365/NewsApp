import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  void startTimer() {
    Future.delayed(const Duration(seconds: 5), () {
      emit(SplashNavigateToHome());
    });
  }
}
