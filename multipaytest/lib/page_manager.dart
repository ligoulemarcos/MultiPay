import 'package:flutter/material.dart';
import 'package:multipaytest/home_page.dart';
import 'package:multipaytest/page_args.dart';
import 'package:multipaytest/page_names.dart';

class PageManager {
  static final PageManager _instance = PageManager._constructor();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  PageNames? currentPage;

  factory PageManager() {
    return _instance;
  }

  PageNames? getPageNameEnum(String? pageName) {
    try {
      return PageNames.values.where((x) => x.toString() == pageName).single;
    } catch (e) {}

    return null;
  }

  PageManager._constructor();

  MaterialPageRoute? getRoute(RouteSettings settings) {
    PageArgs? arguments;

    if (settings.arguments != null) {
      arguments = settings.arguments as PageArgs;
    }

    PageNames? page = getPageNameEnum(settings.name);

    currentPage = page;
    switch (page) {
      case PageNames.home:
        return MaterialPageRoute(builder: (context) => HomePage(arguments));
      default:
        break;
    }
  }

  _goPage(String pageName,
      {PageArgs? args,
      Function(PageArgs? args)? actionBack,
      bool makeRootPage = false}) {
    if (!makeRootPage) {
      return navigatorKey.currentState
          ?.pushNamed(pageName, arguments: args)
          .then((value) {
        if (actionBack != null) {
          actionBack(value != null ? (value as PageArgs) : null);
        }
      });
    } else {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
          pageName, (route) => false,
          arguments: args);
    }
  }

  goBack({PageArgs? args, PageNames? specificPage}) {
    if (specificPage != null) {
      navigatorKey.currentState!
          .popAndPushNamed(specificPage.toString(), arguments: args);
    } else {
      Navigator.pop(navigatorKey.currentState!.overlay!.context, args);
    }
  }

  goHome({PageArgs? args, Function(PageArgs? args)? actionBack}) {
    PageManager()._goPage(
      PageNames.home.toString(),
      args: args,
      actionBack: actionBack,
      makeRootPage: true,
    );
  }

  //Popup
}
