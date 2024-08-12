import 'package:flutter/material.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

import 'loading_more_list_config.dart';
import 'sliver_list_config.dart';

Widget _itemBuilder(BuildContext context, dynamic item, int index) {
  return Container();
}

_SliverRepository _createSourceList() => _SliverRepository();

class SliverConfig extends SliverListConfig<int> {
  SliverConfig({
    bool autoLoadMore = true,
    bool autoRefresh = true,
    bool? showNoMore,
    bool? lock,
    LoadingMoreIndicatorBuilder? indicatorBuilder,
    required this.builder,
  }) : super(
          itemBuilder: _itemBuilder,
          sourceList: _createSourceList(),
          indicatorBuilder: indicatorBuilder,
          autoLoadMore: autoLoadMore,
          autoRefresh: autoRefresh,
          showNoMore: showNoMore,
          lock: lock,
        );

  final WidgetBuilder builder;

  @override
  Widget innerBuilderList(BuildContext context, int lastOne) {
    return builder(context);
  }
}

class SliveLoadingConfig<T> extends SliverListConfig<T> {
  SliveLoadingConfig({
    bool autoLoadMore = true,
    bool autoRefresh = true,
    bool? showNoMore,
    bool? lock,
    LoadingMoreIndicatorBuilder? indicatorBuilder,
    required this.builder,
    required SliverLoadingData<T> loadingData,
  }) : super(
          itemBuilder: _itemBuilder,
          sourceList: loadingData,
          indicatorBuilder: indicatorBuilder,
          autoLoadMore: autoLoadMore,
          autoRefresh: autoRefresh,
          showNoMore: showNoMore,
          lock: lock,
        );

  final Widget Function(BuildContext context, T? data) builder;

  @override
  Widget innerBuilderList(BuildContext context, int lastOne) {
    return builder(context, sourceList.isEmpty ? null : sourceList.first);
  }
}

class _SliverRepository extends SliverLoadingData<int> {
  @override
  Future<int?> onLoadData() async {
    return 1;
  }
}

/// loading data for one time.
abstract class SliverLoadingData<T> extends LoadingMoreBase<T> {
  bool _hasMore = true;
  @override
  bool get hasMore => _hasMore;
  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    final T? result = await onLoadData();
    if (result != null) {
      add(result);
    }
    _hasMore = false;
    return result != null;
  }

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    _hasMore = true;
    return super.refresh(true);
  }

  Future<T?> onLoadData();
}
