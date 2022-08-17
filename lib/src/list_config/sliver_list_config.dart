import 'package:extended_list/extended_list.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import 'loading_more_list_config.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) {
  return localIndex;
}

//config for SliverList, SliverGrid, SliverWaterfallFlow and ExtendedSliver
class SliverListConfig<T> extends LoadingMoreListConfig<T> {
  SliverListConfig({
    required LoadingMoreItemBuilder<T> itemBuilder,
    required LoadingMoreBase<T> sourceList,
    LoadingMoreIndicatorBuilder? indicatorBuilder,
    SliverGridDelegate? gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    int? childCount,
    bool autoLoadMore = true,
    ExtendedListDelegate? extendedListDelegate,
    LastChildLayoutType lastChildLayoutType = LastChildLayoutType.foot,
    this.padding,
    this.itemExtent,
    bool autoRefresh = true,
    int Function(int count)? childCountBuilder,
    int Function(int int)? getActualIndex,
    this.showNoMore,
    this.lock,
  }) : super(
          itemBuilder,
          sourceList,
          indicatorBuilder: indicatorBuilder,
          gridDelegate: gridDelegate,
          autoLoadMore: autoLoadMore,
          extendedListDelegate: extendedListDelegate,
          lastChildLayoutType: lastChildLayoutType,
          autoRefresh: autoRefresh,
          childCount: childCount,
          childCountBuilder: childCountBuilder,
          getActualIndex: getActualIndex,
        );

  //whether show fullscreenLoading for multiple sliver
  //bool showFullScreenLoading = true;

  /// if null, it will take from defaultShowNoMore. it will be true only for last SliverListConfig
  final bool? showNoMore;

  /// lock list to load data
  /// if null, it will take from defaultLock.
  /// default is true and if will be false if it begin to load
  final bool? lock;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;

  /// The amount of space by which to inset the child sliver.
  final EdgeInsetsGeometry? padding;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double? itemExtent;

  bool defaultShowNoMore = true;

  bool get actualShowNoMore => showNoMore ?? defaultShowNoMore;

  bool defaultLock = true;

  bool get actualLock => lock ?? defaultLock;

  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T>? source) {
    return _innerBuilderContent(context, source);
  }

  Widget _innerBuilderContent(
    BuildContext context,
    LoadingMoreBase<T>? source,
  ) {
    Widget? widget = super.buildContent(context, source);
    if (widget == null) {
      int lastOne = 1;
      if (!actualShowNoMore && !source!.hasMore) {
        lastOne = 0;
      }
      widget = _innerBuilderList(context, source, lastOne);
    }
    return widget;
  }

  Widget _innerBuilderList(
      BuildContext context, LoadingMoreBase<T>? source, int lastOne) {
    Widget widget;
    final int count =
        childCount ?? childCountBuilder?.call(source!.length) ?? source!.length;
    final ExtendedListDelegate delegate = getExtendedListDelegate(count);

    if (delegate is SliverWaterfallFlowDelegate) {
      widget = SliverWaterfallFlow(
        gridDelegate: delegate,
        delegate: SliverChildBuilderDelegate(
          buildItem,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: semanticIndexCallback,
          semanticIndexOffset: semanticIndexOffset,
          childCount: count + lastOne,
        ),
      );
    } else if (gridDelegate != null) {
      widget = ExtendedSliverGrid(
          extendedListDelegate: delegate,
          delegate: SliverChildBuilderDelegate(
            buildItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            childCount: count + lastOne,
          ),
          gridDelegate: gridDelegate!);
    } else {
      if (itemExtent != null) {
        widget = ExtendedSliverFixedExtentList(
          itemExtent: itemExtent!,
          extendedListDelegate: delegate,
          delegate: SliverChildBuilderDelegate(
            buildItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            childCount: count + lastOne,
          ),
        );
      } else {
        widget = ExtendedSliverList(
          extendedListDelegate: delegate,
          delegate: SliverChildBuilderDelegate(
            buildItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            childCount: count + lastOne,
          ),
        );
      }
    }
    if (padding != null) {
      widget = SliverPadding(
        padding: padding!,
        sliver: widget,
      );
    }
    return widget;
  }
}
