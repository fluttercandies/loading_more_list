import 'package:extended_list/extended_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide ViewportBuilder;
import 'package:loading_more_list/src/indicator_widget.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

int _kDefaultSemanticIndexCallback(Widget _, int localIndex) {
  return localIndex;
}

//config for ListView and GridView
class ListConfig<T> extends LoadingMoreListConfig<T> {
  ListConfig({
    Widget Function(BuildContext context, T item, int index) itemBuilder,
    LoadingMoreBase<T> sourceList,
    this.showGlowLeading = true,
    this.showGlowTrailing = true,
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding = const EdgeInsets.all(0.0),
    this.itemExtent,
    this.itemCount,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.semanticChildCount,
    bool autoLoadMore = true,
    WaterfallFlowDelegate waterfallFlowDelegate,
    ViewportBuilder viewportBuilder,
    LastChildLayoutType lastChildLayoutType = LastChildLayoutType.foot,
    CollectGarbage collectGarbage,
    bool closeToTrailing = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : super(
          itemBuilder,
          sourceList,
          indicatorBuilder: indicatorBuilder,
          gridDelegate: gridDelegate,
          autoLoadMore: autoLoadMore,
          waterfallFlowDelegate: waterfallFlowDelegate,
          viewportBuilder: viewportBuilder,
          lastChildLayoutType: lastChildLayoutType,
          collectGarbage: collectGarbage,
          closeToTrailing: closeToTrailing,
        );

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// When this is true, the scroll view is scrollable even if it does not have
  /// sufficient content to actually scroll. Otherwise, by default the user can
  /// only scroll the view if it has sufficient content. See [physics].
  ///
  /// On iOS, this also identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions. Furthermore, if [primary] is
  /// false, then the user cannot scroll if there is insufficient content to
  /// scroll, while if [primary] is true, they can always attempt to scroll.
  ///
  /// To force the scroll view to always be scrollable even if there is
  /// insufficient content, as if [primary] was true but without necessarily
  /// setting it to true, provide an [AlwaysScrollableScrollPhysics] physics
  /// object, as in:
  ///
  /// ```dart
  ///   physics: const AlwaysScrollableScrollPhysics(),
  /// ```
  ///
  /// To force the scroll view to use the default platform conventions and not
  /// be scrollable if there is insufficient content, regardless of the value of
  /// [primary], provide an explicit [ScrollPhysics] object, as in:
  ///
  /// ```dart
  ///   physics: const ScrollPhysics(),
  /// ```
  ///
  /// The physics can be changed dynamically (by providing a new object in a
  /// subsequent build), but new physics will only take effect if the _class_ of
  /// the provided object changes. Merely constructing a new instance with a
  /// different configuration is insufficient to cause the physics to be
  /// reapplied. (This is because the final object used is generated
  /// dynamically, which can be relatively expensive, and it would be
  /// inefficient to speculatively create this object each frame to see if the
  /// physics should be updated.)
  final ScrollPhysics physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// {@macro flutter.rendering.viewport.cacheExtent}
  final double cacheExtent;

  /// The number of children that will contribute semantic information.
  ///
  /// Some subtypes of [ScrollView] can infer this value automatically. For
  /// example [ListView] will use the number of widgets in the child list,
  /// while the [new ListView.separated] constructor will use half that amount.
  ///
  /// For [CustomScrollView] and other types which do not receive a builder
  /// or list of widgets, the child count must be explicitly provided. If the
  /// number is unknown or unbounded this should be left unset or set to null.
  ///
  /// See also:
  ///
  ///  * [SemanticsConfiguration.scrollChildCount], the corresponding semantics property.
  final int semanticChildCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry padding;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double itemExtent;

  /// The total number of children this delegate can provide.
  ///
  /// If null, the number of children is determined by the least index for which
  /// [builder] returns null.
  final int itemCount;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// Typically, children in lazy list are wrapped in [AutomaticKeepAlive]
  /// widgets so that children can use [KeepAliveNotification]s to preserve
  /// their state when they would otherwise be garbage collected off-screen.
  ///
  /// This feature (and [addRepaintBoundaries]) must be disabled if the children
  /// are going to manually maintain their [KeepAlive] state. It may also be
  /// more efficient to disable this feature if it is known ahead of time that
  /// none of the children will ever try to keep themselves alive.
  ///
  /// Defaults to true.
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// Typically, children in a scrolling container are wrapped in repaint
  /// boundaries so that they do not need to be repainted as the list scrolls.
  /// If the children are easy to repaint (e.g., solid color blocks or a short
  /// snippet of text), it might be more efficient to not add a repaint boundary
  /// and simply repaint the children during scrolling.
  ///
  /// Defaults to true.
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// Typically, children in a scrolling container must be annotated with a
  /// semantic index in order to generate the correct accessibility
  /// announcements. This should only be set to false if the indexes have
  /// already been provided by an [IndexedChildSemantics] widget.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///  * [IndexedChildSemantics], for an explanation of how to manually
  ///    provide semantic indexes.
  final bool addSemanticIndexes;

  /// A representation of how a [ScrollView] should dismiss the on-screen
  /// keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Configuration of offset passed to [DragStartDetails].
  ///
  /// The settings determines when a drag formally starts when the user
  /// initiates a drag.
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;
  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    Widget widget = super.buildContent(context, source);

    if (widget == null) {
      final int count = itemCount ?? source.length;
      if (waterfallFlowDelegate != null) {
        widget = WaterfallFlow.builder(
          gridDelegate:
              _getExtendedListDelegate() as SliverWaterfallFlowDelegate,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          itemBuilder: buildItem,
          itemCount: count + 1,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
        );
      } else if (gridDelegate != null) {
        widget = ExtendedGridView.builder(
          gridDelegate: gridDelegate,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          itemBuilder: buildItem,
          extendedListDelegate: _getExtendedListDelegate(),
          itemCount: count + 1,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
        );
      } else {
        widget = ExtendedListView.builder(
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          itemBuilder: buildItem,
          extendedListDelegate: _getExtendedListDelegate(),
          itemCount: count + 1,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
        );
      }
    }
    return widget;
  }
}

//config for SliverList and SliverGrid
class SliverListConfig<T> extends LoadingMoreListConfig<T> {
  SliverListConfig({
    Widget Function(BuildContext context, T item, int index) itemBuilder,
    LoadingMoreBase<T> sourceList,
    LoadingMoreIndicatorBuilder indicatorBuilder,
    SliverGridDelegate gridDelegate,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.semanticIndexCallback = _kDefaultSemanticIndexCallback,
    this.semanticIndexOffset = 0,
    this.childCount,
    bool autoLoadMore = true,
    WaterfallFlowDelegate waterfallFlowDelegate,
    ViewportBuilder viewportBuilder,
    LastChildLayoutType lastChildLayoutType = LastChildLayoutType.foot,
    CollectGarbage collectGarbage,
    bool closeToTrailing = false,
    this.padding,
    this.itemExtent,
  }) : super(
          itemBuilder,
          sourceList,
          indicatorBuilder: indicatorBuilder,
          gridDelegate: gridDelegate,
          autoLoadMore: autoLoadMore,
          waterfallFlowDelegate: waterfallFlowDelegate,
          viewportBuilder: viewportBuilder,
          lastChildLayoutType: lastChildLayoutType,
          collectGarbage: collectGarbage,
          closeToTrailing: closeToTrailing,
        );
//whether show no more  .
  bool showNoMore = true;
  //whether show fullscreenLoading for multiple sliver
  //bool showFullScreenLoading = true;

  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final SemanticIndexCallback semanticIndexCallback;
  final int semanticIndexOffset;
  final int childCount;

