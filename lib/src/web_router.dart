import 'package:flutter/material.dart';

import 'web_filter.dart';
import 'web_request.dart';

///
/// WebRouter
///
class WebRouter {
  Map<String, WebRouterWidgetBuilder> _routes = {};
  WebFilterChain _filterChain = WebFilterChain();
  WebRouterOnComplete? onComplete;

  ///
  /// add Route
  ///
  WebRouter addRoute(String route, WebRouterWidgetBuilder builder) {
    _routes[route] = builder;
    return this;
  }

  ///
  /// add Forbidden Route
  ///
  WebRouter addForbiddenRoute(WebRouterWidgetBuilder builder) {
    return addRoute('403', builder);
  }

  ///
  /// add Not Found Route
  ///
  WebRouter addNotFoundRoute(WebRouterWidgetBuilder builder) {
    return addRoute('404', builder);
  }

  ///
  /// add Internal Error Route
  ///
  WebRouter addInternalErrorRoute(WebRouterWidgetBuilder builder) {
    return addRoute('500', builder);
  }

  ///
  /// add Filter
  ///
  WebRouter addFilter(WebFilter filter) {
    _filterChain.addFilter(filter);
    return this;
  }

  ///
  /// set OnComplete
  ///
  WebRouter setOnComplete(WebRouterOnComplete? onComplete) {
    this.onComplete = onComplete;
    return this;
  }

  RouteFactory build() {
    _filterChain.routes = _routes;

    return (RouteSettings settings) {
      final widget = _filterChain.execute(settings);
      if (widget != null) {
        if (onComplete != null) {
          return onComplete!(_filterChain.settings, widget);
        }

        // default
        return MaterialPageRoute(
          settings: _filterChain.settings,
          builder: (_) => widget,
        );
      }

      return null;
    };
  }
}

///
/// OnComplete Function
///
typedef WebRouterOnComplete = Route<dynamic> Function(
    RouteSettings settings, Widget widget);

///
/// WidgetBuilder Function
///
typedef WebRouterWidgetBuilder = Widget Function(WebRequest request);
