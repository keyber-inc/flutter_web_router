import 'package:flutter/material.dart';

import 'web_request.dart';
import 'web_router.dart';

///
/// WebFilter
///
abstract class WebFilter {
  Widget? execute(WebFilterChain filterChain);
}

///
/// WebFilterChain
///
class WebFilterChain {
  static final redirectMaxCount = 5;
  int redirectCount = 0;

  late RouteSettings _settings;
  RouteSettings get settings => _settings;

  late Map<String, WebRouterWidgetBuilder> routes;

  List<WebFilter> _filters = [];
  late WebFilterIterator _filterIterator;

  void addFilter(WebFilter filter) {
    _filters.add(filter);
  }

  Widget? execute(RouteSettings settings) {
    _settings = settings;
    _filterIterator = WebFilterIterator(_filters);
    return _execute(_filterIterator.next);
  }

  Widget? executeNextFilter() {
    return _execute(_filterIterator.next);
  }

  Widget? _execute(WebFilter? filter) {
    try {
      if (filter != null) {
        return filter.execute(this);
      }

      // create widget
      final routes = this.routes.keys.toList();
      for (String route in routes) {
        final request = WebRequest.settings(_settings, route: route);
        if (request.verify) {
          return this.routes[route]!(request);
        }
      }

      // not found page
      throw NotFoundWebRouterException();
    } on RedirectWebRouterException catch (e) {
      if (redirectCount >= redirectMaxCount) {
        // redirect error
        throw InternalErrorWebRouterException();
      }

      // redirect
      redirectCount++;
      return execute(e.settings);
    } on WebRouterException catch (e) {
      if (routes.containsKey(e.code)) {
        return routes[e.code]!(WebRequest.settings(settings));
      }
    }

    // internal error
    if (routes.containsKey('500')) {
      return routes['500']!(WebRequest.settings(settings));
    }
    return null;
  }
}

///
/// WebFilterIterator
///
class WebFilterIterator implements Iterator<WebFilter> {
  WebFilterIterator(this._filters);

  final List<WebFilter> _filters;
  int _index = 0;

  @override
  bool moveNext() {
    if ((_index + 1) < _filters.length) {
      _index++;
      return true;
    }
    return false;
  }

  @override
  WebFilter get current {
    if (0 <= _index && _index < _filters.length) {
      return _filters[_index];
    }
    throw Exception();
  }

  WebFilter? get next => moveNext() ? current : null;
}

///
/// 301 Redirect Exception
///
class RedirectWebRouterException extends WebRouterException {
  const RedirectWebRouterException({
    String message = '301 Moved Permanently',
    required this.settings,
  }) : super(
          message: message,
          code: '301',
        );

  final RouteSettings settings;
}

///
/// 403 Forbidden Exception
///
class ForbiddenWebRouterException extends WebRouterException {
  const ForbiddenWebRouterException({
    String message = '403 Forbidden',
  }) : super(
          message: message,
          code: '403',
        );
}

///
/// 404 Not Found Exception
///
class NotFoundWebRouterException extends WebRouterException {
  const NotFoundWebRouterException({
    String message = '404 Not Found',
  }) : super(
          message: message,
          code: '404',
        );
}

///
/// 500 Internal Error Exception
///
class InternalErrorWebRouterException extends WebRouterException {
  const InternalErrorWebRouterException({
    String message = '500 Internal Error',
  }) : super(
          message: message,
          code: '500',
        );
}

///
/// Base Exception
///
class WebRouterException implements Exception {
  const WebRouterException({
    required this.message,
    required this.code,
  }) : super();

  final String code;
  final String message;

  @override
  String toString() {
    return "[$code] $message";
  }
}
