// @dart=2.9

import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/${item.id}');
            },
            title: Text(item.title),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('${item.score} Votes'),
            ),
            trailing: Column(
              children: [
                const Icon(Icons.comment),
                Text('${item.descendants}'),
              ],
            ),
          ),
          const Divider(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
