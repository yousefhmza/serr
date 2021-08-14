import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:serr_app/l10n/l10n.dart';
import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_layout.dart';
import 'package:serr_app/layouts/locale_cubit/locale_cubit.dart';
import 'package:serr_app/layouts/theme_cubit/theme_cubit.dart';
import 'package:serr_app/main.dart';
import 'package:serr_app/models/local_models.dart';
import 'package:serr_app/modules/auth/cubit/auth_cubit.dart';
import 'package:serr_app/modules/auth/cubit/auth_states.dart';
import 'package:serr_app/modules/contact_us_screen.dart';
import 'package:serr_app/modules/profile_screen.dart';
import 'package:serr_app/shared/components.dart';

class MoreScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    //double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;
    List<MoreFeature> features = [
      MoreFeature(
        title: localizations.mfProfile,
        icon: Icons.person_outline_outlined,
        function: () {
          if (BlocProvider.of<AuthCubit>(context).isLogin) {
            Navigator.push(
              context,
              PageTransition(
                child: ProfileScreen(),
                type: PageTransitionType.fade,
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) => defaultAlertDialog(
                context,
                content: Text(
                  localizations.noProfile,
                  style: TextStyle(
                    height: 1.3.h,
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                        Theme.of(context).textTheme.bodyText2!.fontFamily,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
      ),
      MoreFeature(
          title: localizations.mfLanguage,
          icon: Icons.language_outlined,
          function: () {
            showDialog(
              context: context,
              builder: (context) => defaultAlertDialog(
                context,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      value: L10n.all[0],
                      groupValue:
                          BlocProvider.of<LocaleCubit>(context, listen: true)
                              .locale,
                      onChanged: (Locale? value) {
                        BlocProvider.of<LocaleCubit>(context).setLocale(value!);
                      },
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(
                        'English',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    RadioListTile(
                      value: L10n.all[1],
                      groupValue:
                          BlocProvider.of<LocaleCubit>(context, listen: true)
                              .locale,
                      onChanged: (Locale? value) {
                        BlocProvider.of<LocaleCubit>(context).setLocale(value!);
                      },
                      activeColor: Theme.of(context).primaryColor,
                      title: Text(
                        'العربية',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      MoreFeature(
        title: localizations.mfDarkTheme,
        icon: Icons.brightness_4_outlined,
        trailing: Switch(
          value: BlocProvider.of<ThemeCubit>(context, listen: true).isDark,
          onChanged: (value) {
            BlocProvider.of<ThemeCubit>(context).setAppTheme(value);
          },
          activeColor: Theme.of(context).primaryColor,
        ),
      ),
      MoreFeature(
        title: localizations.mfRateTheApp,
        icon: Icons.star_rate_outlined,
        function: () async {
          await canLaunch(
                  'https://play.google.com/store/apps/details?id=com.azem.sserr')
              ? await launch(
                  'https://play.google.com/store/apps/details?id=com.azem.sserr',
                  enableJavaScript: true,
                  forceWebView: false,
                )
              : errorToast(
                  context,
                  'error on launching https://play.google.com/store/apps/details?id=com.azem.sserr',
                );
        },
      ),
      MoreFeature(
        title: localizations.mfShareTheApp,
        icon: Icons.share_outlined,
        function: () async {
          await Share.share(
            'https://play.google.com/store/apps/details?id=com.azem.sserr',
          );
        },
      ),
      MoreFeature(
        title: localizations.mfContactUs,
        icon: Icons.mail_outline_outlined,
        function: () {
          Navigator.push(
            context,
            PageTransition(
              child: ContactUsScreen(),
              type: PageTransitionType.fade,
            ),
          );
        },
      ),
      MoreFeature(
        title: localizations.mfPrivacyPolicy,
        icon: Icons.privacy_tip_outlined,
        function: () async {
          await canLaunch('https://serr.flycricket.io/privacy.html')
              ? await launch(
                  'https://serr.flycricket.io/privacy.html',
                  enableJavaScript: true,
                  forceWebView: true,
                )
              : errorToast(
                  context,
                  'error on launching https://serr.flycricket.io/privacy.html',
                );
        },
      ),
      MoreFeature(
        title: localizations.mfLogOut,
        icon: Icons.logout_outlined,
        function: () {
          if (BlocProvider.of<AuthCubit>(context).isLogin) {
            showDialog(
              context: context,
              builder: (context) => defaultAlertDialog(
                context,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    Text(
                      localizations.logoutCheck,
                      style: TextStyle(
                        fontFamily:
                            Theme.of(context).textTheme.bodyText1!.fontFamily,
                        fontSize: 18.0.sp,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        defaultTextButton(
                          context: context,
                          text: localizations.yes,
                          onPressed: () {
                            BlocProvider.of<AuthCubit>(context).logout();

                            // to make sure that the messages of the previous user
                            // don't appear to the next one if they logged in with
                            // different accounts in the same app lifecycle
                            BlocProvider.of<HomeCubit>(context).messageModel =
                                null;
                            BlocProvider.of<HomeCubit>(context)
                                .sentMessageModel = null;
                            BlocProvider.of<HomeCubit>(context)
                                .favMessageModel = null;

                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: MyApp(HomeLayout()),
                                type: PageTransitionType.fade,
                              ),
                            );
                          },
                        ),
                        defaultTextButton(
                          context: context,
                          text: localizations.no,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: localizations.notRegistered,
            );
          }
        },
      ),
    ];

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (BuildContext context, AuthStates state) {
        if (state is AuthLogoutFailureState) {
          Fluttertoast.showToast(
            msg: localizations.error,
          );
        }
      },
      builder: (BuildContext context, AuthStates state) {
        //AuthCubit cubit = BlocProvider.of<AuthCubit>(context);
        return Scaffold(
          appBar: appBar(
            context,
            text: localizations.title3,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (!BlocProvider.of<AuthCubit>(context, listen: true).isLogin)
                  authAlert(
                    context,
                    localizations.noFeatures,
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0.h),
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 0.0.h),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) =>
                        featureItem(
                      context,
                      features[index],
                    ),
                    itemCount: features.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsetsDirectional.only(end: 16.0.w),
                        child: Divider(color: Theme.of(context).dividerColor),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget featureItem(
    BuildContext context,
    MoreFeature feature,
  ) =>
      ListTile(
        onTap: feature.function,
        title: Text(
          feature.title,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 16.0.sp,
            color: Theme.of(context).textTheme.bodyText2!.color,
          ),
        ),
        leading: Icon(
          feature.icon,
          size: 26.0.sp,
          color: Theme.of(context).iconTheme.color,
        ),
        trailing: feature.trailing,
      );
}
