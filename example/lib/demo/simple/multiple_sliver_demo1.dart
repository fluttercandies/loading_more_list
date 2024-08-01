import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://MultipleSliverDemo1',
  routeName: 'MultipleSliver1',
  description:
      'Show how to build loading more multiple sliver list quickly, and support LoadingMoreCustomScrollView.slivers are not a direct LoadingMoreSliverList',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 7,
  },
)
class MultipleSliverDemo1 extends StatefulWidget {
  @override
  _MultipleSliverDemo1State createState() => _MultipleSliverDemo1State();
}

class _MultipleSliverDemo1State extends State<MultipleSliverDemo1> {
  late TuChongRepository listSourceRepository;
  late TuChongRepository listSourceRepository1;

  @override
  void initState() {
    listSourceRepository = TuChongRepository(maxLength: 20);
    listSourceRepository1 = TuChongRepository(maxLength: 20);

    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    listSourceRepository1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingMoreCustomScrollView(
      // support LoadingMoreCustomScrollView.slivers are not a direct LoadingMoreSliverList
      getConfigFromSliverContext: true,
      slivers: <Widget>[
        LoadingMoreSliverList<TuChongItem>(
          SliverListConfig<TuChongItem>(
            itemBuilder: itemBuilder,
            sourceList: listSourceRepository,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: const Text('MyLoadingMoreSliverList'),
            color: Colors.green,
            height: 50.0,
          ),
        ),
        const MyLoadingMoreSliverList(),
        SliverToBoxAdapter(
          child: Container(
            alignment: Alignment.center,
            child: const Text('MyLoadingMoreSliverList1'),
            color: Colors.red,
            height: 50.0,
          ),
        ),
        MyLoadingMoreSliverList1(
          listSourceRepository: listSourceRepository1,
        )
      ],
    );
  }
}

class MyLoadingMoreSliverList extends StatefulWidget {
  const MyLoadingMoreSliverList({Key? key}) : super(key: key);

  @override
  State<MyLoadingMoreSliverList> createState() =>
      _MyLoadingMoreSliverListState();
}

class _MyLoadingMoreSliverListState extends State<MyLoadingMoreSliverList> {
  late TuChongRepository listSourceRepository;

  @override
  void initState() {
    super.initState();
    listSourceRepository = TuChongRepository(maxLength: 20);
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(50),
      sliver: LoadingMoreSliverList<TuChongItem>(
        SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository,
        ),
      ),
    );
  }
}

class MyLoadingMoreSliverList1 extends StatelessWidget {
  const MyLoadingMoreSliverList1({
    Key? key,
    required this.listSourceRepository,
  }) : super(key: key);

  final TuChongRepository listSourceRepository;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(50),
      sliver: LoadingMoreSliverList<TuChongItem>(
        SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.0,
            mainAxisSpacing: 3.0,
          ),
        ),
      ),
    );
  }
}
