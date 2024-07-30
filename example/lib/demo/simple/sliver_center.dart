import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://SliverCenterDemo',
  routeName: 'SliverCenter',
  description: 'Show how to use LoadingMoreCustomScrollView center sliver',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 6,
  },
)
class SliverCenterDemo extends StatefulWidget {
  @override
  _SliverCenterDemoState createState() => _SliverCenterDemoState();
}

class _SliverCenterDemoState extends State<SliverCenterDemo> {
  late TuChongRepository listSourceRepository;
  late TuChongRepository listSourceRepository1;
  late TuChongRepository listSourceRepository2;
  late TuChongRepository listSourceRepository3;
  final Key _centerKey = const ValueKey<String>('center-sliver');
  @override
  void initState() {
    listSourceRepository = TuChongRepository(maxLength: 20);
    listSourceRepository1 = TuChongRepository(maxLength: 20);
    listSourceRepository2 = TuChongRepository(maxLength: 20);
    listSourceRepository3 = TuChongRepository(maxLength: 20);
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    listSourceRepository1.dispose();
    listSourceRepository2.dispose();
    listSourceRepository3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingMoreCustomScrollView(
      showGlowLeading: false,
      center: _centerKey,
      slivers: <Widget>[
        LoadingMoreSliverList<TuChongItem>(SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        )),
        LoadingMoreSliverList<TuChongItem>(
          SliverListConfig<TuChongItem>(
            itemBuilder: itemBuilder,
            sourceList: listSourceRepository1,
          ),
        ),
        SliverToBoxAdapter(
          key: _centerKey,
          child: Container(
            height: 50,
            color: Colors.blue,
            alignment: Alignment.center,
            child: const Text(
              'Center Sliver',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        LoadingMoreSliverList<TuChongItem>(
          SliverListConfig<TuChongItem>(
            itemBuilder: itemBuilder,
            sourceList: listSourceRepository2,
          ),
        ),
        LoadingMoreSliverList<TuChongItem>(SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository3,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300.0,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        )),
      ],
    );
  }
}
