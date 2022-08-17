import 'package:flutter/material.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../indicator_widget.dart';
import 'sliver_list_config.dart';

typedef LoadingMoreItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

typedef LoadingMoreIndicatorBuilder = Widget? Function(
  BuildContext context,
  IndicatorStatus status,
);

class LoadingMoreListConfig<T> {
  LoadingMoreListConfig(
    this.itemBuilder,
    this.sourceList, {
    this.indicatorBuilder,
    this.gridDelegate,
    this.autoLoadMore = true,
    this.extendedListDelegate,
    this.lastChildLayoutType = LastChildLayoutType.foot,
    this.autoRefresh = true,
    this.childCount,
    this.childCountBuilder,
    this.getActualIndex,
  });

  /// Builds widget from [item] and [index].
  final LoadingMoreItemBuilder<T> itemBuilder;

  /// Source list based on the [LoadingMoreBase].
  final LoadingMoreBase<T> sourceList;

  //widget builder for different loading state
  //the deafault is LoadingIndicatorWidget
  final LoadingMoreIndicatorBuilder? indicatorBuilder;

  //whether is gird view
  final SliverGridDelegate? gridDelegate;

  //whether auto call sourceList.loadmore when meet the condition
  //if false, you must call sourceList.loadmore by yourself.
  final bool autoLoadMore;

  /// The delegate for WaterfallFlow or ExtendedList.
  final ExtendedListDelegate? extendedListDelegate;

  /// Layout type of last child
  final LastChildLayoutType lastChildLayoutType;

  //whether auto call sourceList.refresh when first load
  //if false, you must call sourceList.refresh by yourself.
  final bool autoRefresh;

  /// The total number of children this delegate can provide.
  ///
  /// If null, the number of children is determined by the least index for which
  /// [builder] returns null.
  final int? childCount;

  /// The builder to get child count,the input is sourceList.length
  final int Function(int count)? childCountBuilder;

  final int Function(int int)? getActualIndex;

  bool get isSliver {
    return this is SliverListConfig<T>;
  }

  Widget? buildContent(BuildContext context, LoadingMoreBase<T>? source) {
    //from stream builder or from refresh
    if (source == null ||
        (source.isEmpty &&
            source.indicatorStatus == IndicatorStatus.fullScreenBusying)) {
      if (source == null || !source.isLoading) {
        if (autoRefresh) {
          // first load
          if (this is SliverListConfig) {
            final SliverListConfig<dynamic> sliverListConfig =
                this as SliverListConfig<dynamic>;
            // prevent lock list load
            if (sliverListConfig.actualLock) {
              return SliverToBoxAdapter(
                child: Container(),
              );
            } else {
              sourceList.refresh();
            }
          } else {
            sourceList.refresh();
          }
        }
      }
      Widget? widget;
      if (indicatorBuilder != null)
        widget = indicatorBuilder!(context, IndicatorStatus.fullScreenBusying);
      widget = widget ??
          IndicatorWidget(
            IndicatorStatus.fullScreenBusying,
            isSliver: isSliver,
          );

      return widget;
    }
    //empty
    else if (source.isEmpty &&
        (source.indicatorStatus == IndicatorStatus.empty ||
            source.indicatorStatus == IndicatorStatus.fullScreenError)) {
      Widget? widget1;
      if (indicatorBuilder != null)
        widget1 = indicatorBuilder!(context, sourceList.indicatorStatus);
      widget1 = widget1 ??
          IndicatorWidget(
            sourceList.indicatorStatus,
            isSliver: isSliver,
            tryAgain: source.indicatorStatus == IndicatorStatus.fullScreenError
                ? () {
                    sourceList.errorRefresh();
                  }
                : null,
          );
      return widget1;
    }
    //show list
    //else if (source.length > 0) {

    // }
    return null;
  }

