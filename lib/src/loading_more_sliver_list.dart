import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';

//loading more for sliverlist and sliverGrid
class LoadingMoreSliverList<T> extends StatelessWidget {
  const LoadingMoreSliverList(this.sliverListConfig, {Key? key})
      : super(key: key);
  final SliverListConfig<T> sliverListConfig;

  @override
  Widget build(BuildContext context) {
    final _LoadingMoreCustomScrollViewState? state =
        _LoadingMoreCustomScrollViewState.of(context);
    assert(
      state != null,
      'LoadingMoreSliverList must be a sliver of LoadingMoreCustomScrollView',
    );
    if (state != null && state.widget.getConfigFromSliverContext) {
      state._updateConfig(this, context);
      _InheritedWidget.of(context);
    }

    return StreamBuilder<Iterable<T>>(
      builder: (
        BuildContext buildContext,
        AsyncSnapshot<Iterable<T>> s,
      ) {
        state?.hasNoMore(sliverListConfig);

        return sliverListConfig.buildContent(
          buildContext,
        );
      },
      stream: sliverListConfig.sourceList.rebuild,
      initialData:
          sliverListConfig.sourceList.wrapData(sliverListConfig.sourceList),
    );
  }
}

class LoadingMoreSliver extends LoadingMoreSliverList<int> {
  const LoadingMoreSliver(SliverConfig sliverListConfig, {Key? key})
      : super(
          sliverListConfig,
          key: key,
        );
}

class LoadingMoreLoadingSliver<T> extends LoadingMoreSliverList<T> {
  const LoadingMoreLoadingSliver(SliveLoadingConfig<T> sliverListConfig,
      {Key? key})
      : super(
          sliverListConfig,
          key: key,
        );
}

/// support for LoadingMoreSliverList
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
    this.preloadExtent = 0,
    this.center,
    this.getConfigFromSliverContext = false,
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

  /// The extent to preload the LoadingMoreBase when user scroll the list
  final double preloadExtent;

  /// The first child in the [GrowthDirection.forward] growth direction.
  ///
  /// Children after [center] will be placed in the [AxisDirection] determined
  /// by [scrollDirection] and [reverse] relative to the [center]. Children
  /// before [center] will be placed in the opposite of the axis direction
  /// relative to the [center]. This makes the [center] the inflection point of
  /// the growth direction.
  ///
  /// The [center] must be the key of one of the slivers built by [buildSlivers].
  ///
  /// Of the built-in subclasses of [ScrollView], only [CustomScrollView]
  /// supports [center]; for that class, the given key must be the key of one of
  /// the slivers in the [CustomScrollView.slivers] list.
  ///
  /// See also:
  ///
  ///  * [anchor], which controls where the [center] as aligned in the viewport.
  final Key? center;

  /// If you’ve wrapped LoadingMoreSliverList, for example with the following code:
  ///
  /// class MyLoadingMoreSliverList extends StatelessWidget {
  ///   const MyLoadingMoreSliverList({
  ///     Key? key,
  ///     required this.listSourceRepository,
  ///   }) : super(key: key);
  ///
  ///   final TuChongRepository listSourceRepository;
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return SliverPadding(
  ///       padding: const EdgeInsets.all(50),
  ///       sliver: LoadingMoreSliverList<TuChongItem>(
  ///         SliverListConfig<TuChongItem>(
  ///           itemBuilder: itemBuilder,
  ///           sourceList: listSourceRepository,
  ///           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  ///             crossAxisCount: 2,
  ///             crossAxisSpacing: 3.0,
  ///             mainAxisSpacing: 3.0,
  ///           ),
  ///         ),
  ///       ),
  ///     );
  ///   }
  /// }
  ///
  /// then we can't get the configs from [LoadingMoreCustomScrollView.slivers].
  ///
  /// In this case, you can set [LoadingMoreCustomScrollView.getConfigFromSliverContext] to true,
  /// it will get the config from the context of [LoadingMoreSliverList].
  /// and the following code will work.
  ///
  /// return LoadingMoreCustomScrollView(
  ///   test: true,
  ///   slivers: <Widget>[
  ///     MyLoadingMoreSliverList(),
  ///   ],
  /// );
  ///
  /// Default value is false.

  final bool getConfigFromSliverContext;
  @override
  _LoadingMoreCustomScrollViewState createState() =>
      _LoadingMoreCustomScrollViewState();
}

