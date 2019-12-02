import 'package:example/common/item_builder.dart';
import 'package:example/common/tu_chong_repository.dart';
import 'package:example/common/tu_chong_source.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:extended_image_library/extended_image_library.dart';

@FFRoute(
    name: "fluttercandies://ListViewDemo",
    routeName: "ListView",
    description: "Show how to build loading more ListView quickly")
class ListViewDemo extends StatefulWidget {
  @override
  _ListViewDemoState createState() => _ListViewDemoState();
}

class _ListViewDemoState extends State<ListViewDemo> {
  TuChongRepository listSourceRepository;
  @override
  void initState() {
    listSourceRepository = new TuChongRepository();
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
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("ListViewDemo"),
          ),
          Expanded(
            child: LoadingMoreList(
              ListConfig<TuChongItem>(
                itemBuilder: ItemBuilder.itemBuilder,
                sourceList: listSourceRepository,
//                    showGlowLeading: false,
//                    showGlowTrailing: false,
                padding: EdgeInsets.all(0.0),
                collectGarbage: (List<int> indexes) {
                  ///collectGarbage
                  indexes.forEach((index) {
                    final item = listSourceRepository[index];
                    if (item.hasImage) {
                      final provider = ExtendedNetworkImageProvider(
                        item.imageUrl,
                      );
                      provider.evict();
                    }
                  });
                },
                viewportBuilder: (int firstIndex, int lastIndex) {
                  print("viewport : [$firstIndex,$lastIndex]");
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
