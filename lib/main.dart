import 'package:empty_my_bin/src/pages/BinDetail.dart';
import 'package:empty_my_bin/src/pages/HomePage.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, WidgetBuilder> routes = {
    '/': (BuildContext c) => new HomePage(),
  };
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Empty my bin',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: routes,
    );
  }
}

