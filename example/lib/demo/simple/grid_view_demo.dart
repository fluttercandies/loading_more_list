import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://GridViewDemo',
  routeName: 'GridView',
  description: 'Show how to build loading more GridView quickly',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 1,
  },
)
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
    return LoadingMoreList<TuChongItem>(
      ListConfig<TuChongItem>(
        itemBuilder: itemBuilder,
        sourceList: listSourceRepository,
        padding: const EdgeInsets.all(0.0),
        lastChildLayoutType: LastChildLayoutType.foot,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 3.0,
          mainAxisSpacing: 3.0,
        ),
      ),
    );
  }
}
