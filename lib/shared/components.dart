import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/theme_cubit/theme_cubit.dart';
import 'package:serr_app/modules/auth/auth_screen.dart';

PreferredSize appBar(
  BuildContext context, {
  required String text,
}) {
  double deviceHeight = MediaQuery.of(context).size.height;
  double deviceWidth = MediaQuery.of(context).size.width;
  HomeCubit cubit = BlocProvider.of<HomeCubit>(context, listen: true);
  return PreferredSize(
    preferredSize: Size.fromHeight(deviceHeight * 0.074),
    child: AppBar(
      title: Row(
        children: [
          CircleAvatar(
            radius: deviceHeight * 0.031,
            backgroundColor: Theme.of(context).canvasColor,
            backgroundImage: NetworkImage(
              cubit.data.isNotEmpty
                  ? 'https://i.pinimg.com/originals/34/8a/6f/348a6f9ca65d76e43f2bc8df61c831e6.jpg'
                  : 'https://media.npr.org/assets/img/2020/05/05/gettyimages-693140990_custom-96572767b03e0e649349fdb6d38d649e6ccaed75.jpg',
            ),
          ),
          SizedBox(
            width: deviceWidth * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4.0.h),
            child: Text(text),
          ),
        ],
      ),
    ),
  );
}

SliverAppBar sliverAppBar(
  BuildContext context, {
  required String text,
  PreferredSizeWidget? bottom,
}) {
  double deviceHeight = MediaQuery.of(context).size.height;
  double deviceWidth = MediaQuery.of(context).size.width;
  HomeCubit cubit = BlocProvider.of<HomeCubit>(context, listen: true);
  return SliverAppBar(
    expandedHeight: deviceHeight * 0.138,
    pinned: true,
    floating: true,
    title: Row(
      children: [
        CircleAvatar(
          radius: deviceHeight * 0.031,
          backgroundColor: Theme.of(context).canvasColor,
          backgroundImage: NetworkImage(
            cubit.data.isNotEmpty
                ? 'https://i.pinimg.com/originals/34/8a/6f/348a6f9ca65d76e43f2bc8df61c831e6.jpg'
                : 'https://media.npr.org/assets/img/2020/05/05/gettyimages-693140990_custom-96572767b03e0e649349fdb6d38d649e6ccaed75.jpg',
          ),
        ),
        SizedBox(
          width: deviceWidth * 0.02,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 4.0.h),
          child: Text(text),
        ),
      ],
    ),
    bottom: bottom,
  );
}

PreferredSize profileAppbar(BuildContext context) {
  double deviceHeight = MediaQuery.of(context).size.height;
  //double deviceWidth = MediaQuery.of(context).size.width;
  ThemeCubit cubit = BlocProvider.of<ThemeCubit>(context);
  return PreferredSize(
    preferredSize: Size.fromHeight(deviceHeight * 0.074),
    child: AppBar(
      backgroundColor: Colors.transparent,
      backwardsCompatibility: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: cubit.themeMode == ThemeMode.light
            ? Brightness.dark
            : Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      leading: IconButton(
        color: Theme.of(context).iconTheme.color,
        onPressed: () {
          Navigator.pop(context);
          BlocProvider.of<HomeCubit>(context).publicMessageModel = null;
          BlocProvider.of<HomeCubit>(context).searchedUserImg = null;
        },
        icon: Icon(
          Icons.arrow_back_outlined,
          size: 26.0.sp,
        ),
      ),
    ),
  );
}

Widget defaultTextButton({
  required BuildContext context,
  required String text,
  required Function() onPressed,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.0.sp,
          color: Theme.of(context).primaryColor,
          fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
        ),
      ),
    );

Widget defaultIconButton({
  required Function() onPressed,
  required IconData icon,
  required Color color,
}) =>
    IconButton(
      onPressed: onPressed,
      iconSize: 28.0.sp,
      color: color,
      icon: Icon(icon),
    );

Widget profileFeature(
  BuildContext context, {
  required String text,
  required IconData icon,
  Function()? onTap,
}) =>
    ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 24.0.sp,
        color: Theme.of(context).iconTheme.color,
        //size: 28.0,
      ),
      title: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 16.0.sp,
          fontWeight: FontWeight.bold,
          fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
    );

