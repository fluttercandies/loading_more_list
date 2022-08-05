import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/src/glow_notification_widget.dart';
import 'package:loading_more_list/src/list_config/sliver_list_config.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

//loading more for sliverlist and sliverGrid
class LoadingMoreSliverList<T> extends StatelessWidget {
  const LoadingMoreSliverList(this.sliverListConfig, {Key? key})
      : super(key: key);
  final SliverListConfig<T> sliverListConfig;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LoadingMoreBase<T>>(
      builder: (BuildContext b, AsyncSnapshot<LoadingMoreBase<T>> s) {
        return sliverListConfig.buildContent(context, s.data);
      },
      stream: sliverListConfig.sourceList.rebuild,
      initialData: sliverListConfig.sourceList,
    );
  }
}

//support for LoadingMoreSliverList
class LoadingMoreCustomScrollView extends StatefulWidget {
  const LoadingMoreCustomScrollView({
    Key? key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.cacheExtent,
    this.slivers = const <Widget>[],
    this.semanticChildCount,
    this.showGlowLeading = true,
    this.showGlowTrailing = true,
    this.onScrollNotification,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.configs,
  }) : super(
          key: key,
        );

  /// The slivers to place inside the viewport.
  final List<Widget> slivers;

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
  final ScrollController? controller;

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
  final bool? primary;

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
  final ScrollPhysics? physics;

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
  final double? cacheExtent;

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
  final int? semanticChildCount;

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  //in case : in loadingmore sliverlist in NestedScrollView,you should rebuild CustomScrollView,
  //so that viewport can be computed again.
  //final bool rebuildCustomScrollView;

  /// Called when a ScrollNotification of the appropriate type arrives at this
  /// location in the tree.
  final NotificationListenerCallback<ScrollNotification>? onScrollNotification;

  /// Configuration of offset passed to [DragStartDetails].
  ///
  /// The settings determines when a drag formally starts when the user
  /// initiates a drag.
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.widgets.scroll_view.keyboardDismissBehavior}
  /// [ScrollViewKeyboardDismissBehavior] the defines how this [ScrollView] will
  /// dismiss the keyboard automatically.
  /// {@endtemplate}
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro flutter.widgets.scrollable.restorationId}
  final String? restorationId;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// maybe your sliver is not a LoadingMoreSliverList

  /// class MyLoadingMoreSliverList extends StatelessWidget {
  ///   const MyLoadingMoreSliverList({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return LoadingMoreSliverList();
  ///   }
  /// }
  ///
  /// then you can pass them with [LoadingMoreCustomScrollView.configs]

  final List<SliverListConfig<dynamic>>? configs;
  @override
  _LoadingMoreCustomScrollViewState createState() =>
      _LoadingMoreCustomScrollViewState();
}

class _LoadingMoreCustomScrollViewState
    extends State<LoadingMoreCustomScrollView> {
  /// LoadingMoreSliverList collection
  late List<SliverListConfig<dynamic>> _loadingMoreConfigs;
  @override
  void initState() {
    _initConfigs();
    super.initState();
  }

  @override
  void didUpdateWidget(LoadingMoreCustomScrollView oldWidget) {
    if (oldWidget.slivers != widget.slivers ||
        oldWidget.configs != widget.configs) {
      _initConfigs();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _initConfigs() {
    _loadingMoreConfigs = widget.configs ??
        widget.slivers
            .whereType<LoadingMoreSliverList<dynamic>>()
            .map((LoadingMoreSliverList<dynamic> e) => e.sliverListConfig)
            .toList();

    for (final SliverListConfig<dynamic> config in _loadingMoreConfigs) {
      config.defaultShowNoMore = _loadingMoreConfigs.last == config;
      config.lock = _loadingMoreConfigs.first != config;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: GlowNotificationWidget(
          CustomScrollView(
            semanticChildCount: widget.semanticChildCount,
            shrinkWrap: widget.shrinkWrap,
            scrollDirection: widget.scrollDirection,
            physics: widget.physics,
            primary: widget.primary,
            cacheExtent: widget.cacheExtent,
            controller: widget.controller,
            slivers: widget.slivers,
            reverse: widget.reverse,
            dragStartBehavior: widget.dragStartBehavior,
            keyboardDismissBehavior: widget.keyboardDismissBehavior,
            restorationId: widget.restorationId,
            clipBehavior: widget.clipBehavior,
          ),
          showGlowLeading: widget.showGlowLeading,
          showGlowTrailing: widget.showGlowTrailing,
        ));
    // }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (widget.onScrollNotification != null)
      widget.onScrollNotification!(notification);

    if (notification.depth != 0) {
      return false;
    }

    //reach the pixels to loading more
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (_loadingMoreConfigs.isNotEmpty) {
        SliverListConfig<dynamic>? preList;
        for (int i = 0; i < _loadingMoreConfigs.length; i++) {
          final SliverListConfig<dynamic> item = _loadingMoreConfigs[i];

          final bool preListIsloading = preList?.sourceList.isLoading ?? false;

          if (!preListIsloading &&
              item.hasMore &&
              !item.isLoading &&
              !item.hasError) {
            final LoadingMoreBase<dynamic> sourceList = item.sourceList;
            item.lock = false;
            if (sourceList.isEmpty) {
              if (item.autoRefresh) {
                sourceList.refresh();
              }
            } else if (item.autoLoadMore) {
              sourceList.loadMore();
            }

            break;
          }
          preList = item;
        }
      }
    }
    return false;
  }

  // void onDataChanged(LoadingMoreBase<dynamic> data) {
  //   //if (data != null) {
  //   if (mounted) {
  //     setState(() {});
  //   }
  //   //}
  // }
}
