import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:serr_app/layouts/home_cubit/home_cubit.dart';
import 'package:serr_app/layouts/home_cubit/home_states.dart';
import 'package:serr_app/modules/auth/cubit/auth_cubit.dart';
import 'package:serr_app/shared/components.dart';
import 'package:serr_app/shared/messages/sent_message.dart';

class SentScreen extends StatefulWidget {
  @override
  _SentScreenState createState() => _SentScreenState();
}

class _SentScreenState extends State<SentScreen> {
  late Future _getSentMessages;

  @override
  void initState() {
    _getSentMessages = Future.delayed(Duration.zero).then((value) {
      if (BlocProvider.of<HomeCubit>(context).sentMessageModel == null) {
        BlocProvider.of<HomeCubit>(context).getSentMessages();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations localizations = AppLocalizations.of(context)!;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (BuildContext context, HomeStates state) {
        if (state is HomeGetSentMessagesFailureState) {
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
          key: const PageStorageKey('SentScreen'),
          body: BlocProvider.of<AuthCubit>(context, listen: true).isLogin
              ? RefreshIndicator(
                  color: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await cubit.getSentMessages();
                  },
                  child: FutureBuilder(
                    future: _getSentMessages,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (cubit.sentMessageModel == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      } else {
                        if (cubit.sentMessageModel!.result.isEmpty) {
                          // put the text in SingleChildScrollView cuz refreshIndicator
                          // works only on scrollable widgets
                          return Center(
                            child: SingleChildScrollView(
                              child: Text(
                                localizations.noSentMessages,
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
                          List reversedResult =
                              cubit.sentMessageModel!.result.reversed.toList();
                          return ListView.builder(
                            itemCount: reversedResult.length,
                            itemBuilder: (BuildContext context, int index) =>
                                SentMessage(
                              message: reversedResult[index],
                            ),
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
