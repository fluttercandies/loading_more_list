import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://SliverListDemo',
  routeName: 'SliverList',
  description: 'Show how to build loading more SliverList quickly',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 3,
  },
)
class SliverListDemo extends StatefulWidget {
  @override
  _SliverListDemoState createState() => _SliverListDemoState();
}

class _SliverListDemoState extends State<SliverListDemo> {
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
    return LoadingMoreCustomScrollView(
      showGlowLeading: false,
      rebuildCustomScrollView: true,
      slivers: <Widget>[
        LoadingMoreSliverList<TuChongItem>(SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository,
          //isLastOne: false
          //autoRefresh: false,
        ))
      ],
    );
  }
}
