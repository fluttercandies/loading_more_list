import 'package:extended_sliver/extended_sliver.dart';
import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://MultipleSliverDemo',
  routeName: 'MultipleSliver',
  description: 'Show how to build loading more multiple sliver list quickly',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 5,
  },
)
class MultipleSliverDemo extends StatefulWidget {
  @override
  _MultipleSliverDemoState createState() => _MultipleSliverDemoState();
}

class _MultipleSliverDemoState extends State<MultipleSliverDemo> {
  TuChongRepository listSourceRepository;
  TuChongRepository listSourceRepository1;
  TuChongRepository listSourceRepository2;
  @override
  void initState() {
    listSourceRepository = TuChongRepository(maxLength: 15);
    listSourceRepository1 = TuChongRepository(maxLength: 30);
    listSourceRepository2 = TuChongRepository(maxLength: 30);
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    listSourceRepository1.dispose();
    listSourceRepository2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingMoreCustomScrollView(
      rebuildCustomScrollView: true,
      slivers: <Widget>[
        ///SliverList
        LoadingMoreSliverList<TuChongItem>(SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository,
        )),
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: const Text('Next list'),
            color: Colors.blue,
            height: 50.0,
          ),
        ),

        ///SliverGrid
        LoadingMoreSliverList<TuChongItem>(
          SliverListConfig<TuChongItem>(
            itemBuilder: itemBuilder,
            sourceList: listSourceRepository1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
            ),
          ),
        ),
        SliverPinnedToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: const Text('Pinned Content'),
            color: Colors.blue,
            height: 50.0,
          ),
        ),

        ///SliverWaterfallFlow
        LoadingMoreSliverList<TuChongItem>(
          SliverListConfig<TuChongItem>(
            itemBuilder: buildWaterfallFlowItem,
            sourceList: listSourceRepository2,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            extendedListDelegate:
                const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
          ),
        ),
      ],
    );
  }
}
