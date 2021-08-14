import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';

import 'package:serr_app/models/messages_models/public_message_model.dart';

//ignore: must_be_immutable
class PublicMessage extends StatelessWidget {
  int index;
  bool showPublicButton;

  PublicMessage(this.index, this.showPublicButton);

  @override
  Widget build(BuildContext context) {
    // double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {},
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of(context, listen: true);
        Result message =
        cubit.publicMessageModel!.result.reversed.toList()[index];
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
                      top: 16.0.h,
                      end: 24.0.w,
                      bottom: 0.0.h,
                    ),
                    child: Text(
                      message.messageBody!,
                      style: TextStyle(
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Gotham_thin',
                        height: 1.4.h,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Row(
                    children: [
                      if (showPublicButton)
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 24.0.w,
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              cubit.setPublic(message.id!).then((value) {
                                message.isPublic = !message.isPublic!;
                              });
                            },
                            color: cubit.public[message.id]!
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardTheme.color,
                            height: 24.0.h,
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100.0.r),
                              borderSide: BorderSide(
                                style: cubit.public[message.id]!
                                    ? BorderStyle.none
                                    : BorderStyle.solid,
                                color: Colors.grey,
                              ),
                            ),
                            elevation: 0.0,
                            highlightElevation: 0.0,
                            child: Text(
                              localizations.showPublic,
                              style: TextStyle(
                                color: cubit.public[message.id]!
                                    ? Colors.white.withOpacity(0.87)
                                    : Colors.grey,
                                fontSize: 13.0.sp,
                                fontFamily: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .fontFamily,
                              ),
                            ),
                          ),
                        ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.0.w,
                          vertical: 16.0.h,
                        ),
                        child: Text(
                          message.date!,
                          style: TextStyle(
                            fontSize: 12.0.sp,
                            fontFamily: 'Gotham_thin',
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
