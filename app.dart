import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app_init.dart';
import 'common/constants.dart';
import 'common/styles.dart';
import 'common/tools.dart';
import 'generated/l10n.dart';
import 'models/advertisement.dart';
import 'models/app.dart';
import 'models/blogs/blog.dart';
import 'models/cart/cart_model.dart';
import 'models/category/category_model.dart';
import 'models/filter_attribute.dart';
import 'models/filter_tags.dart';
import 'models/notification.dart';
import 'models/order/order_model.dart';
import 'models/payment_method.dart';
import 'models/product/product_model.dart';
import 'models/recent_product.dart';
import 'models/search.dart';
import 'models/shipping_method.dart';
import 'models/user/user_model.dart';
import 'models/wishlist.dart';
import 'route.dart';
import 'routes/route_observer.dart';
import 'tabbar.dart';
import 'widgets/common/dialogs.dart';
import 'widgets/common/internet_connectivity.dart';
import 'widgets/firebase/firebase_analytics_wapper.dart';
import 'widgets/firebase/firebase_cloud_messaging_wapper.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppState();
  }
}

class AppState extends State<App> implements FirebaseCloudMessagingDelegate {
  final _app = AppModel();
  final _product = ProductModel();
  final _wishlist = WishListModel();
  final _shippingMethod = ShippingMethodModel();
  final _paymentMethod = PaymentMethodModel();
  final _advertisementModel = Ads();
  final _order = OrderModel();
  final _search = SearchModel();
  final _recent = RecentModel();
  final _blog = BlogModel();
  final _user = UserModel();
  final _filterModel = FilterAttributeModel();
  final _filterTagModel = FilterTagModel();
  CartInject cartModel = CartInject();
  bool isFirstSeen = false;
  bool isLoggedIn = false;

  FirebaseAnalyticsAbs firebaseAnalyticsAbs;

  @override
  void initState() {
    printLog("[AppState] initState");

    if (kIsWeb) {
      printLog("[AppState] init WEB");
      firebaseAnalyticsAbs = FirebaseAnalyticsWeb();
    } else {
      firebaseAnalyticsAbs = FirebaseAnalyticsWapper()..init();

      Future.delayed(
        Duration(seconds: 1),
        () {
          printLog("[AppState] init mobile modules ..");

            if (MyConnectivity.instance.isIssue(onData)) {
              if (MyConnectivity.instance.isShow == true) {
                MyConnectivity.instance.isShow = false;
                showDialogNotInternet(context).then((onValue) {
                  MyConnectivity.instance.isShow = false;
                  printLog("[showDialogNotInternet] dialog closed $onValue");
                });
              }
            } else {
              if (MyConnectivity.instance.isShow == true) {
                Navigator.of(context).pop();
                MyConnectivity.instance.isShow = false;
              }
            }
          AppModel appModel = Provider.of<AppModel>(context);
    bool isDarkTheme = appModel.darkTheme ?? false;
          });

          FirebaseCloudMessagagingWapper()
            ..init()
            ..delegate = this;
      
          MyConnectivity.instance.initialise();
          MyConnectivity.instance.myStream.listen((onData) {
            printLog("[App] internet issue change: $onData");


          // OneSignalWapper()..init();
          printLog("[AppState] register modules .. DONE");
        },
      );
    }
    super.initState();
  }

  _saveMessage(message) {
    FStoreNotification a = FStoreNotification.fromJsonFirebase(message);
    a.saveToLocal(
      message['notification'] != null
          ? message['notification']['tag']
          : message['data']['google.message_id'],
    );
  }

  @override
  onLaunch(Map<String, dynamic> message) {
    _saveMessage(message);
  }

  @override
  onMessage(Map<String, dynamic> message) {
    _saveMessage(message);
  }

  @override
  onResume(Map<String, dynamic> message) {
    _saveMessage(message);
  }

  /// Build the App Theme
  ThemeData getTheme(context) {
    printLog("[AppState] build Theme");

    

    if (appModel.appConfig == null) {
      /// This case is loaded first time without config file
      return buildLightTheme(appModel.locale);
    }

    if (isDarkTheme) {
      return buildDarkTheme(appModel.locale).copyWith(
        primaryColor: HexColor(
          appModel.appConfig["Setting"]["MainColor"],
        ),
        AppModel appModel = Provider.of<AppModel>(context);
    bool isDarkTheme = appModel.darkTheme ?? false;
      );
    }
    return buildLightTheme(appModel.locale).copyWith(
      primaryColor: HexColor(appModel.appConfig["Setting"]["MainColor"]),
    );
  }

  @override
  Widget build(BuildContext context) {
    printLog("[AppState] build");

    return ChangeNotifierProvider<AppModel>.value(
      value: _app,
      child: Consumer<AppModel>(
        builder: (context, value, child) {
          return MultiProvider(
            providers: [
              Provider<ProductModel>.value(value: _product),
              Provider<WishListModel>.value(value: _wishlist),
              Provider<ShippingMethodModel>.value(value: _shippingMethod),
              Provider<PaymentMethodModel>.value(value: _paymentMethod),
              Provider<OrderModel>.value(value: _order),
              Provider<SearchModel>.value(value: _search),
              Provider<RecentModel>.value(value: _recent),
              Provider<UserModel>.value(value: _user),
              Provider<FilterAttributeModel>.value(value: _filterModel),
              Provider<FilterTagModel>.value(value: _filterTagModel),
              ChangeNotifierProvider(create: (_) {
                return cartModel.model;
              }),
              ChangeNotifierProvider(create: (_) => CategoryModel()),
              ChangeNotifierProvider(create: (_) => BlogModel()),
              ChangeNotifierProvider(create: (_) => _blog),
              ChangeNotifierProvider(create: (_) => _advertisementModel),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: Locale(Provider.of<AppModel>(context).locale, ""),
              navigatorObservers: [
                MyRouteObserver(),
                ...firebaseAnalyticsAbs.getMNavigatorObservers()
              ],
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: Scaffold(
                body: AppInit(
                  onNext: (config) => MainTabs(),
                ),
              ),
              routes: Routes.getAll(),
              theme: getTheme(context),
            ),
          );
        },
      ),
    );
  }
}