Widget defaultTextField(
  BuildContext context, {
  required double deviceHeight,
  required TextEditingController controller,
  required String? Function(String?) validator,
  required String hintText,
  TextInputAction? textInputAction,
  IconData? suffixIcon,
  IconData? prefixIcon,
  Function(String)? onFieldSubmitted,
  Function()? suffixPressed,
  bool obscureText = false,
  TextInputType? keyBoardType,
}) =>
    Container(
      height: deviceHeight * 0.07,
      child: Card(
        elevation: 2.0.sp,
        shadowColor: Colors.black54,
        shape: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.none,
          ),
          borderRadius: BorderRadius.circular(36.0.r),
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyBoardType,
          textCapitalization: TextCapitalization.sentences,
          validator: validator,
          cursorColor: Theme.of(context).primaryColor,
          style: TextStyle(
            fontFamily: 'Gotham_thin',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
          maxLines: 1,
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.circular(36.0.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(100.0.r),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.2),
            hintText: hintText,
            hintStyle: TextStyle(
              height: 1.2.h,
              fontSize: 16.0.sp,
              fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .color!
                  .withOpacity(0.5),
            ),
            suffixIcon: IconButton(
              color: Theme.of(context).primaryColor,
              iconSize: 24.0.sp,
              onPressed: suffixPressed,
              icon: Icon(suffixIcon),
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 24.0.sp,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );

Widget sendingTextField(
  BuildContext context, {
  required double height,
  required TextEditingController controller,
  required String hintText,
  required String? Function(String?) validator,
  int? maxLength,
  int? maxLines,
}) =>
    Container(
      height: height,
      child: TextFormField(
        maxLines: maxLines,
        maxLength: maxLength,
        controller: controller,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        validator: validator,
        cursorColor: Theme.of(context).primaryColor,
        style: TextStyle(
          fontFamily: 'Gotham_thin',
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
          ),
          isDense: true,
          contentPadding: EdgeInsets.all(24.0.w),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.circular(36.0.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffE65252),
            ),
            borderRadius: BorderRadius.circular(36.0.r),
          ),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
        ),
      ),
    );

Widget authButton(
  BuildContext context, {
  required void Function() onPressed,
  required String text,
}) =>
    MaterialButton(
      color: Theme.of(context).primaryColor,
      onPressed: onPressed,
      elevation: 0.0,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(16.0.r),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0.h),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0.sp,
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
          ),
        ),
      ),
    );

Widget authAlert(
  BuildContext context,
  String text,
) {
  AppLocalizations localizations = AppLocalizations.of(context)!;
  return Padding(
    padding: EdgeInsets.all(16.0.w),
    child: Card(
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(24.0.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0.w),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                text,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                  fontWeight: FontWeight.bold,
                  height: 1.5.h,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
              defaultTextButton(
                context: context,
                text: localizations.register,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => AuthScreen(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget defaultAlertDialog(
  BuildContext context, {
  required Widget content,
}) =>
    AlertDialog(
      backgroundColor: Theme.of(context).cardTheme.color,
      elevation: 0.0,
      shape: OutlineInputBorder(
        borderSide: BorderSide(
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.circular(36.0.r),
      ),
      content: content,
    );

Future<bool?> errorToast(
  BuildContext context,
  String msg,
) =>
    Fluttertoast.showToast(
      msg: msg,
      textColor: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
    );

Future editComment(
  BuildContext context, {
  required double deviceHeight,
  required TextEditingController commentController,
  required AppLocalizations localizations,
  required var message,
  required HomeCubit cubit,
}) {
  GlobalKey<FormState> _formKey = GlobalKey();
  return showDialog(
    context: context,
    builder: (BuildContext context) => defaultAlertDialog(
      context,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            sendingTextField(
              context,
              height: deviceHeight * 0.25,
              controller: commentController,
              hintText: localizations.enterComment,
              validator: (value) {
                if (value!.isEmpty) {
                  return localizations.commentValidator;
                } else {
                  return null;
                }
              },
              maxLength: 250,
              maxLines: 7,
            ),
            SizedBox(height: deviceHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                defaultTextButton(
                  context: context,
                  text: localizations.ok,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      cubit.comment(
                        context,
                        messageId: message.id!,
                        commentBody: commentController.text,
                      );
                    }
                  },
                ),
                defaultTextButton(
                  context: context,
                  text: localizations.skip,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

makingSureDialog(
  BuildContext context, {
  required String text,
  required AppLocalizations localizations,
  required double deviceHeight,
  required Function() onYes,
}) =>
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
              text,
              style: TextStyle(
                fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
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
                  onPressed: onYes,
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
