import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: "fluttercandies://SliverGridDemo",
    routeName: "SliverGrid",
    description: "Show how to build loading more SilverGird quickly")
class SliverGridDemo extends StatefulWidget {
  @override
  _SliverGridDemoState createState() => _SliverGridDemoState();
}

class _SliverGridDemoState extends State<SliverGridDemo> {
  TuChongRepository listSourceRepository;
  @override
  void initState() {
    listSourceRepository = new TuChongRepository();
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(builder: (c, data) {
        final crossAxisCount =
            max(data.maxWidth ~/ (ScreenUtil.instance.screenWidthDp / 2.0), 2);
        return LoadingMoreCustomScrollView(
          showGlowLeading: false,
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              title: Text("SliverGridDemo"),
            ),
            LoadingMoreSliverList(SliverListConfig<TuChongItem>(
              itemBuilder: itemBuilder,
              sourceList: listSourceRepository,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
//                    childAspectRatio: 0.5
              ),
              //isLastOne: false
            ))
          ],
        );
      }),
    );
  }
}
