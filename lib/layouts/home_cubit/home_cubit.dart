import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/models/messages_models/fav_message_model.dart';
import 'package:serr_app/models/messages_models/message_model.dart';
import 'package:serr_app/models/messages_models/public_message_model.dart';
import 'package:serr_app/models/search_model.dart';
import 'package:serr_app/models/messages_models/sent_message_model.dart';
import 'package:serr_app/models/searched_user_model.dart';
import 'package:serr_app/models/user_model.dart';
import 'package:serr_app/modules/basic_screens/messages_screen.dart';
import 'package:serr_app/modules/basic_screens/more_screen.dart';
import 'package:serr_app/modules/basic_screens/recent_screen.dart';
import 'package:serr_app/modules/tabs_screens/favourite_screen.dart';
import 'package:serr_app/modules/tabs_screens/received_screen.dart';
import 'package:serr_app/modules/tabs_screens/sent_screen.dart';
import 'package:serr_app/shared/network/database_helper.dart';
import 'package:serr_app/shared/network/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  int currentIndex = 0;
  final List<Widget> basicScreens = [
    RecentScreen(),
    MessagesScreen(),
    MoreScreen(),
  ];
  final List<Widget> tabsScreens = [
    ReceivedScreen(),
    FavouriteScreen(),
    SentScreen(),
  ];

  File? selectedImage;

  bool isBsShown = false;

  SearchModel? searchModel;

  String? sendMessageResponse;

  MessageModel? messageModel;

  SentMessageModel? sentMessageModel;

  SearchedUserModel? searchedUserModel;

  PublicMessageModel? publicMessageModel;

  FavMessageModel? favMessageModel;

  Map<String, bool> favourites = {};

  Map<String, bool> public = {};

// fetching data from the local database
  late List data;
  late String name;
  late String username;
  late String userId;
  late String email;
  late String img;
  late String token;

  Future<List> getUserData() async {
    data = await DatabaseHelper.instance.getData();
    print(data);
    if (data.isNotEmpty) {
      name = data[0]['name'];
      username = data[0]['username'];
      userId = data[0]['userId'];
      email = data[0]['email'];
      img = data[0]['img'];
      token = data[0]['token'];
    }
    emit(HomeGetLocalUserDataSuccessState());
    return data;
  }

  //
//fetching searched user data
  void getSearchedUserData({
    required String searchedId,
    // required String searchedName,
  }) async {
    emit(HomeGetSearchedUserDataLoadingState());
    DioHelper.getData(
      url: 'user',
      query: {
        "fbid": searchedId,
        // "name": searchedName,
      },
    ).then((value) {
      print(value.data);
      searchedUserModel = SearchedUserModel.fromJson(value.data);
      emit(HomeGetSearchedUserDataSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeGetSearchedUserDataFailureState());
    });
  }

// fetching search when searching in recent screen
  void getSearch(String name) async {
    emit(HomeSearchLoadingState());
    DioHelper.getData(
      url: 'user/search',
      query: {'name': name},
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(HomeSearchSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeSearchFailureState());
      // throw e;
    });
  }

//sending message to someone in landing screen (sender is not authorized)
  Future<Future<Null>> sendMessage({
    required String userId,
    required String messageBody,
  }) async {
    emit(HomeSendMessageLoadingState());
    return DioHelper.postData(
      url: 'message',
      data: {
        'userId': userId,
        'messageBody': messageBody,
      },
    ).then((value) {
      sendMessageResponse = value.data['message'];
      emit(HomeSendMessageSuccessState(sendMessageResponse!));
    }).catchError((e) {
      print(e);
      emit(HomeSendMessageFailureState());
    });
  }

//sending message to someone in landing screen (sender is authorized)
  Future<Future<Null>> sendMessageAuthed({
    required String userId,
    required String senderId,
    required String messageBody,
  }) async {
    emit(HomeSendMessageLoadingState());
    return DioHelper.postData(
      url: 'message',
      data: {
        'userId': userId,
        'senderId': senderId,
        'messageBody': messageBody,
      },
    ).then((value) {
      sendMessageResponse = value.data['message'];
      emit(HomeSendMessageSuccessState(sendMessageResponse!));
    }).catchError((e) {
      print(e);
      emit(HomeSendMessageFailureState());
    });
  }

//fetching user messages
  getMessages() async {
    emit(HomeGetMessagesLoadingState());
    await DioHelper.getData(
      url: 'message',
      query: {'fbid': userId},
      token: token,
    ).then((value) {
      messageModel = MessageModel.fromJson(value.data);

      messageModel!.result.forEach((element) {
        favourites.addAll(
          {element.id!: element.isFavourite!},
        );
      });

      messageModel!.result.forEach((element) {
        public.addAll(
          {element.id!: element.isPublic!},
        );
      });

      emit(HomeGetMessagesSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeGetMessagesFailureState());
    });
  }

