import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/flutter_admin_scaffold.dart';
import 'package:flutter_web_router/flutter_web_router.dart';
import 'package:flutter_web_router_example/sample_pages/dashboard_page.dart';
import 'package:flutter_web_router_example/sample_pages/forbidden_page.dart';
import 'package:flutter_web_router_example/sample_pages/internal_error_page.dart';
import 'package:flutter_web_router_example/sample_pages/item_list_page.dart';
import 'package:flutter_web_router_example/sample_pages/item_view_page.dart';
import 'package:flutter_web_router_example/sample_pages/login_page.dart';
import 'package:flutter_web_router_example/sample_pages/not_found_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // generate onGenerateRoute

    final router = WebRouter();

    // add error routes
    router.addForbiddenRoute((request) => ForbiddenPage());
    router.addNotFoundRoute((request) => NotFoundPage());
    router.addInternalErrorRoute((request) => InternalErrorPage());

    // add page routes
    router.addRoute(Constants.routeLogin, (request) => LoginPage());
    router.addRoute(Constants.routeDashboard, (request) => DashboardPage());
    router.addRoute(Constants.routeItemsList, (request) => ItemListPage());
    router.addRoute(
        Constants.routeItemsView, (request) => ItemViewPage(request: request));

    // add filters
    router.addFilter(LoginVerificationFilter());

    // set OnComplete handler
    router.setOnComplete((settings, widget) {
      // fade transition
      return PageRouteBuilder(
        settings: settings,
        pageBuilder: (_, __, ___) => widget,
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: child,
          );
        },
      );
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: router.build(),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({
    Key key,
    @required this.route,
    @required this.body,
  }) : super(key: key);

  final Widget body;
  final String route;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sample'),
      ),
      sidebar: Sidebar(
        itemDatas: Constants.sidebarMenuItem,
        selectedRoute: route,
        onSelected: (itemData) {
          print(
              'sidebar: onTap(): title = ${itemData.title}, route = ${itemData.route}');
          if (itemData.route != null) {
            Navigator.of(context).pushNamed(itemData.route);
          }
        },
      ),
      body: body,
    );
  }
}

///
/// Constants
///
class Constants {
  /// title
  static const titleDashboard = 'Dashboard';
  static const titleLogin = 'Login';
  static const titleItemsList = 'Item List';
  static const titleItemsView = 'Item View';

  /// route
  static const routeDashboard = '/';
  static const routeLogin = '/login';
  static const routeItemsList = '/items/index';
  static const routeItemsView = '/items/view/{itemId}';

  /// sidebar menu
  static const sidebarMenuItem = [
    MenuItemData(
      title: titleDashboard,
      route: routeDashboard,
      icon: Icons.dashboard,
    ),
    MenuItemData(
      title: 'Item',
      icon: Icons.file_copy,
      children: [
        MenuItemData(
          title: titleItemsList,
          route: routeItemsList,
        ),
      ],
    ),
  ];
}

///
/// Example Filter
/// Must implements [WebFilter]
///
class LoginVerificationFilter implements WebFilter {
  LoginVerificationFilter();

  /// If not login, return false.
  bool _isLogin = true;

  @override
  Widget execute(WebFilterChain filterChain) {
    final requestPath = Uri.parse(filterChain.settings.name).path;

    if (_isLogin) {
      // ok, goto next filter.
      return filterChain.executeNextFilter();
    }

    // no login

    // if request path is login, goto next filter.
    final request =
        WebRequest.settings(filterChain.settings, route: Constants.routeLogin);
    if (request.verify) {
      return filterChain.executeNextFilter();
    }

    // if request path is root, redirect login page.
    if (requestPath == '/') {
      throw RedirectWebRouterException(
          settings: RouteSettings(name: Constants.routeLogin));
    }

    // show not found page
    throw NotFoundWebRouterException();
  }
}
