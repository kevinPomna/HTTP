import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(HttpClienteDemo());
}

class Post {
  final int id;
  final String title;

  Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
    );
  }
}

class HttpClienteDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HttpClienteDemo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTTP Cliente Demo'),
        ),
        body: Center(
          child: FutureBuilder<List<Post>>(
            future: fetchPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar los datos');
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Future<List<Post>> fetchPosts() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Post> posts = data.sublist(0, 5).map((json) => Post.fromJson(json)).toList();
      return posts;
    } else {
      throw Exception('Error al cargar los datos');
    }
  }
}
