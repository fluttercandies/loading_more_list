import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

import 'package:loading_more_list/loading_more_list.dart';

import '../../data/tu_chong_repository.dart';
import '../../data/tu_chong_source.dart';
import '../../widget/item_builder.dart';

@FFRoute(
  name: 'fluttercandies://MultipleSliverDemo2',
  routeName: 'MultipleSliver2',
  description:
      'Show how to build loading more multiple sliver list quickly with SliveLoadingConfig and SliverConfig',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 8,
  },
)
class MultipleSliverDemo2 extends StatefulWidget {
  @override
  _MultipleSliverDemo2State createState() => _MultipleSliverDemo2State();
}

class _MultipleSliverDemo2State extends State<MultipleSliverDemo2> {
  late TuChongRepository listSourceRepository;
  late TuChongRepository listSourceRepository1;
  late TuChongRepository listSourceRepository2;
  late MySliverLoadingData loadingData;
  @override
  void initState() {
    listSourceRepository = TuChongRepository(maxLength: 15);
    listSourceRepository1 = TuChongRepository(maxLength: 30);
    listSourceRepository2 = TuChongRepository(maxLength: 30);
    loadingData = MySliverLoadingData();
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository.dispose();
    listSourceRepository1.dispose();
    listSourceRepository2.dispose();
    loadingData.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingMoreCustomScrollView(
      slivers: <Widget>[
        LoadingMoreSliverList<TuChongItem>(SliverListConfig<TuChongItem>(
          itemBuilder: itemBuilder,
          sourceList: listSourceRepository,
        )),

        LoadingMoreSliver(
          SliverConfig(
            builder: (BuildContext context) {
              return SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  child: const Text('Next list'),
                  color: Colors.blue,
                  height: 50.0,
                ),
              );
            },
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
        LoadingMoreLoadingSliver<int>(
          SliveLoadingConfig<int>(
              builder: (BuildContext context, int? data) {
                return SliverToBoxAdapter(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text('Loading Data$data'),
                    color: Colors.blue,
                    height: 50.0,
                  ),
                );
              },
              loadingData: loadingData,
              indicatorBuilder: (
                BuildContext context,
                IndicatorStatus status, {
                LoadingMoreBase<dynamic>? list,
              }) {
                // custom indicator base on your case
                if (status == IndicatorStatus.fullScreenBusying) {
                  return const SliverToBoxAdapter(
                    child: IndicatorWidget(
                      IndicatorStatus.loadingMoreBusying,
                    ),
                  );
                } else if (status == IndicatorStatus.fullScreenError ||
                    status == IndicatorStatus.error) {
                  return SliverToBoxAdapter(
                    child: IndicatorWidget(
                      IndicatorStatus.error,
                      tryAgain: () {
                        loadingData.errorRefresh();
                      },
                    ),
                  );
                }
                return const SliverToBoxAdapter(
                  child: SizedBox.shrink(),
                );
              }),
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

class MySliverLoadingData extends SliverLoadingData<int> {
  @override
  Future<int?> onLoadData() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    // retrun null means error
    return 123456;
  }
}
