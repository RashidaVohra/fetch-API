import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('API Calling'),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future? myFuture;
  bool loading = false;
  var myData = [];
  Future<List> fetchData() async {
    setState(() {
      loading = true;
    });
    try {
      var url = Uri.https('reqres.in', 'api/users');
      var response = await http.get(url);
      setState(() {
        loading = false;
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      //myData = json.decode(response.body);
      Map<String, dynamic> mymap = json.decode(response.body);
      myData = mymap["data"];
      //myData = mymap["page"];
      return myData;
    } catch (error) {
      setState(() {
        loading = false;
      });
      throw error;
    }
  }

  @override
  void initState() {
    myFuture = fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: myFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something is wrong'),
          );
        }
        return Scaffold(
          body: ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.network(snapshot.data[index]['avatar']),
                  title: Text(snapshot.data[index]['first_name'].toString()),
                  subtitle: Text(snapshot.data[index]['last_name'].toString()),
                ),
              );
            },
          ),
        );
      },
    );
  }
}