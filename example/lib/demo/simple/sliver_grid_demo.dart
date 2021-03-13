import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';


import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://SliverGridDemo',
  routeName: 'SliverGrid',
  description: 'Show how to build loading more SilverGird quickly',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 4,
  },
)
class SliverGridDemo extends StatefulWidget {
  @override
  _SliverGridDemoState createState() => _SliverGridDemoState();
}

class _SliverGridDemoState extends State<SliverGridDemo> {
 late TuChongRepository listSourceRepository;
  @override
  void initState() {
    listSourceRepository = TuChongRepository();
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
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
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
          //isLastOne: false
        ))
      ],
    );
  }
}
