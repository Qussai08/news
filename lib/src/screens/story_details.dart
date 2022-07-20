// @dart = 2.9

import 'package:flutter/material.dart';
import 'package:news/src/widgets/comment.dart';
import '../blocs/comments_provider.dart';
import '../models/item_model.dart';

class StoryDetails extends StatelessWidget {
  final int itemId;

  StoryDetails({this.itemId});

  Widget build(context) {
    final bloc = CommentsProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return const Text('Loading');
        }

        final itemFuture = snapshot.data[itemId];

        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return const Text('Loading');
            }

            return buildList(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      alignment: Alignment.topCenter,
      margin: const EdgeInsets.all(8.0),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildList(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final children = <Widget>[];
    children.add(buildTitle(item));

    final commentsList = item.kids.map(
      (kidId) {
        return Comment(
          itemId: kidId,
          itemMap: itemMap,
          depth: 0,
        );
      },
    ).toList();

    children.addAll(commentsList);
    return ListView(
      children: children,
    );
  }
}