  /// The amount of space by which to inset the child sliver.
  final EdgeInsetsGeometry padding;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double itemExtent;

  @override
  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    //handle multiple sliver list in case showFullScreenLoading is false
//    if (!showFullScreenLoading &&
//        (source == null ||
//            (source.length == 0 &&
//                source.indicatorStatus == IndicatorStatus.FullScreenBusying))) {
//      if (source == null || !source.isLoading) {
//        //first load
//        sourceList.refresh();
//      }
//      Widget widget = null;
//      if (indicatorBuilder != null)
//        widget = indicatorBuilder(context, IndicatorStatus.LoadingMoreBusying);
//      widget = widget ??
//          IndicatorWidget(
//            IndicatorStatus.LoadingMoreBusying,
//          );
//
//      return SliverToBoxAdapter(
//        child: widget,
//      );
//    }
    return _innerBuilderContent(context, source);
  }

  Widget _innerBuilderContent(
    BuildContext context,
    LoadingMoreBase<T> source,
  ) {
    Widget widget = super.buildContent(context, source);
    if (widget == null) {
      int lastOne = 1;
      if (!showNoMore && !source.hasMore) {
        lastOne = 0;
      }
      widget = _innerBuilderList(context, source, lastOne);
    }
    return widget;
  }

  Widget _innerBuilderList(
      BuildContext context, LoadingMoreBase<T> source, int lastOne) {
    Widget widget;
    final int count = childCount ?? source.length;
    if (waterfallFlowDelegate != null) {
      widget = SliverWaterfallFlow(
        gridDelegate: _getExtendedListDelegate(showNoMore: showNoMore)
            as SliverWaterfallFlowDelegate,
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
          extendedListDelegate:
              _getExtendedListDelegate(showNoMore: showNoMore),
          delegate: SliverChildBuilderDelegate(
            buildItem,
            addAutomaticKeepAlives: addAutomaticKeepAlives,
            addRepaintBoundaries: addRepaintBoundaries,
            addSemanticIndexes: addSemanticIndexes,
            semanticIndexCallback: semanticIndexCallback,
            semanticIndexOffset: semanticIndexOffset,
            childCount: count + lastOne,
          ),
          gridDelegate: gridDelegate);
    } else {
      if (itemExtent != null) {
        widget = ExtendedSliverFixedExtentList(
          itemExtent: itemExtent,
          extendedListDelegate:
              _getExtendedListDelegate(showNoMore: showNoMore),
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
          extendedListDelegate:
              _getExtendedListDelegate(showNoMore: showNoMore),
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
    if (padding != null && widget != null) {
      widget = SliverPadding(
        padding: padding,
        sliver: widget,
      );
    }
    return widget;
  }
}

class LoadingMoreListConfig<T> {
  LoadingMoreListConfig(
    this.itemBuilder,
    this.sourceList, {
    this.indicatorBuilder,
    this.gridDelegate,
    this.autoLoadMore = true,
    this.waterfallFlowDelegate,
    this.lastChildLayoutType = LastChildLayoutType.foot,
    this.closeToTrailing = false,
    this.collectGarbage,
    this.viewportBuilder,
  })  : assert(itemBuilder != null),
        assert(sourceList != null),
        assert(autoLoadMore != null);
  //Item builder
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  //source list
  final LoadingMoreBase<T> sourceList;

  //widget builder for different loading state
  //the deafault is LoadingIndicatorWidget
  final LoadingMoreIndicatorBuilder indicatorBuilder;

  //whether is gird view
  final SliverGridDelegate gridDelegate;

  //whether auto call sourceList.loadmore when meet the condition
  final bool autoLoadMore;

  /// Creates waterfall flow layouts with a fixed number of tiles in the cross axis.
  final WaterfallFlowDelegate waterfallFlowDelegate;

  /// Layout type of last child
  final LastChildLayoutType lastChildLayoutType;

  /// Call when collect garbage, return garbage indexs to collect
  final CollectGarbage collectGarbage;

  /// The builder to get indexs in viewport
  final ViewportBuilder viewportBuilder;

  /// when reverse property of List is true, layout is as following.
  /// it likes chat list, and new session will insert to zero index
  /// but it's not right when items are not full of viewport.
  ///
  ///      trailing
  /// -----------------
  /// |               |
  /// |               |
  /// |     item2     |
  /// |     item1     |
  /// |     item0     |
  /// -----------------
  ///      leading
  ///
  /// to solve it, you could set closeToTrailing to true, layout is as following.
  /// support [ExtendedGridView],[ExtendedList],[WaterfallFlow]
  /// it works not only reverse is true.
  ///
  ///      trailing
  /// -----------------
  /// |     item2     |
  /// |     item1     |
  /// |     item0     |
  /// |               |
  /// |               |
  /// -----------------
  ///      leading
  ///
  final bool closeToTrailing;

  bool get isSliver {
    return this is SliverListConfig<T>;
  }

  Widget buildContent(BuildContext context, LoadingMoreBase<T> source) {
    //from stream builder or from refresh
    if (source == null ||
        (source.isEmpty &&
            source.indicatorStatus == IndicatorStatus.fullScreenBusying)) {
      if (source == null || !source.isLoading) {
        //first load
        sourceList.refresh();
      }
      Widget widget;
      if (indicatorBuilder != null)
        widget = indicatorBuilder(context, IndicatorStatus.fullScreenBusying);
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
      Widget widget1;
      if (indicatorBuilder != null)
        widget1 = indicatorBuilder(context, sourceList.indicatorStatus);
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
    if (index == sourceList.length) {
      final Widget widget = buildErrorItem(context);
      if (widget != null) {
        return widget;
      }

      final IndicatorStatus status = sourceList.hasMore
          ? IndicatorStatus.loadingMoreBusying
          : IndicatorStatus.noMoreLoad;

      if (sourceList.hasMore && autoLoadMore) {
        sourceList.loadMore();
      }

      Widget widget1;
      if (indicatorBuilder != null) {
        widget1 = indicatorBuilder(context, status);
      }
      widget1 = widget1 ??
          IndicatorWidget(
            status,
            isSliver: isSliver,
          );
      return widget1;
    }
    return itemBuilder(context, sourceList[index], index);
  }

  Widget buildErrorItem(BuildContext context) {
    final bool hasError = sourceList.indicatorStatus == IndicatorStatus.error;
    if (hasError) {
      Widget widget;
      if (indicatorBuilder != null)
        widget = indicatorBuilder(context, IndicatorStatus.error);
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

  ExtendedListDelegate _getExtendedListDelegate({bool showNoMore = true}) {
    if (waterfallFlowDelegate != null) {
      return SliverWaterfallFlowDelegate(
        crossAxisCount: waterfallFlowDelegate.crossAxisCount,
        mainAxisSpacing: waterfallFlowDelegate.mainAxisSpacing,
        crossAxisSpacing: waterfallFlowDelegate.crossAxisSpacing,
        lastChildLayoutTypeBuilder: showNoMore
            ? ((int index) => sourceList.length == index
                ? lastChildLayoutType
                : LastChildLayoutType.none)
            : null,
        closeToTrailing: closeToTrailing,
        collectGarbage: collectGarbage,
        viewportBuilder: viewportBuilder,
      );
    } else {
      return ExtendedListDelegate(
        lastChildLayoutTypeBuilder: showNoMore
            ? ((int index) => sourceList.length == index
                ? lastChildLayoutType
                : LastChildLayoutType.none)
            : null,
        closeToTrailing: closeToTrailing,
        collectGarbage: collectGarbage,
        viewportBuilder: viewportBuilder,
      );
    }
  }
}

typedef LoadingMoreIndicatorBuilder = Widget Function(
    BuildContext context, IndicatorStatus status);

class WaterfallFlowDelegate {
  /// Creates a delegate that makes grid layouts with a fixed number of tiles in
  /// the cross axis.
  ///
  /// All of the arguments must not be null. The `mainAxisSpacing` and
  /// `crossAxisSpacing` arguments must not be negative. The `crossAxisCount`
  ///  argument must be greater than zero.
  const WaterfallFlowDelegate({
    @required this.crossAxisCount,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
  })  : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(mainAxisSpacing != null && mainAxisSpacing >= 0),
        assert(crossAxisSpacing != null && crossAxisSpacing >= 0);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The number of logical pixels between each child along the main axis.
  final double mainAxisSpacing;

  /// The number of logical pixels between each child along the cross axis.
  final double crossAxisSpacing;
}
