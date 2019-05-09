import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final shibeAmount = 10;

Future<ShibeList> fetchShibes() async {
  final response =
      await http.get("https://shibe.online/api/shibes?count=${shibeAmount}");
  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return ShibeList.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load shibes :(');
  }
}

class ShibeList {
  final List<dynamic> shibes;

  ShibeList({ this.shibes });

  factory ShibeList.fromJson(List<dynamic> parsedJson) {
    return ShibeList(shibes: parsedJson);
  }
}

void main() => runApp(MyApp(shibes: fetchShibes()));

class MyApp extends StatelessWidget {
  final Future<ShibeList> shibes;


  MyApp({Key key, this.shibes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Shibes',
      theme: ThemeData( 
        primaryColor: Colors.amber,
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.white),
        )
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("🐕 Awesome Shibes 🐕")),
        body: Center(child: FutureBuilder<ShibeList>(
          future: shibes,
          builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: shibeAmount,
                  itemBuilder: (context, i) {
                    return _buildShibe(snapshot.data.shibes[i]);
                  }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return CircularProgressIndicator();
          
          },
        )
      )
    ));
  }


  Widget _buildShibe(String shibeSrc) {
    return ListTile(
      title: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Image.network(
          shibeSrc,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
