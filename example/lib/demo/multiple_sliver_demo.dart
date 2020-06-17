import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: 'fluttercandies://MultipleSliverDemo',
    routeName: 'MultipleSliver',
    description: 'Show how to build loading more multiple sliver list quickly')
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
    return Material(
      child: LoadingMoreCustomScrollView(
        slivers: <Widget>[
          const SliverAppBar(
            pinned: true,
            title: Text('MultipleSliverDemo'),
          ),

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
              height: 100.0,
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
          SliverPersistentHeader(
            delegate: CommonExtentSliverPersistentHeaderDelegate(
                Container(
                  alignment: Alignment.center,
                  child: const Text('Pinned Content'),
                  color: Colors.red,
                ),
                100.0),
            pinned: true,
          ),

          ///SliverWaterfallFlow
          LoadingMoreSliverList<TuChongItem>(
            SliverListConfig<TuChongItem>(
              itemBuilder: buildWaterfallFlowItem,
              sourceList: listSourceRepository2,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              extendedListDelegate: const SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommonExtentSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  CommonExtentSliverPersistentHeaderDelegate(this.child, this.extent);
  final Widget child;
  final double extent;

  @override
  double get minExtent => extent;

  @override
  double get maxExtent => extent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(CommonExtentSliverPersistentHeaderDelegate oldDelegate) {
    //print('shouldRebuild---------------');
    return oldDelegate != this;
  }
}
