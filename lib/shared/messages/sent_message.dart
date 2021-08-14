import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/models/messages_models/sent_message_model.dart';

//ignore: must_be_immutable
class SentMessage extends StatelessWidget {
  final Result message;

  SentMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    // double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0.w,
        vertical: 16.0.h,
      ),
      child: Card(
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(36.0.r),
        ),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 24.0.w,
                  end: 24.0.w,
                  top: 16.0.h,
                  bottom: 0.0.h,
                ),
                child: Text(
                  message.messageBody!,
                  style: TextStyle(
                    fontSize: 16.0.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Gotham_thin',
                    height: 1.3.h,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.0.w,
                  vertical: 16.0.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: '${localizations.sentTo}:  ',
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontFamily: 'Gotham_thin',
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                              TextSpan(
                                text: message.receiverUserName,
                                style: TextStyle(
                                  fontSize: 14.0.sp,
                                  fontFamily: 'Gotham_bold',
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 3.0.h,
                        ),
                        Text(
                          message.date!,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            fontFamily: 'Gotham_thin',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
