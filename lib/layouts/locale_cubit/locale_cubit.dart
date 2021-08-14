import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serr_app/l10n/l10n.dart';

import 'package:serr_app/layouts/locale_cubit/locale_states.dart';
import 'package:serr_app/shared/network/cache_helper.dart';

class LocaleCubit extends Cubit<LocaleStates> {
  LocaleCubit() : super(LocaleInitialState());

  bool isArabic = false;
  Locale locale = L10n.all[1];

  void setLocale(Locale value) {
    if (value == L10n.all[1]) {
      locale = L10n.all[1];
      CacheHelper.saveData('locale', 'ar').then((value) {
        emit(LocaleSetState());
      });
    } else {
      locale = L10n.all[0];
      CacheHelper.saveData('locale', 'en').then((value) {
        emit(LocaleSetState());
      });
    }

  }
}
