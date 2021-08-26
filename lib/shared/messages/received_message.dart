import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/layouts/theme_cubit/theme_cubit.dart';
import 'package:serr_app/models/messages_models/message_model.dart';
import 'package:serr_app/shared/components.dart';

//ignore: must_be_immutable
class ReceivedMessage extends StatelessWidget {
  int index;

  ReceivedMessage(this.index);

  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {
        if (state is HomeSetFavFailureState) {
          showToast(
            context,
            msg: localizations.setFavError,
            error: true,
          );
        }
        if (state is HomeDeleteMessageFailureState) {
          showToast(
            context,
            msg: localizations.deleteMessageError,
            error: true,
          );
        }
        if (state is HomeCommentFailureState) {
          showToast(
            context,
            msg: localizations.commentError,
            error: true,
          );
        }
      },
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context, listen: true);
        Result message = cubit.messageModel!.result.reversed.toList()[index];
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
            child: Column(
              children: [
                if (message.comment!.isNotEmpty)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: BlocProvider.of<ThemeCubit>(context, listen: true)
                                  .themeMode ==
                              ThemeMode.dark
                          ? Colors.grey.shade600
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(36.0.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              start: 24.0.w,
                              end: 0.0.w,
                              top: 16.0.h,
                              bottom: 16.0.h,
                            ),
                            child: Text(
                              message.comment!,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                fontFamily: 'Gotham_thin',
                                fontWeight: FontWeight.bold,
                                height: 1.3.h,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            top: 4.0.h,
                          ),
                          child: PopupMenuButton(
                            offset: Offset(0, -4.0.h),
                            color: Theme.of(context).primaryColor,
                            elevation: 0.0,
                            shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                style: BorderStyle.none,
                              ),
                              borderRadius: BorderRadius.circular(36.0.r),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 0,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 24.0.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: deviceWidth * 0.03),
                                    Text(
                                      localizations.editComment,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 24.0.sp,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: deviceWidth * 0.03),
                                    Text(
                                      localizations.deleteComment,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (int index) {
                              if (index == 0) {
                                editComment(
                                  context,
                                  deviceHeight: deviceHeight,
                                  commentController: _commentController,
                                  localizations: localizations,
                                  message: message,
                                  cubit: cubit,
                                );
                              }
                              if (index == 1) {
                                makingSureDialog(
                                  context,
                                  text: localizations.deleteCheck2,
                                  localizations: localizations,
                                  deviceHeight: deviceHeight,
                                  onYes: () {
                                    cubit.comment(
                                      context,
                                      messageId: message.id!,
                                      commentBody: '',
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: BlocProvider.of<ThemeCubit>(context, listen: true)
                                .themeMode ==
                            ThemeMode.light
                        ? Colors.white
                        : Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(36.0.r),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          start: 24.0.w,
                          top: 16.0.h,
                          end: 24.0.w,
                          bottom: 16.0.h,
                        ),
                        child: Text(
                          message.messageBody!,
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontFamily: 'Gotham_thin',
                            fontWeight: FontWeight.bold,
                            height: 1.3.h,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MessageFeature(
                            icon: Icons.favorite,
                            text: localizations.favourite,
                            color: cubit.favourites[message.id]!
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            onTap: () {
                              cubit.setFav(message.id!);
                            },
                          ),
                          MessageFeature(
                            icon: Icons.delete,
                            text: localizations.delete,
                            onTap: () {
                              makingSureDialog(
                                context,
                                text: localizations.deleteCheck,
                                localizations: localizations,
                                deviceHeight: deviceHeight,
                                onYes: () {
                                  cubit.deleteMessage(
                                    context,
                                    message.id!,
                                  );
                                },
                              );
                            },
                          ),
                          MessageFeature(
                            icon: Icons.share_outlined,
                            text: localizations.share,
                            onTap: () async {
                              await Share.share(
                                '${message.messageBody!}  ' +
                                    'https://play.google.com/store/apps/details?id=com.azem.sserr',
                              );
                            },
                          ),
                          MessageFeature(
                            icon: Icons.reply_outlined,
                            text: localizations.comment,
                            onTap: () {
                              editComment(
                                context,
                                deviceHeight: deviceHeight,
                                commentController: _commentController,
                                localizations: localizations,
                                message: message,
                                cubit: cubit,
                              );
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                        child: Row(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                cubit.setPublic(message.id!);
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
                                  height: 1.5.h,
                                ),
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${message.date}',
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                fontFamily: 'Gotham_thin',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//ignore: must_be_immutable
class MessageFeature extends StatelessWidget {
  IconData icon;
  Color color;
  String text;
  Function() onTap;

  MessageFeature({
    required this.icon,
    required this.text,
    required this.onTap,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.0.w),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 20.0.sp,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 10.0.sp,
                fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
