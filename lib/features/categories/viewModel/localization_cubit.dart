import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationCubit extends Cubit<String> {
  LocalizationCubit() : super("en");
  void loadLang() async {
    final instance = await SharedPreferences.getInstance();
    final lang = await instance.getString("lang") ?? "en";
    emit(lang);
  }

  void changeLang(String lang) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString("lang", lang);
    emit(lang);
  }
}
