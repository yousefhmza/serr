import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/shared/components.dart';

void _launchUrl(BuildContext context, String url) async {
  await canLaunch(url)
      ? await launch(
          url,
          enableJavaScript: true,
          forceWebView: false,
        )
      : showToast(
          context,
          msg: 'error on launching $url',
          error: true,
        );
}

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppbar(context),
      body: ContactScreen(),
    );
  }
}

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0.w,
          vertical: 16.0.h,
        ),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                localizations.contactUs,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.03),
            Text(
              localizations.feedback,
              style: TextStyle(
                fontSize: 18.sp,
                height: 1.3.h,
                fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
              ),
            ),
            SizedBox(height: deviceHeight * 0.07),
            contactItem(
              context,
              icon: 'assets/images/facebook.png',
              text: localizations.facebook,
              onTap: () {
                _launchUrl(
                  context,
                  'https://www.facebook.com/serr.secret',
                );
              },
              deviceHeight: deviceHeight,
              deviceWidth: deviceWidth,
            ),
            SizedBox(height: deviceHeight * 0.03),
            contactItem(
              context,
              icon: 'assets/images/instagram.png',
              text: localizations.insta,
              onTap: () {
                _launchUrl(
                  context,
                  'https://www.instagram.com/serr_app/',
                );
              },
              deviceHeight: deviceHeight,
              deviceWidth: deviceWidth,
            ),
            SizedBox(height: deviceHeight * 0.03),
            contactItem(
              context,
              icon: 'assets/images/gmail.png',
              text: localizations.gmail,
              onTap: () {
                _launchUrl(
                  context,
                  'mailto:serr.app.azem@gmail.com?subject=Feedback',
                );
              },
              deviceHeight: deviceHeight,
              deviceWidth: deviceWidth,
            ),
          ],
        ),
      ),
    );
  }
}

Widget contactItem(
  BuildContext context, {
  required String icon,
  required String text,
  required Function() onTap,
  required double deviceHeight,
  required double deviceWidth,
}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0.h),
        child: Row(
          children: [
            Image(
              height: deviceHeight * 0.04,
              image: AssetImage(icon),
            ),
            SizedBox(width: deviceWidth * 0.03),
            Text(
              text,
              style: TextStyle(
                fontSize: 18.sp,
                height: 1.3.h,
                fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
