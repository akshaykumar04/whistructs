import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common/config.dart';
import 'common/constants.dart';
import 'generated/l10n.dart';
import 'models/category/category_model.dart';
import 'models/product/product.dart';
import 'models/user/user_model.dart';

class MenuBar extends StatefulWidget {
  final GlobalKey<NavigatorState> navigation;
  final StreamController<String> controllerRouteWeb;

  MenuBar({this.navigation, this.controllerRouteWeb});

  @override
  _MenuBarState createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  @override
  Widget build(BuildContext context) {
    printLog("[MenuBar] build");
    bool loggedIn = Provider.of<UserModel>(context).loggedIn;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Row(
              children: <Widget>[
                Image.asset(kLogoImage, height: 80),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Column(
              children: <Widget>[
                if (kLayoutWeb)
                  ListTile(
                    leading: const Icon(
                      Icons.format_list_bulleted,
                      size: 20,
                    ),
                    title: Text(S.of(context).category),
                    onTap: () {
                      widget.controllerRouteWeb.sink.add("/category");
                    },
                  ),
                if (kLayoutWeb)
                  ListTile(
                    leading: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    title: Text(S.of(context).search),
                    onTap: () {
                      widget.controllerRouteWeb.sink.add("/search");
                    },
                  ),
                if (kLayoutWeb)
                  ListTile(
                    leading: const Icon(Icons.settings, size: 20),
                    title: Text(S.of(context).settings),
                    onTap: () {
                      if (kLayoutWeb) {
                        widget.controllerRouteWeb.sink.add("/setting");
                      } else {
                        Navigator.of(context).pushNamed("/setting");
                      }
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.exit_to_app, size: 20),
                  title: loggedIn
                      ? Text(S.of(context).logout)
                      : Text(S.of(context).login),
                  onTap: () {
                    if (loggedIn) {
                      Provider.of<UserModel>(context, listen: false).logout();
                    } else {
                      if (kLayoutWeb) {
                        widget.controllerRouteWeb.sink.add("/login");
                      } else {
                        Navigator.pushNamed(context, "/login");
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      S.of(context).byCategory.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).accentColor.withOpacity(0.5),
                      ),
                    ),
                    children: getChildren()),
              ],
            ),
          )
        ],
      ),
    );
  }

  List showStaticCategories() {
    final categories = Provider.of<CategoryModel>(context).categories;
    List<Widget> widgets = [];

    if (categories != null) {
      var list = categories.where((item) => item.parent == '0').toList();
      for (var index in list) {
        widgets.add(
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 0),
              child: Text(
                index.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  List showCategories() {
    final categories = Provider.of<CategoryModel>(context).categories;
    List<Widget> widgets = [];

    if (categories != null) {
      var list = categories.where((item) => item.parent == '0').toList();
      for (var index in list) {
        widgets.add(
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.only(left: 0.0, top: 0),
              child: Text(
                index.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  List getChildren() {
    List<Widget> list = [];
    list.add(
      ListTile(
        leading: Padding(
          child: Text("Christmas"),
          padding: const EdgeInsets.only(left: 20),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
        onTap: () {
          Product.showList(
              context: context,
              cateId: "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzE2NzcwNTM0NjA5NA==",
              cateName: "Christmas");
        },
      ),
    );
    list.add(
      ListTile(
        leading: Padding(
          child: Text("Candle Holders"),
          padding: const EdgeInsets.only(left: 20),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
        onTap: () {
          Product.showList(
              context: context,
              cateId: "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzE1OTA5NTM5MDI1NA==",
              cateName: "Candle Holders");
        },
      ),
    );
    list.add(
      ListTile(
        leading: Padding(
          child: Text("Soft Furnishings"),
          padding: const EdgeInsets.only(left: 20),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
        onTap: () {
          Product.showList(
              context: context,
              cateId: "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzE2MzE3MzEzODQ3OA==",
              cateName: "Soft Furnishings");
        },
      ),
    );
    list.add(
      ListTile(
        leading: Padding(
          child: Text("Decorative Accessories"),
          padding: const EdgeInsets.only(left: 20),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
        onTap: () {
          Product.showList(
              context: context,
              cateId: "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzE1OTA5NTQ4ODU1OA==",
              cateName: "Decorative Accessories");
        },
      ),
    );
    list.add(
      ListTile(
        leading: Padding(
          child: Text("Kitchen & Living"),
          padding: const EdgeInsets.only(left: 20),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
        onTap: () {
          Product.showList(
              context: context,
              cateId: "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzE1OTA5NTU1NDA5NA==",
              cateName: "Kitchen & Living");
        },
      ),
    );
    list.add(
      ListTile(
        leading: Padding(
          child: Text("Wall Decor"),
          padding: const EdgeInsets.only(left: 20),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 12,
        ),
        onTap: () {
          Product.showList(
              context: context,
              cateId: "Z2lkOi8vc2hvcGlmeS9Db2xsZWN0aW9uLzE1OTA5NTQ1NTc5MA==",
              cateName: "Wall Decor");
        },
      ),
    );

    return list;
  }
}
