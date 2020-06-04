import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: 'fluttercandies://GridViewDemo',
    routeName: 'GridView',
    description: 'Show how to build loading more GridView quickly')
class GridViewDemo extends StatefulWidget {
  @override
  _GridViewDemoState createState() => _GridViewDemoState();
}

class _GridViewDemoState extends State<GridViewDemo> {
  TuChongRepository listSourceRepository;
  @override
  void initState() {
    listSourceRepository = TuChongRepository();
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
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('GridViewDemo'),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext c, BoxConstraints data) {
                final int crossAxisCount = max(
                    data.maxWidth ~/ (ScreenUtil.instance.screenWidthDp / 2.0),
                    2);
                return LoadingMoreList<TuChongItem>(
                  ListConfig<TuChongItem>(
                    itemBuilder: itemBuilder,
                    sourceList: listSourceRepository,
                    padding: const EdgeInsets.all(0.0),
                    lastChildLayoutType: LastChildLayoutType.foot,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
