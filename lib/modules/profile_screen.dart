import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/shared/components.dart';
import 'package:serr_app/shared/messages/public_message.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameEditController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  late Future _getPublicMessages;

  @override
  void initState() {
    if (BlocProvider.of<HomeCubit>(context).messageModel == null) {
      BlocProvider.of<HomeCubit>(context).getMessages();
    }
    _getPublicMessages = Future.delayed(Duration.zero).then((value) {
      BlocProvider.of<HomeCubit>(context)
          .getPublicMessages(BlocProvider.of<HomeCubit>(context).userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {
        if (state is HomeUpdateDataSuccessState) {
          Fluttertoast.showToast(msg: state.message);
        }
        if (state is HomeUpdateDataFailureState) {
          errorToast(context, localizations.error);
        }
      },
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        return WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            cubit.publicMessageModel = null;
            return true;
          },
          child: Scaffold(
            appBar: profileAppbar(context),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: deviceHeight * 0.05),
                  CircleAvatar(
                    radius: deviceHeight * 0.12,
                    backgroundColor: Theme.of(context).canvasColor,
                    backgroundImage: NetworkImage(cubit.img),
                  ),
                  SizedBox(height: deviceHeight * 0.05),
                  Text(
                    cubit.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontFamily: 'Gotham_black',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: deviceHeight * 0.02),
                  Text(
                    cubit.username,
                    style: TextStyle(
                      fontSize: 16.0.sp,
                      fontFamily: 'Arabic',
                      color: Theme.of(context).textTheme.bodyText1!.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(
                          text:
                              'https://serr.netlify/#/u/${cubit.name}/${cubit.userId}',
                        ),
                      ).then(
                        (value) {
                          Fluttertoast.showToast(
                            msg: 'Copied to clipboard',
                          );
                        },
                      );
                    },
                    child: Text(
                      'https://serr.netlify/#/u/${cubit.name}/${cubit.userId}',
                      style: TextStyle(
                        fontFamily: 'Gotham_thin',
                        fontWeight: FontWeight.bold,
                        height: 1.3.h,
                        letterSpacing: 1.0.w,
                        fontSize: 14.0.sp,
                        color: Theme.of(context).textTheme.bodyText2!.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.0.w),
                    child: Divider(color: Theme.of(context).dividerColor),
                  ),
                  profileFeature(
                    context,
                    text: localizations.editName,
                    icon: Icons.edit,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => defaultAlertDialog(
                          context,
                          content: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextField(
                                  context,
                                  controller: nameEditController,
                                  hintText: localizations.newName,
                                  deviceHeight: deviceHeight,
                                  prefixIcon: Icons.edit,
                                  keyBoardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return localizations.validatorU;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(height: deviceHeight * 0.01),
                                if (state is HomeUpdateDataLoadingState)
                                  CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    defaultTextButton(
                                      context: context,
                                      text: localizations.ok,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.updateUserData(
                                            newName: nameEditController.text,
                                          );
                                          Navigator.pop(context);
                                          nameEditController.clear();
                                        }
                                      },
                                    ),
                                    defaultTextButton(
                                      context: context,
                                      text: localizations.skip,
                                      onPressed: () {
                                        Navigator.pop(context);
                                        nameEditController.clear();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  profileFeature(
                    context,
                    text: localizations.editProfilePic,
                    icon: Icons.person,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => defaultAlertDialog(
                          context,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: deviceHeight * 0.06,
                                backgroundImage: BlocProvider.of<HomeCubit>(
                                          context,
                                          listen: true,
                                        ).selectedImage ==
                                        null
                                    ? NetworkImage(
                                        BlocProvider.of<HomeCubit>(
                                          context,
                                          listen: true,
                                        ).img,
                                      )
                                    : FileImage(
                                        BlocProvider.of<HomeCubit>(
                                          context,
                                          listen: true,
                                        ).selectedImage!,
                                      ) as ImageProvider,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              SizedBox(height: deviceHeight * 0.02),
                              if (state is HomeUpdateDataLoadingState)
                                CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  defaultIconButton(
                                    onPressed: () {
                                      cubit.pickImage(ImageSource.camera);
                                    },
                                    icon: Icons.camera_alt_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  defaultIconButton(
                                    onPressed: () {
                                      cubit.pickImage(ImageSource.gallery);
                                    },
                                    icon: Icons.image_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  defaultIconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icons.cancel_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ],
                              ),
                              defaultTextButton(
                                context: context,
                                text: localizations.upload,
                                onPressed: () {
                                  if (cubit.selectedImage != null) {
                                    print('dddddddddddddone');
                                    cubit.updateUserData(
                                      newName: cubit.name,
                                      image: cubit.selectedImage,
                                    );
                                  }
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.0.w),
                    child: Divider(color: Theme.of(context).dividerColor),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.only(top: 16.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mail,
                          color: Theme.of(context).iconTheme.color,
                          size: 24.0.sp,
                        ),
                        SizedBox(width: deviceWidth * 0.03),
                        Text(
                          localizations.publicMessages.toUpperCase(),
                          style: TextStyle(
                            fontSize: 16.0.sp,
                            fontFamily: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .fontFamily,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        )
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: _getPublicMessages,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (cubit.publicMessageModel == null) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(top: 24.0.h),
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
                                height: deviceHeight * 0.05,
                              ),
                              Text(
                                localizations.noPublicMessages,
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
                            itemCount: cubit.publicMessageModel!.result.length,
                            itemBuilder: (BuildContext context, int index) =>
                                PublicMessage(index, true),
                          );
                        }
                      }
                    },
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