  Widget buildItem(BuildContext context, int index) {
    if (index ==
        (childCount ??
            childCountBuilder?.call(sourceList.length) ??
            sourceList.length)) {
      final Widget? widget = buildErrorItem(context);
      if (widget != null) {
        return widget;
      }

      final IndicatorStatus status = sourceList.hasMore
          ? IndicatorStatus.loadingMoreBusying
          : IndicatorStatus.noMoreLoad;

      if (sourceList.hasMore && autoLoadMore) {
        sourceList.loadMore();
      }

      Widget? widget1;
      if (indicatorBuilder != null) {
        widget1 = indicatorBuilder!(context, status);
      }
      widget1 = widget1 ??
          IndicatorWidget(
            status,
            isSliver: isSliver,
          );
      return widget1;
    }
    return itemBuilder(
      context,
      sourceList[getActualIndex?.call(index) ?? index],
      index,
    );
  }

  Widget? buildErrorItem(BuildContext context) {
    final bool hasError = sourceList.indicatorStatus == IndicatorStatus.error;
    if (hasError) {
      Widget? widget;
      if (indicatorBuilder != null)
        widget = indicatorBuilder!(context, IndicatorStatus.error);
      widget = widget ??
          IndicatorWidget(IndicatorStatus.error, isSliver: isSliver,
              tryAgain: () {
            sourceList.errorRefresh();
          });
      return widget;
    }
    return null;
  }

  bool get hasMore => sourceList.hasMore;
  bool get hasError => sourceList.hasError;
  bool get isLoading => sourceList.isLoading;

  ExtendedListDelegate getExtendedListDelegate(int childCount,
      {bool showNoMore = true}) {
    if (extendedListDelegate != null) {
      if (extendedListDelegate
          is SliverWaterfallFlowDelegateWithFixedCrossAxisCount) {
        final SliverWaterfallFlowDelegateWithFixedCrossAxisCount delegate =
            extendedListDelegate
                as SliverWaterfallFlowDelegateWithFixedCrossAxisCount;
        return SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
          crossAxisCount: delegate.crossAxisCount,
          mainAxisSpacing: delegate.mainAxisSpacing,
          crossAxisSpacing: delegate.crossAxisSpacing,
          lastChildLayoutTypeBuilder: showNoMore
              ? extendedListDelegate!.lastChildLayoutTypeBuilder ??
                  ((int index) => childCount == index
                      ? lastChildLayoutType
                      : LastChildLayoutType.none)
              : null,
          closeToTrailing: delegate.closeToTrailing,
          collectGarbage: delegate.collectGarbage,
          viewportBuilder: delegate.viewportBuilder,
        );
      } else if (extendedListDelegate
          is SliverWaterfallFlowDelegateWithMaxCrossAxisExtent) {
        final SliverWaterfallFlowDelegateWithMaxCrossAxisExtent delegate =
            extendedListDelegate
                as SliverWaterfallFlowDelegateWithMaxCrossAxisExtent;
        return SliverWaterfallFlowDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: delegate.maxCrossAxisExtent,
          mainAxisSpacing: delegate.mainAxisSpacing,
          crossAxisSpacing: delegate.crossAxisSpacing,
          lastChildLayoutTypeBuilder: showNoMore
              ? extendedListDelegate!.lastChildLayoutTypeBuilder ??
                  ((int index) => childCount == index
                      ? lastChildLayoutType
                      : LastChildLayoutType.none)
              : null,
          closeToTrailing: delegate.closeToTrailing,
          collectGarbage: delegate.collectGarbage,
          viewportBuilder: delegate.viewportBuilder,
        );
      } else {
        return ExtendedListDelegate(
          lastChildLayoutTypeBuilder: showNoMore
              ? extendedListDelegate!.lastChildLayoutTypeBuilder ??
                  ((int index) => childCount == index
                      ? lastChildLayoutType
                      : LastChildLayoutType.none)
              : null,
          closeToTrailing: extendedListDelegate!.closeToTrailing,
          collectGarbage: extendedListDelegate!.collectGarbage,
          viewportBuilder: extendedListDelegate!.viewportBuilder,
        );
      }
    }

    return ExtendedListDelegate(
      lastChildLayoutTypeBuilder: showNoMore
          ? ((int index) => childCount == index
              ? lastChildLayoutType
              : LastChildLayoutType.none)
          : null,
    );
  }
}
