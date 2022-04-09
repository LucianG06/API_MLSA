import 'dart:convert';

import 'package:api/photo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photos',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Photos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Photo>> photos;

  Future<List<Photo>> fetchPhotos() async {
    const String _endpointUrl = 'https://jsonplaceholder.typicode.com/photos';
    final Uri _uri = Uri.parse(_endpointUrl);
    final http.Response response = await http.get(_uri);
    if (response.statusCode == 200) {
      final List<dynamic> _photosJson = jsonDecode(response.body);
      List<Photo> _photos =
          _photosJson.map((photo) => Photo.fromJson(photo)).toList();
      return _photos;
    } else {
      throw Exception('Get photos exception!!!');
    }
  }

  @override
  void initState() {
    super.initState();
    photos = fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: photos,
        builder: (BuildContext context, AsyncSnapshot<List<Photo>> snapshot) {
          if (snapshot.hasData) {
            List<Photo> data = snapshot.data!;
            return Scrollbar(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 16,
                  );
                },
                itemCount: 200,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: index == data.length - 1
                        ? const EdgeInsets.fromLTRB(8, 0, 8, 0)
                        : const EdgeInsets.only(left: 8),
                    child: Text(
                      data[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text("--${snapshot.error}--");
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
