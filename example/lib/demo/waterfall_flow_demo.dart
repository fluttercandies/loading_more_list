import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: 'fluttercandies://WaterfallFlowDemo',
    routeName: 'WaterfallFlow',
    description: 'Show how to build loading more WaterfallFlow quickly')
class WaterfallFlowDemo extends StatefulWidget {
  @override
  _WaterfallFlowDemoState createState() => _WaterfallFlowDemoState();
}

class _WaterfallFlowDemoState extends State<WaterfallFlowDemo> {
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
            title: const Text('WaterfallFlowDemo'),
          ),
          Expanded(
            child: LayoutBuilder(builder: (BuildContext c, BoxConstraints data) {
              final int crossAxisCount = max(
                  data.maxWidth ~/ (ScreenUtil.instance.screenWidthDp / 2.0),
                  2);
              return LoadingMoreList<TuChongItem>(
                ListConfig<TuChongItem>(
                  waterfallFlowDelegate: WaterfallFlowDelegate(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: buildWaterfallFlowItem,
                  sourceList: listSourceRepository,
                  padding: const EdgeInsets.all(5.0),
                  lastChildLayoutType: LastChildLayoutType.foot,
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
