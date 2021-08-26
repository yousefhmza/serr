import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:serr_app/layouts/ads_cubit/ads_cubit.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/modules/landing_screen.dart';
import 'package:serr_app/shared/components.dart';

//ignore: must_be_immutable
class RecentScreen extends StatefulWidget {
  @override
  _RecentScreenState createState() => _RecentScreenState();
}

class _RecentScreenState extends State<RecentScreen> {
  TextEditingController searchController = TextEditingController();
  // late Future _loadAd;
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   final adCubit = BlocProvider.of<AdCubit>(context);
  //   _loadAd = adCubit.loadAd();
  // }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    //double deviceWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {},
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        AppLocalizations localizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: appBar(
            context,
            text: localizations.title1,
          ),
          body: Column(
            children: [
              // the searched profiles
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0.w,
                        vertical: 16.0.h,
                      ),
                      child: defaultTextField(
                        context,
                        deviceHeight: deviceHeight,
                        controller: searchController,
                        validator: (value) {
                          return null;
                        },
                        hintText: localizations.searchText,
                        textInputAction: TextInputAction.search,
                        prefixIcon: Icons.search,
                        keyBoardType: TextInputType.text,
                        onFieldSubmitted: (value) {
                          cubit.getSearch(value.trim());
                        },
                      ),
                    ),
                    if (state is HomeSearchLoadingState)
                      Padding(
                        padding: EdgeInsetsDirectional.only(top: 16.0.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    if (state is HomeSearchSuccessState)
                      Expanded(
                        child: ListView.separated(
                          itemCount: cubit.searchModel!.result.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) =>
                              searchItem(context, index, cubit),
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsetsDirectional.only(end: 16.0.w),
                              child: Divider(
                                  color: Theme.of(context).dividerColor),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              //the Ad
              // if (BlocProvider.of<AdCubit>(context, listen: true).bannerAd ==
              //     null)
              //   SizedBox(
              //     height: deviceHeight * 0.08,
              //   )
              // else
              //   FutureBuilder(
              //     future: _loadAd,
              //     builder: (context, snapshot) {
              //       return Container(
              //         height: deviceHeight * 0.08,
              //         child: AdWidget(
              //           ad: BlocProvider.of<AdCubit>(context, listen: true)
              //               .bannerAd!,
              //         ),
              //       );
              //     },
              //   ),
            ],
          ),
        );
      },
    );
  }

  Widget searchItem(
    BuildContext context,
    int index,
    HomeCubit cubit,
  ) =>
      ListTile(
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
              child: LandingScreen(
                id: cubit.searchModel!.result[index].id!,
                //name: cubit.searchModel!.result[index].name!,
              ),
              type: PageTransitionType.fade,
            ),
          );
        },
        leading: CircleAvatar(
          radius: 36.0.r,
          backgroundColor: Theme.of(context).canvasColor,
          backgroundImage: NetworkImage(cubit.searchModel!.result[index].img!),
        ),
        title: Text(
          cubit.searchModel!.result[index].name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.0.sp,
            fontFamily: 'Gotham_bold',
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        subtitle: Text(
          cubit.searchModel!.result[index].username!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12.0.sp,
            fontFamily: 'Gotham_thin',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
      );
}