class _LoadingMoreCustomScrollViewState
    extends State<LoadingMoreCustomScrollView> {
  /// LoadingMoreSliverList collection
  final List<SliverListConfig<dynamic>> _loadingMoreConfigs =
      <SliverListConfig<dynamic>>[];

  final List<SliverListConfig<dynamic>> _loadingMoreConfigsBeforeCenter =
      <SliverListConfig<dynamic>>[];

  int? _centerIndex;

  static _LoadingMoreCustomScrollViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<_LoadingMoreCustomScrollViewState>();
  }

  @override
  void initState() {
    _initConfigs();
    super.initState();
  }

  @override
  void didUpdateWidget(LoadingMoreCustomScrollView oldWidget) {
    if (oldWidget.slivers != widget.slivers) {
      _initConfigs();
    }

    super.didUpdateWidget(oldWidget);
  }

  void _initConfigs() {
    _centerIndex = null;
    if (widget.center != null) {
      _centerIndex = widget.slivers
          .indexWhere((Widget element) => element.key == widget.center);
    }
    _loadingMoreConfigs.clear();
    _loadingMoreConfigsBeforeCenter.clear();
    if (!widget.getConfigFromSliverContext) {
      for (int i = 0; i < widget.slivers.length; i++) {
        final Widget sliver = widget.slivers[i];
        if (sliver is LoadingMoreSliverList<dynamic>) {
          final SliverListConfig<dynamic> config = sliver.sliverListConfig;
          if (_centerIndex != null && i < _centerIndex!) {
            _loadingMoreConfigsBeforeCenter.insert(0, config);
          } else {
            _loadingMoreConfigs.add(config);
          }
        }
      }

      for (int i = 0; i < _loadingMoreConfigs.length; i++) {
        final SliverListConfig<dynamic> config = _loadingMoreConfigs[i];
        config.defaultShowNoMore = i == _loadingMoreConfigs.length - 1;
        config.defaultLock = i != 0 && config.hasMore;
      }

      for (int i = 0; i < _loadingMoreConfigsBeforeCenter.length; i++) {
        final SliverListConfig<dynamic> config =
            _loadingMoreConfigsBeforeCenter[i];
        config.defaultShowNoMore =
            i == _loadingMoreConfigsBeforeCenter.length - 1;
        config.defaultLock = i != 0 && config.hasMore;
      }
    }
  }

  void _updateConfig(
    LoadingMoreSliverList<dynamic> sliverList,
    BuildContext configContext,
  ) {
    final SliverListConfig<dynamic> config = sliverList.sliverListConfig;
    if (!_loadingMoreConfigs.contains(config) &&
        !_loadingMoreConfigsBeforeCenter.contains(config)) {
      config.configIndex =
          _findTheConfigIndex(sliverList, configContext, widget);

      final int? centerIndex = _centerIndex;
      if (centerIndex != null && config.configIndex < centerIndex) {
        _addConfig(config, _loadingMoreConfigsBeforeCenter);
      } else {
        _addConfig(config, _loadingMoreConfigs);
      }
    }
  }

  void _addConfig(
    SliverListConfig<dynamic> config,
    List<SliverListConfig<dynamic>> list,
  ) {
    list.add(config);
    list.sort(
      (SliverListConfig<dynamic> a, SliverListConfig<dynamic> b) {
        return list == _loadingMoreConfigsBeforeCenter
            ? b.configIndex.compareTo(a.configIndex)
            : a.configIndex.compareTo(b.configIndex);
      },
    );
    for (int i = 0; i < list.length; i++) {
      final SliverListConfig<dynamic> config = list[i];
      config.defaultShowNoMore = i == list.length - 1;
      config.defaultLock = i != 0 && config.hasMore;
    }

    // refresh defaultShowNoMore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  int _findTheConfigIndex(
    LoadingMoreSliverList<dynamic> sliverList,
    BuildContext context,
    LoadingMoreCustomScrollView scrollView,
  ) {
    final List<Widget> slivers = scrollView.slivers;

    for (int i = 0; i < slivers.length; i++) {
      if (sliverList == slivers[i]) {
        return i;
      }
      bool isThisSliver = false;

      context.visitAncestorElements((Element element) {
        // stop
        if (element.widget == scrollView) {
          return false;
        }
        // find
        else if (element.widget == slivers[i]) {
          isThisSliver = true;
          return false;
        }
        return true;
      });

      if (isThisSliver) {
        return i;
      }
    }
    assert(false, 'can not find the sliver config index');
    return 0;
  }

  // One config has no more data, check whether need to load next config
  void hasNoMore(SliverListConfig<dynamic> config) {
    if (config.hasMore) {
      return;
    }
    // check whether need to load next config
    if (_loadingMoreConfigs.contains(config)) {
      _loadingMore(_loadingMoreConfigs);
    } else if (_loadingMoreConfigsBeforeCenter.contains(config)) {
      _loadingMore(_loadingMoreConfigsBeforeCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget sv = CustomScrollView(
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
      center: widget.center,
    );
    if (widget.getConfigFromSliverContext) {
      // in case: the one sliverList is in const widget, build method will not be called again, we will miss its' config.
      sv = _InheritedWidget(
        configList:
            '${_loadingMoreConfigsBeforeCenter.map((SliverListConfig<dynamic> e) => e.configIndex).join(',')}|${_loadingMoreConfigs.map((SliverListConfig<dynamic> e) => e.configIndex).join(',')}',
        child: sv,
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: GlowNotificationWidget(
        sv,
        showGlowLeading: widget.showGlowLeading,
        showGlowTrailing: widget.showGlowTrailing,
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (widget.onScrollNotification != null) {
      widget.onScrollNotification!(notification);
    }

    if (notification.depth != 0) {
      return false;
    }

    // reach the pixels to loading more
    if (notification.metrics.pixels + widget.preloadExtent >=
        notification.metrics.maxScrollExtent) {
      _loadingMore(_loadingMoreConfigs);
    } else if (notification.metrics.pixels - widget.preloadExtent <=
        notification.metrics.minScrollExtent) {
      _loadingMore(_loadingMoreConfigsBeforeCenter);
    }
    return false;
  }

  void _loadingMore(List<SliverListConfig<dynamic>> configs) {
    if (configs.isNotEmpty) {
      SliverListConfig<dynamic>? preList;
      for (int i = 0; i < configs.length; i++) {
        final SliverListConfig<dynamic> item = configs[i];

        final bool preListIsloading = preList?.isLoading ?? false;
        final bool preListhasMore = preList?.hasMore ?? false;

        if (!preListIsloading &&
            !preListhasMore &&
            item.hasMore &&
            !item.isLoading &&
            !item.hasError) {
          item.defaultLock = false;
          if (!item.actualLock) {
            if (item.isEmpty) {
              if (item.autoRefresh) {
                item.refresh();
              }
            } else if (item.autoLoadMore) {
              item.loadMore();
            }
          }

          break;
        }
        preList = item;
      }
    }
  }
}

class _InheritedWidget extends InheritedWidget {
  const _InheritedWidget({
    Key? key,
    required Widget child,
    required this.configList,
  }) : super(key: key, child: child);

  final String configList;
  @override
  bool updateShouldNotify(covariant _InheritedWidget oldWidget) {
    return configList != oldWidget.configList;
  }

  static _InheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedWidget>();
  }
}
