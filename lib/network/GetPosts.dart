import 'dart:convert';
import 'package:flutter_demo/models/PostResponse.dart';
import 'package:http/http.dart' as http;

class APIcalls {
  static Future<List<Post>> fetchPost() async {
//  final response =
//  await http.get('https://jsonplaceholder.typicode.com/posts');

    var response = await http.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {

      // If the call to the server was successful, parse the JSON.
      Iterable list = json.decode(response.body);
      var mPost = list.map((model) => Post.fromJson(model)).toList();

      return mPost;
//    return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
