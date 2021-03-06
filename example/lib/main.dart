import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'example_route.dart';
import 'example_route_helper.dart';
import 'example_routes.dart';
import 'utils/screen_util.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (BuildContext c, Widget w) {
        ScreenUtil.init(width: 750, height: 1334, allowFontScaling: true);
        // ScreenUtil.instance =
        //     ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
        //       ..init(c);
        if (!kIsWeb) {
          final MediaQueryData data = MediaQuery.of(c);
          return MediaQuery(
            data: data.copyWith(textScaleFactor: 1.0),
            child: w,
          );
        }
        return w;
      },
      initialRoute: Routes.fluttercandiesMainpage,
      onGenerateRoute: (RouteSettings settings) {
        return onGenerateRouteHelper(settings,
            builder: (Widget child, RouteResult result) {
          if (settings.name == Routes.fluttercandiesMainpage ||
              settings.name == Routes.fluttercandiesDemogrouppage ||
              settings.name == Routes.fluttercandiesNestedScrollViewDemo) {
            return child;
          }
          return CommonWidget(
            child: child,
            result: result,
          );
        });
      },
    );
  }
}

class CommonWidget extends StatelessWidget {
  const CommonWidget({
    this.child,
    this.result,
  });
  final Widget child;
  final RouteResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          result.routeName,
        ),
      ),
      body: child,
    );
  }
}
