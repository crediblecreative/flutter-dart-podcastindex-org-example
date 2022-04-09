import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

Future<PodCastIndex> fetchPodCastIndex() async {
  var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
  String newUnixTime = unixTime.toString();
  // Change to your API key...
  var apiKey = "ABC";
  // Change to your API secret...
  var apiSecret = "ABC";
  var firstChunk = utf8.encode(apiKey);
  var secondChunk = utf8.encode(apiSecret);
  var thirdChunk = utf8.encode(newUnixTime);

  var output = new AccumulatorSink<Digest>();
  var input = sha1.startChunkedConversion(output);
  input.add(firstChunk);
  input.add(secondChunk);
  input.add(thirdChunk);
  input.close();
  var digest = output.events.single;

  Map<String, String> headers = {
    "X-Auth-Date": newUnixTime,
    "X-Auth-Key": apiKey,
    "Authorization": digest.toString(),
    "User-Agent": "SomethingAwesome/1.0.1"
  };

  final response = await http.get(
      Uri.parse('https://api.podcastindex.org/api/1.0/search/byterm?q=bastiat'),
      headers: headers);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PodCastIndex.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class PodCastIndex {
  final String content;

  PodCastIndex({this.content});

  factory PodCastIndex.fromJson(Map<String, dynamic> json) {
    debugPrint(json.toString());
    return PodCastIndex(content: json.toString());
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<PodCastIndex> futurePodCastIndex;

  @override
  void initState() {
    super.initState();
    futurePodCastIndex = fetchPodCastIndex();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Podcast Listing JSON',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Podcast Listing JSON'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<PodCastIndex>(
            future: futurePodCastIndex,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.content);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
