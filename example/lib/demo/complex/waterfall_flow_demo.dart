import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://WaterfallFlowDemo',
  routeName: 'WaterfallFlow',
  description: 'Show how to build loading more WaterfallFlow quickly',
  exts: <String, dynamic>{
    'group': 'Complex',
    'order': 0,
  },
)
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
    return LoadingMoreList<TuChongItem>(
      ListConfig<TuChongItem>(
        extendedListDelegate:
            const SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemBuilder: buildWaterfallFlowItem,
        sourceList: listSourceRepository,
        padding: const EdgeInsets.all(5.0),
        lastChildLayoutType: LastChildLayoutType.foot,
      ),
    );
  }
}
