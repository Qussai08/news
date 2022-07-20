// @dart = 2.9
import 'dart:convert';
import 'package:http/http.dart' show Client;
import '../models/item_model.dart';
import 'dart:async';
import 'repository.dart';

const _root = 'https://hacker-news.firebaseio.com/v0';

class NewsApiProvider implements Source {
  Client client = Client();

  @override
  Future<List<int>> fetchTopIds() async {
    final response =
        await client.get(Uri.parse('$_root/topstories.json?print=pretty'));

    final ids = json.decode(response.body).cast<int>();
    return ids;
  }

  @override
  Future<ItemModel> fetchItem(int id) async {
    final response =
        await client.get(Uri.parse('$_root/item/$id.json?print=pretty'));
    final item = json.decode(response.body);
    return ItemModel.fromJson(item);
  }
}
