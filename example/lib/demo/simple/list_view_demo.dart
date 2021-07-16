import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://ListViewDemo',
  routeName: 'ListView',
  description: 'Show how to build loading more ListView quickly',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 0,
  },
)
class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
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
    return LoadingMoreList<TuChongItem>(
      ListConfig<TuChongItem>(
        itemBuilder: itemBuilder,
        sourceList: listSourceRepository,
        physics: const FixedOverscrollBouncingScrollPhysics(),
//                    showGlowLeading: false,
//                    showGlowTrailing: false,
        padding: const EdgeInsets.all(0.0),
        extendedListDelegate: ExtendedListDelegate(
          collectGarbage: (List<int> indexes) {
            ///collectGarbage
          },
          // viewportBuilder: (int firstIndex, int lastIndex) {
          //   print('viewport : [$firstIndex,$lastIndex]');
          // },
        ),
        //autoRefresh: false,
      ),
    );
  }
}
