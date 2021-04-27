import 'package:flutter/material.dart';
import 'package:flutter_web_router/flutter_web_router.dart';
import 'package:flutter_web_router_example/main.dart';

class ItemListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      route: Constants.routeItemsList,
      body: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              Constants.titleItemsList,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('View Item 1'),
              onPressed: () async {
                final request = WebRequest.request(
                  Constants.routeItemsView,
                  data: {
                    'itemId': '1',
                  },
                );
                await Navigator.of(context).pushNamed(
                  request.uri.toString(),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('View Item 2'),
              onPressed: () async {
                final request = WebRequest.request(
                  Constants.routeItemsView,
                  data: {
                    'itemId': '2',
                  },
                );
                await Navigator.of(context).pushNamed(
                  request.uri.toString(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
