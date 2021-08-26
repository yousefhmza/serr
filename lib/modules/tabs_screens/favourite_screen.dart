import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/modules/auth/cubit/auth_cubit.dart';
import 'package:serr_app/shared/components.dart';
import 'package:serr_app/shared/messages/fav_message.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  late Future _getFavMessages;

  @override
  void initState() {
    if (BlocProvider.of<HomeCubit>(context).messageModel == null) {
      BlocProvider.of<HomeCubit>(context).getMessages();
    }
    _getFavMessages = Future.delayed(Duration.zero).then((value) {
      if (BlocProvider.of<HomeCubit>(context).favMessageModel == null) {
        BlocProvider.of<HomeCubit>(context).getFavMessages();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {
        if (state is HomeGetFavMessagesFailureState) {
          showToast(
            context,
            msg: localizations.error,
            error: true,
          );
        }
      },
      builder: (BuildContext context, HomeStates state) {
        HomeCubit cubit = BlocProvider.of<HomeCubit>(context);
        return Scaffold(
          key: const PageStorageKey('FavouriteScreen'),
          body: BlocProvider.of<AuthCubit>(context, listen: true).isLogin
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await cubit.getFavMessages();
                  },
                  child: FutureBuilder(
                    future: _getFavMessages,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (cubit.favMessageModel == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      } else {
                        if (cubit.favMessageModel!.result.isEmpty) {
                          // put the text in SingleChildScrollView cuz refreshIndicator
                          // works only on scrollable widgets
                          return Center(
                            child: SingleChildScrollView(
                              child: Text(
                                localizations.noFavouriteMessages,
                                style: TextStyle(
                                  fontSize: 22.0.sp,
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
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: cubit.favMessageModel!.result.length,
                            itemBuilder: (BuildContext context, int index) =>
                                FavMessage(index),
                          );
                        }
                      }
                    },
                  ),
                )
              : authAlert(
                  context,
                  localizations.noMessages,
                ),
        );
      },
    );
  }
}
