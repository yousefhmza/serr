import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:serr_app/modules/landing_screen.dart';
import 'package:uni_links/uni_links.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';

bool _initUrlLaunched = false;

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  StreamSubscription? _sub;

  AsyncMemoizer _linkMemoizer = AsyncMemoizer();

  Future<Future> _runInitialLinkOnce() async {
    return this._linkMemoizer.runOnce(() async {
      await _handleInitialLinks();
      // _handleIncomingLinks();
    });
  }

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _runInitialLinkOnce();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() async {
    print('hello');
    if (!kIsWeb) {
      _sub = uriLinkStream.listen(
        (Uri? uri) {
          if (!mounted) return;
          print('got uri: $uri');

          String url = uri.toString();
          print(url);
          List<String> urlSegments = url.split('/');
          print(urlSegments);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LandingScreen(
                id: urlSegments[5],
              ),
            ),
          );
        },
        onError: (Object? err) {
          if (!mounted) return;
          print('got err: $err');
        },
      );
    }
  }

//for app links
  Future<void> _handleInitialLinks() async {
    if (_initUrlLaunched) return;
    _initUrlLaunched = true;
    print('haha');
    try {
      var uri = await getInitialUri();
      if (uri == null) {
        print('no initial uri');
      } else {
        print('got initial uri: $uri');

        String url = uri.toString();
        print(url);
        List<String> urlSegments = url.split('/');
        print(urlSegments);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LandingScreen(
              id: urlSegments[5],
            ),
          ),
        );
      }
    } on PlatformException {
      print('failed to get initial uri');
    } on FormatException catch (e) {
      if (!mounted) return;
      print('malformed initial uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {},
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        AppLocalizations localizations = AppLocalizations.of(context)!;
        return Scaffold(
          body: cubit.basicScreens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.setBNBIndex(index);
            },
            iconSize: 24.0.sp,
            selectedFontSize: 14.0.sp,
            unselectedFontSize: 12.0.sp,
            items: [
              BottomNavigationBarItem(
                label: localizations.bottomTap1,
                icon: Icon(Icons.access_time_outlined),
              ),
              BottomNavigationBarItem(
                label: localizations.bottomTap2,
                icon: Icon(Icons.message_outlined),
              ),
              BottomNavigationBarItem(
                label: localizations.bottomTap3,
                icon: Icon(Icons.more_horiz_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
