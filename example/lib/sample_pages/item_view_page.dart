import 'package:flutter/material.dart';
import 'package:flutter_web_router/flutter_web_router.dart';
import 'package:flutter_web_router_example/main.dart';

class ItemViewPage extends StatelessWidget {
  ItemViewPage({
    Key? key,
    required this.request,
  }) : super(key: key);

  final WebRequest request;

  @override
  Widget build(BuildContext context) {
    final itemId = request.data!['itemId'];
    return MyScaffold(
      route: Constants.routeItemsList,
      body: Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              Constants.titleItemsView,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 36,
              ),
            ),
            SizedBox(height: 20),
            Text('itemId = $itemId'),
          ],
        ),
      ),
    );
  }
}
