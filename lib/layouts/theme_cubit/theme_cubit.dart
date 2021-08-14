import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:serr_app/layouts/theme_cubit/theme_states.dart';
import 'package:serr_app/shared/network/cache_helper.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeInitialState());

  bool isDark = false;
  ThemeMode themeMode = ThemeMode.light;

  void setAppTheme(bool value) {
    isDark = value;
    if (isDark == false) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.dark;
    }
    CacheHelper.saveData('isDark', isDark).then((value) {
      emit(ThemeSetterState());
    });
  }
}
