import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:serr_app/layouts/home_cubit/home_cubit.dart';

import 'package:serr_app/models/user_model.dart';
import 'package:serr_app/modules/auth/cubit/auth_states.dart';
import 'package:serr_app/shared/network/cache_helper.dart';
import 'package:serr_app/shared/network/database_helper.dart';
import 'package:serr_app/shared/network/dio_helper.dart';

enum AuthMode {
  login,
  register,
}

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  FocusNode focusNode = new FocusNode();

  bool passwordSecured = true;
  AuthMode authMode = AuthMode.login;

  bool isLogin = CacheHelper.getData('isLogin') ?? false;

  void register(
      BuildContext context, {
        required String username,
        required String email,
        required String password,
      }) async {
    emit(AuthRegisterLoadingState());
    DioHelper.postData(
      url: 'user/signup',
      data: {
        'name': username,
        'email': email,
        'password': password,
      },
    ).then((value) async {
      await DatabaseHelper.instance
          .insertData(
        UserModel(
          name: value.data['name'],
          username: value.data['username'],
          userId: value.data['userId'],
          email: value.data['email'],
          img: value.data['img'],
          token: value.data['token'],
        ),
      )
          .then((value) {
        BlocProvider.of<HomeCubit>(context).getUserData();
        print('data inserted');
      });

      authScreenSeen();
      isLogin = true;
      CacheHelper.saveData('isLogin', true);

      emit(AuthRegisterSuccessState());
    }).catchError((e) {
      print(e);
      emit(AuthRegisterFailureState());
    });
  }

  void login(
      BuildContext context, {
        required String email,
        required String password,
      }) async {
    emit(AuthLoginLoadingState());
    DioHelper.postData(
      url: 'user/login',
      data: {
        'email': email,
        'password': password,
      },
    ).then((value) async {
      await DatabaseHelper.instance
          .insertData(
        UserModel(
          name: value.data['name'],
          username: value.data['username'],
          userId: value.data['userId'],
          email: value.data['email'],
          img: value.data['img'],
          token: value.data['token'],
        ),
      )
          .then((value) {
        BlocProvider.of<HomeCubit>(context).getUserData();
        print('data inserted');
      });

      authScreenSeen();
      isLogin = true;
      CacheHelper.saveData('isLogin', true);

      emit(AuthLoginSuccessState());
    }).catchError((e) {
      print(e);
      emit(AuthLoginFailureState());
    });
  }

  void googleSignIn(BuildContext context) async {
    GoogleSignInAccount? response = await GoogleSignIn(
      clientId:
      '951458547942-vb6s99k6cnd1ih6mprcjlt271sehnm2u.apps.googleusercontent.com',
    ).signIn();
    GoogleSignInAuthentication res = await response!.authentication;

    emit(AuthGoogleAuthLoadingState());
    DioHelper.postData(
      url: 'user/googleSign',
      data: {
        'tokenId': res.idToken,
      },
    ).then((value) async {
      await DatabaseHelper.instance
          .insertData(
        UserModel(
          name: value.data['name'],
          username: value.data['username'],
          userId: value.data['userId'],
          email: value.data['email'],
          img: value.data['img'],
          token: value.data['token'],
        ),
      )
          .then((value) {
        BlocProvider.of<HomeCubit>(context).getUserData();
        print('data inserted');
      });

      authScreenSeen();
      isLogin = true;
      CacheHelper.saveData('isLogin', true);

      emit(AuthGoogleAuthSuccessState());
    }).catchError((e) {
      print(e);
      emit(AuthGoogleAuthFailureState());
    });
  }

  void logout() async {
    try {
      emit(AuthLogoutLoadingState());

      await GoogleSignIn(
        clientId:
        '951458547942-vb6s99k6cnd1ih6mprcjlt271sehnm2u.apps.googleusercontent.com',
      ).signOut();
      DatabaseHelper.instance.deleteData().then((value) {
        print('database deleted');
      });

      isLogin = false;
      CacheHelper.saveData('isLogin', false);

      emit(AuthLogoutSuccessState());
    } catch (error) {
      print(error);
      emit(AuthLogoutFailureState());
    }
  }

  void setAuthMode() {
    if (authMode == AuthMode.login) {
      authMode = AuthMode.register;
    } else {
      authMode = AuthMode.login;
    }
    emit(AuthSetAuthModeState());
  }

  void passwordVisibility() {
    passwordSecured = !passwordSecured;
    emit(AuthPasswordVisibilityState());
  }

  Future<bool> authScreenSeen() {
    emit(AuthScreenSeenState());
    return CacheHelper.saveData('isAuthScreenSeen', true);
  }
}
