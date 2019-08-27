import 'dart:io';

import 'package:example/demo/custom_indicator_demo.dart';
import 'package:example/demo/grid_view_demo.dart';
import 'package:example/demo/list_view_demo.dart';
import 'package:example/demo/multiple_sliver_demo.dart';
import 'package:example/demo/nested_scroll_view_demo.dart';
import 'package:example/demo/sliver_grid_demo.dart';
import 'package:example/demo/sliver_list_demo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'demo/no_route.dart';
import 'example_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {}
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (c, w) {
          var data = MediaQuery.of(c);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: w,
          );
        },
        initialRoute: "fluttercandies://mainpage",
        onGenerateRoute: (RouteSettings settings) {
          var routeResult = getRouteResult(
              name: settings.name, arguments: settings.arguments);

          var page = routeResult.widget ?? NoRoute();

          return Platform.isIOS
              ? CupertinoPageRoute(settings: settings, builder: (c) => page)
              : MaterialPageRoute(settings: settings, builder: (c) => page);
        });
  }
}
