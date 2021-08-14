import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/layouts/home_layout.dart';
import 'package:serr_app/layouts/theme_cubit/theme_cubit.dart';
import 'package:serr_app/modules/auth/cubit/auth_cubit.dart';
import 'package:serr_app/modules/auth/cubit/auth_states.dart';
import 'package:serr_app/shared/components.dart';

//ignore: must_be_immutable
class AuthScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    //double deviceWidth = MediaQuery.of(context).size.width;
    AppLocalizations localizations = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (BuildContext context, AuthStates state) {
        if (state is AuthLoginFailureState ||
            state is AuthRegisterFailureState ||
            state is AuthGoogleAuthFailureState) {
          Fluttertoast.showToast(
            msg: localizations.error,
            backgroundColor: Colors.red,
          );
        }
        if (state is AuthLoginSuccessState ||
            state is AuthRegisterSuccessState ||
            state is AuthGoogleAuthSuccessState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => HomeLayout(),
            ),
          );
        }
      },
      builder: (BuildContext context, AuthStates state) {
        AuthCubit cubit = BlocProvider.of<AuthCubit>(context);
        return WillPopScope(
          onWillPop: () async {
            await Navigator.pushReplacement(
              context,
              PageTransition(
                child: HomeLayout(),
                type: PageTransitionType.rightToLeft,
              ),
            );
            return true;
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(deviceHeight * 0.074),
              child: AppBar(
                backgroundColor: Colors.transparent,
                backwardsCompatibility: false,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                  BlocProvider.of<ThemeCubit>(context, listen: true)
                      .themeMode ==
                      ThemeMode.light
                      ? Brightness.dark
                      : Brightness.light,
                ),
                actions: [
                  defaultTextButton(
                    context: context,
                    text: localizations.skip,
                    onPressed: () {
                      cubit.authScreenSeen().then(
                            (value) {
                          Navigator.pushReplacement(
                            context,
                            PageTransition(
                              child: HomeLayout(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            body: SingleChildScrollView(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  FocusScope.of(context).requestFocus(cubit.focusNode);
                },
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: deviceHeight * 0.05,
                      ),
                      Container(
                        height: deviceHeight * 0.15,
                        child: Image(
                          image: AssetImage('assets/images/Serr icon.png'),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight * 0.05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.0.w),
                        child: Container(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.0.w,
                                vertical: 48.0.h,
                              ),
                              child: Column(
                                children: [
                                  if (cubit.authMode == AuthMode.register)
                                    defaultTextField(
                                      context,
                                      prefixIcon: Icons.person_outline_outlined,
                                      controller: userNameController,
                                      deviceHeight: deviceHeight,
                                      hintText: localizations.userName,
                                      keyBoardType: TextInputType.name,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return localizations.validatorU;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  SizedBox(height: deviceHeight * 0.03),
                                  defaultTextField(
                                    context,
                                    prefixIcon: Icons.email_outlined,
                                    controller: emailController,
                                    deviceHeight: deviceHeight,
                                    hintText: localizations.email,
                                    keyBoardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !value.contains('@')) {
                                        return localizations.validatorE;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: deviceHeight * 0.03),
                                  defaultTextField(
                                    context,
                                    prefixIcon: Icons.lock_outline,
                                    controller: passwordController,
                                    deviceHeight: deviceHeight,
                                    hintText: localizations.password,
                                    keyBoardType: TextInputType.visiblePassword,
                                    obscureText: cubit.passwordSecured,
                                    suffixIcon: cubit.passwordSecured
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    suffixPressed: () {
                                      cubit.passwordVisibility();
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 8) {
                                        return localizations.validatorP;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  SizedBox(height: deviceHeight * 0.03),
                                  state is AuthLoginLoadingState ||
                                      state is AuthRegisterLoadingState ||
                                      state is AuthGoogleAuthLoadingState
                                      ? CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  )
                                      : authButton(
                                    context,
                                    onPressed: () {
                                      if (formKey.currentState!
                                          .validate()) {
                                        FocusScope.of(context).unfocus();

                                        if (cubit.authMode ==
                                            AuthMode.login) {
                                          cubit.login(
                                            context,
                                            email: emailController.text
                                                .toLowerCase(),
                                            password:
                                            passwordController.text,
                                          );
                                        } else {
                                          cubit.register(
                                            context,
                                            username:
                                            userNameController.text,
                                            email: emailController.text
                                                .toLowerCase(),
                                            password:
                                            passwordController.text,
                                          );
                                        }
                                      }
                                    },
                                    text: cubit.authMode == AuthMode.login
                                        ? localizations.login
                                        : localizations.register,
                                  ),
                                  SizedBox(height: deviceHeight * 0.01),
                                  if (cubit.authMode == AuthMode.login)
                                    setAuthMode(
                                      context,
                                      text: localizations.noAccount,
                                      buttonText: localizations.register,
                                    ),
                                  if (cubit.authMode == AuthMode.register)
                                    setAuthMode(
                                      context,
                                      text: localizations.haveAccount,
                                      buttonText: localizations.login,
                                    ),
                                  SizedBox(height: deviceHeight * 0.01),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      socialMediaAuth(
                                        deviceHeight: deviceHeight,
                                        img: 'assets/images/gmail.png',
                                        onPressed: () {
                                          cubit.googleSignIn(context);
                                        },
                                      ),
                                      socialMediaAuth(
                                        deviceHeight: deviceHeight,
                                        img: 'assets/images/facebook.png',
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: deviceHeight * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget socialMediaAuth({
  required double deviceHeight,
  required String img,
  required Function() onPressed,
}) =>
    MaterialButton(
      onPressed: onPressed,
      elevation: 0.0,
      highlightElevation: 0.0,
      child: Image(
        height: deviceHeight * 0.05,
        image: AssetImage(img),
      ),
    );

Widget setAuthMode(
    BuildContext context, {
      required String text,
      required String buttonText,
    }) {
  AuthCubit cubit = BlocProvider.of<AuthCubit>(context);
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text(
        text,
        style: TextStyle(
          fontSize: 14.0.sp,
          fontWeight: FontWeight.bold,
          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ),
      ),
      defaultTextButton(
        context: context,
        text: buttonText,
        onPressed: () {
          cubit.setAuthMode();
        },
      ),
    ],
  );
}
