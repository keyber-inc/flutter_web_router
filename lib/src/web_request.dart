import 'package:flutter/material.dart';

///
/// WebRequest
///
class WebRequest {
  WebRequest._({
    required this.settings,
    this.route,
    this.data,
  });

  ///
  /// from RouteSettings
  ///
  factory WebRequest.settings(
    RouteSettings settings, {
    String? route,
  }) {
    assert(settings.name != null);
    Map<String, String>? data = {};
    try {
      if (route == null) {
        throw Exception();
      }

      final requestPath = Uri.parse(settings.name!).path;
      final requestPaths =
          requestPath.split('/').where((path) => path.isNotEmpty).toList();
      final routePaths =
          route.split('/').where((path) => path.isNotEmpty).toList();

      if (requestPaths.length != routePaths.length) {
        throw Exception();
      }

      for (int i = 0; i < requestPaths.length; i++) {
        if (requestPaths[i] != routePaths[i]) {
          final match = RegExp(r'^\{(.+)\}$').firstMatch(routePaths[i]);
          if (match == null || match.groupCount == 0) {
            throw Exception();
          }
          final name = match.group(1);
          data[name!] = requestPaths[i];
        }
      }
    } catch (e) {
      route = null;
      data = null;
    }

    return WebRequest._(
      settings: settings,
      route: route,
      data: data,
    );
  }

  ///
  /// from Request path
  ///
  factory WebRequest.request(
    String route, {
    Map<String, String>? data,
    Map<String, String>? queryParameters,
    Object? arguments,
  }) {
    // build uri
    List<String> paths = [];
    route.split('/').forEach((path) {
      if (path.isNotEmpty) {
        if (data == null || data.length == 0) {
          paths.add(path);
        } else {
          final match = RegExp(r'^\{(.+)\}$').firstMatch(path);
          if (match != null && match.groupCount > 0) {
            final name = match.group(1);
            assert(data[name] != null);
            paths.add(data[name]!);
          } else {
            paths.add(path);
          }
        }
      }
    });

    final uri = Uri(
      path: '/' + paths.join('/'),
      queryParameters: queryParameters,
    );

    return WebRequest._(
      settings: RouteSettings(
        name: uri.toString(),
        arguments: arguments,
      ),
      route: route,
      data: data,
    );
  }

  final RouteSettings settings;
  final String? route;
  final Map<String, String>? data;

  Uri get uri => Uri.parse(settings.name!);
  bool get verify => route != null;
}
