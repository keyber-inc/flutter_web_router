# flutter_web_router

A router that handles request URIs with wildcards and generate URIs with parameters.

## usage

1. Set up `WebRouter`

```dart
    final router = WebRouter();
```

If you want to show error pages, please add error pages.

```
    router.addForbiddenRoute((request) => ForbiddenPage());
    router.addNotFoundRoute((request) => NotFoundPage());
    router.addInternalErrorRoute((request) => InternalErrorPage());
```

Please add URIs of page. You can add URIs with wildcards.

```dart
    router.addRoute('/login', (request) => LoginPage());
    router.addRoute('/', (request) => DashboardPage());
    router.addRoute('items/index', (request) => ItemListPage());
    router.addRoute('items/view/{itemId}', (request) => ItemViewPage(request: request));
```

If you want to verify a user, please add filters.

`LoginVerificationFilter` is a sample class that implements `WebFilter` class.

```dart
    router.addFilter(LoginVerificationFilter());
```

Finally, you can set a transition.

```dart
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
```

2. set `router.build()` to `onGenerateRoute`

```dart
    return MaterialApp(
      ...
      onGenerateRoute: router.build(),
      ...
    );
```

3. navigate with `WebRequest`

If you want to request URIs used wildcards, use `WebRequest`.

```dart
    final request = WebRequest.request(
      'items/view/{itemId}',
      data: {
        'itemId': '1',
      },
    );
    await Navigator.of(context).pushNamed(
      request.uri.toString(),
    );
```
