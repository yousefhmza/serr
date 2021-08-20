import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/l10n/l10n.dart';
import 'package:serr_app/layouts/ads/ads_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_layout.dart';
import 'package:serr_app/layouts/locale_cubit/locale_cubit.dart';
import 'package:serr_app/layouts/theme_cubit/theme_cubit.dart';
import 'package:serr_app/modules/auth/auth_screen.dart';
import 'package:serr_app/modules/auth/cubit/auth_cubit.dart';
import 'package:serr_app/modules/on_boarding_screen.dart';
import 'package:serr_app/shared/bloc_observer.dart';
import 'package:serr_app/shared/network/cache_helper.dart';
import 'package:serr_app/shared/network/database_helper.dart';
import 'package:serr_app/shared/network/dio_helper.dart';
import 'package:serr_app/shared/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  await CacheHelper.init();
  bool onBoardingSeen = await CacheHelper.getData('onBoardingSeen') ?? false;
  bool isAuthScreenSeen =
      await CacheHelper.getData('isAuthScreenSeen') ?? false;
  bool isDark = await CacheHelper.getData('isDark') ?? false;
  String locale = await CacheHelper.getData('locale') ?? 'ar';

  DatabaseHelper.instance.database;

  Widget startScreen;
  if (onBoardingSeen) {
    if (isAuthScreenSeen) {
      startScreen = HomeLayout();
    } else {
      startScreen = AuthScreen();
    }
  } else {
    startScreen = OnBoardingScreen();
  }

  final Future<InitializationStatus> initAd = MobileAds.instance.initialize();
  final AdCubit adState = AdCubit(initAd);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => HomeCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => AuthCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ThemeCubit()..setAppTheme(isDark),
        ),
        BlocProvider(
          create: (BuildContext context) => LocaleCubit()
            ..setLocale(
              locale == 'en' ? L10n.all[0] : L10n.all[1],
            ),
        ),
        BlocProvider.value(
          value: adState,
        ),
      ],
      child: MyApp(startScreen),
    ),
  );
}

//ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final Widget startScreen;

  MyApp(this.startScreen);

  AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<Future> _fetchUserData(BuildContext context) async {
    return this._memoizer.runOnce(() async {
      await BlocProvider.of<HomeCubit>(context).getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393.0, 760.0),
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: BlocProvider.of<ThemeCubit>(context, listen: true).themeMode,
        theme: lightTheme(context),
        darkTheme: darkTheme(context),
        locale: BlocProvider.of<LocaleCubit>(context, listen: true).locale,
        supportedLocales: L10n.all,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: FutureBuilder(
          future: _fetchUserData(context),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              return AnimatedSplashScreen(
                splash: Image(
                  image: AssetImage('assets/images/Serr icon.png'),
                ),
                duration: 1500,
                backgroundColor: Theme.of(context).canvasColor,
                pageTransitionType: PageTransitionType.fade,
                splashTransition: SplashTransition.fadeTransition,
                nextScreen: startScreen,
              );
            }
          },
        ),
      ),
    );
  }
}
