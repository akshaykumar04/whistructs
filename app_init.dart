import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/config.dart';
import 'common/constants.dart';
import 'models/app.dart';
import 'models/blogs/blog.dart';
import 'models/category/category_model.dart';
import 'models/filter_attribute.dart';
import 'models/filter_tags.dart';
import 'screens/home/onboard_screen.dart';
import 'screens/users/login.dart';
import 'services/index.dart';
import 'widgets/common/animated_splash.dart';

class AppInit extends StatefulWidget {
  final Function onNext;

  AppInit({this.onNext});

  @override
  _AppInitState createState() => _AppInitState();
}

class _AppInitState extends State<AppInit> with AfterLayoutMixin<AppInit> {
  bool isFirstSeen = false;
  bool isLoggedIn = false;
  Map appConfig = {};

  /// check if the screen is already seen At the first time
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = prefs.getBool('seen') ?? false;
    return !_seen;
  }

  /// Check if the App is Login
  Future checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loggedIn') ?? true;
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    await loadInitData();
  }

  Future<void> loadInitData() async {
    try {
      printLog("[AppState] Inital Data");

      isFirstSeen = await checkFirstSeen();
      isLoggedIn = await checkLogin();

      /// Load App model config
      Services().setAppConfig(serverConfig);
      appConfig =
          await Provider.of<AppModel>(context, listen: false).loadAppConfig();

      Future.delayed(Duration.zero, () {
        /// Load more Category/Blog/Attribute Model beforehand
        if (mounted) {
          Provider.of<CategoryModel>(context, listen: false).getCategories(
              lang: Provider.of<AppModel>(context, listen: false).locale);

          Provider.of<BlogModel>(context, listen: false).getBlogs();

          Provider.of<FilterTagModel>(context, listen: false).getFilterTags();

          Provider.of<FilterAttributeModel>(context, listen: false)
              .getFilterAttributes();
        }
      });

      printLog("[AppState] Init Data Finish");
    } catch (e, trace) {
      print(e.toString());
      print(trace.toString());
    }
  }

  Widget onNextScreen() {
    if (isFirstSeen && !kIsWeb) {
      if (onBoardingData.isNotEmpty) return OnBoardScreen(context);
    }

    if (kLoginSetting['IsRequiredLogin'] && !isLoggedIn) return LoginScreen(context);

    return widget.onNext(appConfig);
  }

  @override
  Widget build(BuildContext context) {
    /// For Flare Image
    if (kSplashScreen.lastIndexOf('flr') > 0) {
      return SplashScreen.navigate(
        name: kSplashScreen,
        startAnimation: 'main_app',
        backgroundColor: Colors.white,
        next: (object) => onNextScreen(),
        until: () => Future.delayed(Duration(seconds: 2)),
      );
    }

    if (kSplashScreen.lastIndexOf('png') > 0) {
      return AnimatedSplash(
        imagePath: kSplashScreen,
        home: onNextScreen(),
        duration: 3500,
        type: AnimatedSplashType.StaticDuration,
      );
    }

    return CustomSplash(
      imagePath: kLogoImage,
      backGroundColor: Colors.black,
      animationEffect: 'fade-in',
      logoSize: 40,
      home: onNextScreen(),
      duration: 3500,
    );
  }
}
