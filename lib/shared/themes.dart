import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:serr_app/l10n/l10n.dart';
import 'package:serr_app/layouts/locale_cubit/locale_cubit.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      titleSpacing: 8.0.w,
      color: Color(0xffE65252),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      titleTextStyle: TextStyle(
        fontSize: 22.0.sp,
        fontFamily: BlocProvider.of<LocaleCubit>(context).locale == L10n.all[0]
            ? 'Gotham_bold'
            : 'Arabic',
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardTheme(
      color: Colors.white,
      shadowColor: Colors.black38,
      elevation: 6.0.sp,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(48.0.r),
      ),
    ),

    indicatorColor: Color(0xffFFFAF7),
    tabBarTheme: TabBarTheme(
      labelColor: Color(0xffFFFAF7),
      unselectedLabelColor: Color(0xffFFFAF7).withOpacity(0.6),
    ),

    textTheme: ThemeData.dark().textTheme.copyWith(
      bodyText1: TextStyle(
        color: Colors.black87,
        fontFamily:
        BlocProvider.of<LocaleCubit>(context).locale == L10n.all[0]
            ? 'Gotham_bold'
            : 'Arabic',
      ),
      bodyText2: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontFamily:
        BlocProvider.of<LocaleCubit>(context).locale == L10n.all[0]
            ? 'Gotham_thin'
            : 'Arabic',
      ),
    ),

    iconTheme: ThemeData.dark().iconTheme.copyWith(
      color: Colors.black.withOpacity(0.7),
    ),

    dividerColor: Colors.black38,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0.0,
      backgroundColor: Color(0xffFFFAF7),
      selectedItemColor: Color(0xffE65252),
      unselectedItemColor: Colors.black45,
      type: BottomNavigationBarType.fixed,
    ),

    //  bottomSheetTheme: BottomSheetThemeData(),
    primaryColor: Color(0xffE65252),
    canvasColor: Color(0xffFFFAF7),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      titleSpacing: 8.0.w,
      color: Color(0xff292929),
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      titleTextStyle: TextStyle(
        fontSize: 22.0.sp,
        fontFamily: BlocProvider.of<LocaleCubit>(context).locale == L10n.all[0]
            ? 'Gotham_bold'
            : 'Arabic',
        color: Colors.white.withOpacity(0.87),
      ),
    ),

    cardTheme: CardTheme(
      color: Color(0xff292929),
      shadowColor: Colors.black38,
      elevation: 6.0.sp,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(48.0.r),
      ),
    ),

    indicatorColor: Color(0xffCF6679),
    tabBarTheme: TabBarTheme(
      labelColor: Color(0xffCF6679),
      unselectedLabelColor: Color(0xffCF6679).withOpacity(0.4),
    ),

    textTheme: ThemeData.dark().textTheme.copyWith(
      bodyText1: TextStyle(
        color: Colors.white.withOpacity(0.87),
        fontFamily:
        BlocProvider.of<LocaleCubit>(context).locale == L10n.all[0]
            ? 'Gotham_bold'
            : 'Arabic',
      ),
      bodyText2: TextStyle(
        color: Colors.white.withOpacity(0.87),
        fontWeight: FontWeight.bold,
        fontFamily:
        BlocProvider.of<LocaleCubit>(context).locale == L10n.all[0]
            ? 'Gotham_thin'
            : 'Arabic',
      ),
    ),

    iconTheme: ThemeData.dark().iconTheme.copyWith(
      color: Colors.white.withOpacity(0.87),
    ),

    dividerColor: Colors.white38,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0.0,
      backgroundColor: Color(0xff121212),
      selectedItemColor: Color(0xffCF6679),
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
    ),

    //  bottomSheetTheme: BottomSheetThemeData(),
    primaryColor: Color(0xffCF6679),
    canvasColor: Color(0xff121212),
  );
}
