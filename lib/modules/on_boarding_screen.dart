import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:serr_app/modules/auth/auth_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:serr_app/shared/network/cache_helper.dart';
import 'package:serr_app/models/local_models.dart';
import 'package:serr_app/shared/components.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _pageController = PageController();

  int _boardIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    // double deviceWidth = MediaQuery.of(context).size.width;
    // print('height = $deviceHeight');
    // print('width = $deviceWidth');

    List<BoardModel> _boards = [
      BoardModel(
        'ما هو تطبيق سر ؟',
        'assets/images/img 1.jpg',
        'سر هو تطبيق مراسلة تستطيع من خلاله إرسال و إستقبال رسائل من أصدقاءك و عائلتك بدون أن يعرف أحد هويتك الحقيقية.',
      ),
      BoardModel(
        'كيف يعمل ؟',
        'assets/images/img 2.jpg',
        'كل ما عليك هو التسجيل باستخدام حسابك ثم ابدأ مباشرة بإرسال و استقبال الرسائل من أصدقائك.',
      ),
      BoardModel(
        'أين يمكنني الوصول للرسائل ؟',
        'assets/images/img 3.jpg',
        'يمكنك إيجاد رسائلك في صفحة الرسائل التي تحتوي علي رسائلك المرسلة و المستقبلة و المفضلة لديك.',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          defaultTextButton(
            context: context,
            text: 'skip',
            onPressed: () async {
              afterBoarding(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                onPageChanged: (int index) {
                  setState(() {
                    _boardIndex = index;
                  });
                },
                itemCount: _boards.length,
                itemBuilder: (BuildContext context, int index) =>
                    onBoardingItem(context, _boards[index], deviceHeight),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 20.0.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0.h),
                            child: Text(
                              'السابق',
                              style: TextStyle(
                                fontFamily: 'Arabic',
                                fontSize: 16.sp,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SmoothPageIndicator(
                          controller: _pageController,
                          count: _boards.length,
                          effect: WormEffect(
                            activeDotColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (_boardIndex == 2) {
                        afterBoarding(context);
                      }
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: Text(
                              'التالي'.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Arabic',
                                fontSize: 16.sp,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 20.0.sp,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void afterBoarding(BuildContext context) {
    CacheHelper.saveData('onBoardingSeen', true).then(
      (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => AuthScreen(),
          ),
        );
      },
    );
  }

  Widget onBoardingItem(
    BuildContext context,
    BoardModel board,
    double deviceHeight,
  ) =>
      Column(
        children: [
          Image(
            image: AssetImage(board.image!),
            height: deviceHeight * 0.5,
            fit: BoxFit.cover,
          ),
          SizedBox(height: deviceHeight * 0.04),
          Text(
            board.title!,
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 24.0.sp,
              fontFamily: 'Arabic',
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          SizedBox(height: deviceHeight * 0.04),
          Text(
            board.description!,
            textAlign: TextAlign.center,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20.0.sp,
              height: 1.5.h,
              fontFamily: 'Arabic',
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      );
}
