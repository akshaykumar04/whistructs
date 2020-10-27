import 'package:flutter/material.dart';

import 'common/constants.dart';
import 'screens/blogs/blogs.dart';
import 'screens/categories/index.dart';
import 'screens/checkout/index.dart';
import 'screens/home/home.dart';
import 'screens/orders/orders.dart';
import 'screens/products/products.dart';
import 'screens/search/search.dart';
import 'screens/settings/notification.dart';
import 'screens/settings/settings.dart';
import 'screens/settings/wishlist.dart';
import 'screens/users/login.dart';
import 'screens/users/registration.dart';
import 'tabbar.dart';

class Routes {
  static final Map<String, WidgetBuilder> _routes = {
    "/home-screen": (context) => HomeScreen(),
    "/home": (context) => MainTabs(),
    "/login": (context) => LoginScreen(),
    "/register": (context) => RegistrationScreen(),
    '/products': (context) => ProductsPage(),
    '/wishlist': (context) => WishList(),
    '/checkout': (context) => Checkout(),
    '/orders': (context) => MyOrders(),
    '/blogs': (context) => BlogScreen(),
    '/notify': (context) => NotificationScreen(),
    '/category': (context) => CategoriesScreen(),
    '/search': (context) => SearchScreen(),
    '/setting': (context) => SettingScreen()
  };
  static Map<String, WidgetBuilder> getAll() => _routes;

  static WidgetBuilder getRouteByName(String name) {
    if (_routes.containsKey(name) == false) {
      return _routes[RouteList.homeScreen];
    }
    return _routes[name];
  }
}
