import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/shared/components.dart';
import 'package:serr_app/shared/messages/public_message.dart';

class LandingScreen extends StatefulWidget {
  final String? id;
  final String? name;

  // final String? img;

  LandingScreen({
    required this.id,
    required this.name,
    // required this.img,
  });

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController sentMessageController = TextEditingController();

  late Future _getPublicMessages;

  @override
  void initState() {
    _getPublicMessages = Future.delayed(Duration.zero).then((value) {
      BlocProvider.of<HomeCubit>(context).getPublicMessages(widget.id!);
      BlocProvider.of<HomeCubit>(context).getSearchedUserData(
        searchedId: widget.id!,
        searchedName: widget.name!,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;
    print(widget.id);

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {
        if (state is HomeSendMessageSuccessState) {
          Fluttertoast.showToast(
            msg: state.message,
            fontSize: 16.sp,
          );
        } else if (state is HomeSendMessageFailureState) {
          Fluttertoast.showToast(
            msg: localizations.error,
            fontSize: 16.sp,
            backgroundColor: Theme.of(context).errorColor,
          );
        }
      },
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            cubit.publicMessageModel = null;
            cubit.searchedUserImg = null;
            return true;
          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: profileAppbar(context),
            body: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: deviceHeight * 0.05,
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: deviceHeight * 0.12,
                          backgroundColor: Theme.of(context).canvasColor,
                          backgroundImage: cubit.searchedUserImg == null
                              ? null
                              : NetworkImage(cubit.searchedUserImg!),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.05,
                        ),
                        Text(
                          widget.name!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 26.0.sp,
                            fontFamily: 'Gotham_black',
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: deviceHeight * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 16.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.mail,
                            size: 32.sp,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          SizedBox(
                            width: deviceWidth * 0.02,
                          ),
                          Text(
                            localizations.publicMessages,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontFamily: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .fontFamily,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.01,
                    ),
                    FutureBuilder(
                      future: _getPublicMessages,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (cubit.publicMessageModel == null) {
                          return Padding(
                            padding: EdgeInsetsDirectional.only(top: 24.0.h),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          );
                        } else {
                          if (cubit.publicMessageModel!.result.isEmpty) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: deviceHeight * 0.15,
                                ),
                                Text(
                                  localizations.noPublicMessagesLS,
                                  style: TextStyle(
                                    fontSize: 18.0.sp,
                                    fontFamily: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .fontFamily,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  cubit.publicMessageModel!.result.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  PublicMessage(index, false),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Container(
              height: 60.0.h,
              width: 60.0.w,
              child: FloatingActionButton(
                onPressed: () {
                  if (!cubit.isBsShown) {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => _bottomSheet(
                            deviceHeight,
                            context,
                            cubit,
                            state,
                            localizations,
                          ),
                        )
                        .closed
                        .then(
                          (value) => cubit.setBsState(false),
                        );
                    cubit.setBsState(true);
                  } else {
                    Navigator.pop(context);
                    cubit.setBsState(false);
                  }
                },
                elevation: 4.0.sp,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(
                  cubit.isBsShown ? Icons.clear : Icons.edit,
                  size: 28.0.sp,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _bottomSheet(
    double deviceHeight,
    BuildContext context,
    HomeCubit cubit,
    HomeStates state,
    AppLocalizations localizations,
  ) =>
      Card(
        elevation: 10.0.sp,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
          gapPadding: 0.0.sp,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
            topLeft: Radius.circular(48.0.r),
            topRight: Radius.circular(48.0.r),
          ),
        ),
        child: Container(
          height: deviceHeight * 0.5,
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(48.0.r),
              topStart: Radius.circular(48.0.r),
              bottomEnd: Radius.zero,
              bottomStart: Radius.zero,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: 0.0.h,
              end: 24.0.w,
              start: 24.0.w,
              top: 48.0.h,
            ),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sendingTextField(
                    context,
                    height: deviceHeight * 0.35,
                    hintText: localizations.enterMessageLS,
                    controller: sentMessageController,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return localizations.validatorLS;
                      } else {
                        return null;
                      }
                    },
                    maxLength: 750,
                    maxLines: 15,
                  ),
                  Row(
                    children: [
                      defaultTextButton(
                        context: context,
                        text: localizations.send,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            if (cubit.data.isEmpty) {
                              cubit
                                  .sendMessage(
                                userId: widget.id!,
                                messageBody: sentMessageController.text,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                                cubit.setBsState(false);
                                sentMessageController.clear();
                              });
                            } else if (cubit.data.isNotEmpty) {
                              cubit
                                  .sendMessageAuthed(
                                userId: widget.id!,
                                senderId: cubit.userId,
                                messageBody: sentMessageController.text,
                              )
                                  .then((value) {
                                Navigator.pop(context);
                                cubit.setBsState(false);
                                sentMessageController.clear();
                              });
                            }
                          }
                        },
                      ),
                      Spacer(),
                      if (state is HomeSendMessageLoadingState)
                        CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
