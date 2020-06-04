import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: 'fluttercandies://SliverListDemo',
    routeName: 'SliverList',
    description: 'Show how to build loading more SliverList quickly')
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
    return Material(
      child: LoadingMoreCustomScrollView(
        showGlowLeading: false,
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            title: Text('SliverListDemo'),
          ),
          LoadingMoreSliverList<TuChongItem>(SliverListConfig<TuChongItem>(
            itemBuilder: itemBuilder,
            sourceList: listSourceRepository,
            //isLastOne: false
          ))
        ],
      ),
    );
  }
}
