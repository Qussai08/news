// @dart = 2.9

import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
        if (!itemSnapshot.hasData) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0 * depth.toDouble()),
            child: LoadingContainer(),
          );
        }

        final children = <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(
                left: 16.0 + 16.0 * depth.toDouble(), right: 16.0),
            title: buildText(itemSnapshot.data),
            subtitle: itemSnapshot.data.by == ""
                ? const Text('This comment has been deleted')
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      itemSnapshot.data.by,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
          const Divider(),
        ];

        itemSnapshot.data.kids.forEach(
          (kidId) {
            children.add(
              Comment(
                itemId: kidId,
                itemMap: itemMap,
                depth: depth + 1,
              ),
            );
          },
        );

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text
        .replaceAll('&#x27;', "'")
        .replaceAll('<p>', '\n\n')
        .replaceAll('</p>>', '')
        .replaceAll('&gt;', '');
    return Text(text);
  }
}
