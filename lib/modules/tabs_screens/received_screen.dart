import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/modules/auth/cubit/auth_cubit.dart';
import 'package:serr_app/shared/components.dart';
import 'package:serr_app/shared/messages/received_message.dart';

class ReceivedScreen extends StatefulWidget {
  @override
  _ReceivedScreenState createState() => _ReceivedScreenState();
}

class _ReceivedScreenState extends State<ReceivedScreen> {
  late Future _getMessages;

  @override
  void initState() {
    _getMessages = Future.delayed(Duration.zero).then((value) {
      if (BlocProvider.of<HomeCubit>(context).messageModel == null) {
        BlocProvider.of<HomeCubit>(context).getMessages();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {
        if (state is HomeGetMessagesFailureState) {
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
          key: const PageStorageKey('ReceivedScreen'),
          body: BlocProvider.of<AuthCubit>(context, listen: true).isLogin
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await cubit.getMessages();
                  },
                  child: FutureBuilder(
                    future: _getMessages,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (cubit.messageModel == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      } else {
                        if (cubit.messageModel!.result.isEmpty) {
                          // put the text in SingleChildScrollView cuz refreshIndicator
                          // works only on scrollable widgets
                          return Center(
                            child: SingleChildScrollView(
                              child: Text(
                                localizations.noReceivedMessages,
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
                            itemCount: cubit.messageModel!.result.length,
                            itemBuilder: (BuildContext context, int index) =>
                                ReceivedMessage(index),
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