//fetching user favourite messages
  getFavMessages() async {
    emit(HomeGetFavMessagesLoadingState());
    await DioHelper.getData(
      url: 'message/favouriteMessages',
      query: {'fbid': userId},
      token: token,
    ).then((value) {
      favMessageModel = FavMessageModel.fromJson(value.data);
      emit(HomeGetFavMessagesSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeGetFavMessagesFailureState());
    });
  }

//patching fav messages
  Future<Null> setFav(String messageId) async {
    favourites[messageId] = !favourites[messageId]!;
    emit(HomeSetFavLoadingState());
    return await DioHelper.patchData(
      url: 'message/setIsFavourite',
      data: {'messageId': messageId},
      token: token,
    ).then((value) {
      if (!value.data['status']) {
        favourites[messageId] = !favourites[messageId]!;
      }
      getFavMessages();
      emit(HomeSetFavSuccessState());
    }).catchError((e) {
      print(e);
      favourites[messageId] = !favourites[messageId]!;
      emit(HomeSetFavFailureState());
    });
  }

//fetching public messages
  getPublicMessages(String userId) async {
    emit(HomeGetPublicMessagesLoadingState());
    return await DioHelper.getData(
      url: 'message/publicMessages',
      query: {'fbid': userId},
    ).then((value) {
      publicMessageModel = PublicMessageModel.fromJson(value.data);
      emit(HomeGetPublicMessagesSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeGetMessagesFailureState());
    });
  }

//patching public messages
  Future<Null> setPublic(String messageId) async {
    public[messageId] = !public[messageId]!;
    emit(HomeSetPublicLoadingState());
    return await DioHelper.patchData(
      url: 'message/setIsPublic',
      data: {'messageId': messageId},
      token: token,
    ).then((value) {
      if (!value.data['status']) {
        public[messageId] = !public[messageId]!;
      }
      if (favourites[messageId]!) {
        getFavMessages();
      }
      emit(HomeSetPublicSuccessState());
    }).catchError((e) {
      print(e);
      public[messageId] = !public[messageId]!;
      emit(HomeSetPublicFailureState());
    });
  }

//fetching user sent messages
  getSentMessages() async {
    emit(HomeGetSentMessagesLoadingState());
    await DioHelper.getData(
      url: 'message/sentMessages',
      query: {'fbid': userId},
      token: token,
    ).then((value) {
      sentMessageModel = SentMessageModel.fromJson(value.data);
      emit(HomeGetSentMessagesSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeGetSentMessagesFailureState());
    });
  }

//deleting a message
  deleteMessage(
    BuildContext context,
    String messageId,
  ) async {
    emit(HomeDeleteMessageLoadingState());

    await DioHelper.deleteData(
      url: 'message',
      query: {'messageId': messageId},
      token: token,
    ).then((value) {
      Navigator.pop(context);
      getMessages();
      if (favourites[messageId]!) {
        getFavMessages();
      }

      emit(HomeDeleteMessageSuccessState());
    }).catchError((e) {
      print(e);
      emit(HomeDeleteMessageFailureState());
    });
  }

//commenting
  Future<Null> comment(
    BuildContext context, {
    required String messageId,
    required String commentBody,
  }) async {
    emit(HomeCommentLoadingState());

    return await DioHelper.patchData(
      url: 'message/setComment',
      data: {
        'messageId': messageId,
        'commentBody': commentBody,
      },
      token: token,
    ).then((value) {
      Navigator.pop(context);
      getMessages();
      if (favourites[messageId]!) {
        getFavMessages();
      }

      emit(HomeCommentSuccessState());
    }).catchError((e) {
      Navigator.pop(context);
      emit(HomeCommentFailureState());
    });
  }

//updating user data
  Future updateUserData(
    BuildContext context, {
    required String newName,
    File? image,
  }) async {
    FormData formData = FormData.fromMap({
      'name': newName,
      'img': image == null
          ? ''
          : await MultipartFile.fromFile(
              image.path,
              contentType: new MediaType('image', 'jpg'),
            ),
      'fbid': userId,
    });

    emit(HomeUpdateDataLoadingState());

    await DioHelper.patchData(
      url: 'user',
      data: formData,
    ).then((value) async {
      print(value.data);
      await DatabaseHelper.instance.updateData(
        UserModel(
          name: value.data['result']['name'],
          username: username,
          userId: userId,
          email: email,
          img: image == null ? img : value.data['result']['img'],
          token: token,
        ),
      );

      name = value.data['result']['name'];
      img = image == null ? img : value.data['result']['img'];

      selectedImage = null;

      emit(HomeUpdateDataSuccessState(value.data['message']));
    }).catchError((e) {
      print(e);
      emit(HomeUpdateDataFailureState());
    });
  }

//pick image from camera or gallery
  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;

      final imageTemporary = File(image.path);

      selectedImage = imageTemporary;

      emit(HomeGetImageSuccessState());
    } on PlatformException catch (e) {
      print(e);
      emit(HomeGetImageFailureState());
    }
  }

  void setBsState(bool isShown) {
    isBsShown = isShown;
    emit(HomeSetBsState());
  }

  void setBNBIndex(int index) {
    currentIndex = index;
    emit(HomeSetBNBIndexState());
  }
}
