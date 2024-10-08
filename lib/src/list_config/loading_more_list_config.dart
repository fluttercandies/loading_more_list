import 'package:flutter/material.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../indicator_widget.dart';
import 'config_base.dart';
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

class LoadingMoreListConfig<T> with ConfigBase<T> {
  const LoadingMoreListConfig(
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

  /// The builder for each [IndicatorStatus].
  ///
  /// You can handle cases that you need to customize, and return null result
  /// to fallback to the default indicator.
  ///
  /// Defaults to [IndicatorWidget].
  final LoadingMoreIndicatorBuilder? indicatorBuilder;

  /// Set the [gridDelegate] if the config is for a grid view.
  final SliverGridDelegate? gridDelegate;

  /// Whether to auto load more with the [sourceList].
  ///
  /// Set to false if you want to handle the load more action yourself.
  final bool autoLoadMore;

  /// The delegate for [WaterfallFlow] or [ExtendedList].
  final ExtendedListDelegate? extendedListDelegate;

  /// Layout type of last child.
  final LastChildLayoutType lastChildLayoutType;

  /// Whether to auto refresh with the [sourceList].
  ///
  /// Set to false if you want to handle the refresh action yourself.
  final bool autoRefresh;

  /// The total number of children this delegate can provide.
  ///
  /// If null, the number of children is determined by the least index for which
  /// [builder] returns null.
  final int? childCount;

  /// The builder to get child count,the input is [LoadingMoreBase.length].
  final int Function(int count)? childCountBuilder;

  /// return actual index
  final int Function(int int)? getActualIndex;

  bool get isSliver => this is SliverListConfig<T>;

  Widget? buildContent(BuildContext context) {
    //from stream builder or from refresh
    if (isEmpty && indicatorStatus == IndicatorStatus.fullScreenBusying) {
      if (!isLoading) {
        if (autoRefresh) {
          // first load
          if (isSliver) {
            final SliverListConfig<dynamic> sliverListConfig =
                this as SliverListConfig<dynamic>;
            // prevent lock list load
            if (sliverListConfig.actualLock) {
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            }
          }

          refresh();
        }
      }
      Widget? widget;
      if (indicatorBuilder != null) {
        widget = indicatorBuilder!(context, IndicatorStatus.fullScreenBusying);
      }
      widget = widget ??
          IndicatorWidget(
            IndicatorStatus.fullScreenBusying,
            isSliver: isSliver,
          );
      return widget;
    } else if (isEmpty &&
        (indicatorStatus == IndicatorStatus.empty ||
            indicatorStatus == IndicatorStatus.fullScreenError)) {
      Widget? widget1;
      if (indicatorBuilder != null) {
        widget1 = indicatorBuilder!(context, indicatorStatus);
      }
      widget1 = widget1 ??
          IndicatorWidget(
            indicatorStatus,
            isSliver: isSliver,
            tryAgain: indicatorStatus == IndicatorStatus.fullScreenError
                ? errorRefresh
                : null,
          );
      return widget1;
    }
    return null;
  }

  Widget buildItem(BuildContext context, int index, Iterable<T> source) {
    if (index ==
        (childCount ??
            childCountBuilder?.call(source.length) ??
            source.length)) {
      final Widget? widget = buildErrorItem(context);
      if (widget != null) {
        return widget;
      }

      final IndicatorStatus status = hasMore
          ? IndicatorStatus.loadingMoreBusying
          : IndicatorStatus.noMoreLoad;

      if (hasMore && autoLoadMore) {
        loadMore();
      }

      Widget? widget1;
      if (indicatorBuilder != null) {
        widget1 = indicatorBuilder!(context, status);
      }
      widget1 = widget1 ?? IndicatorWidget(status, isSliver: isSliver);
      return widget1;
    }
    final int actualIndex = getActualIndex?.call(index) ?? index;
    return itemBuilder(
      context,
      source.elementAt(actualIndex),
      actualIndex,
    );
  }

  Widget? buildErrorItem(BuildContext context) {
    final bool hasError = indicatorStatus == IndicatorStatus.error;
    if (hasError) {
      Widget? widget;
      if (indicatorBuilder != null) {
        widget = indicatorBuilder!(context, IndicatorStatus.error);
      }
      widget = widget ??
          IndicatorWidget(
            IndicatorStatus.error,
            isSliver: isSliver,
            tryAgain: errorRefresh,
          );
      return widget;
    }
    return null;
  }

  ExtendedListDelegate getExtendedListDelegate(
    int childCount, {
    bool showNoMore = true,
  }) {
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
          ? (int index) => childCount == index
              ? lastChildLayoutType
              : LastChildLayoutType.none
          : null,
    );
  }

  @override
  bool get hasMore => sourceList.hasMore;

  @override
  bool get hasError => sourceList.hasError;

  @override
  bool get isLoading => sourceList.isLoading;

  @override
  bool get isEmpty => sourceList.isEmpty;

  @override
  IndicatorStatus get indicatorStatus => sourceList.indicatorStatus;

  @override
  Future<bool> errorRefresh() {
    return sourceList.errorRefresh();
  }

  @override
  Future<bool> loadMore() {
    return sourceList.loadMore();
  }

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    return sourceList.refresh(notifyStateChanged);
  }

  @override
  int get length => sourceList.length;
}
