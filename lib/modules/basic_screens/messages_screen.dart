import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/shared/components.dart';

final PageStorageBucket tabsBucket = PageStorageBucket();

class MessagesScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    //double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    List<String> list = ['one', 'two', 'three'];
    String string = list.join('%20');
    print(string);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {},
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        AppLocalizations localizations = AppLocalizations.of(context)!;
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) => [
                sliverAppBar(
                  context,
                  text: localizations.title2,
                  bottom: TabBar(
                    tabs: [
                      tabBarItem(
                        context,
                        text: localizations.topTap1,
                        icon: Icons.message_outlined,
                        space: deviceWidth * 0.02,
                      ),
                      tabBarItem(
                        context,
                        text: localizations.topTap2,
                        icon: Icons.favorite_outlined,
                        space: deviceWidth * 0.02,
                      ),
                      tabBarItem(
                        context,
                        text: localizations.topTap3,
                        icon: Icons.send_outlined,
                        space: deviceWidth * 0.02,
                      ),
                    ],
                  ),
                ),
              ],
              body: PageStorage(
                bucket: tabsBucket,
                child: TabBarView(
                  children: cubit.tabsScreens,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget tabBarItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required double space,
  }) =>
      Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.0.sp,
            ),
            SizedBox(
              width: space,
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
                fontSize: 12.0.sp,
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      );
}
