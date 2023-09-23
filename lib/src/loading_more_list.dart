import 'package:flutter/material.dart';

import 'package:loading_more_list/src/glow_notification_widget.dart';
import 'package:loading_more_list/src/list_config/list_config.dart';

class LoadingMoreList<T> extends StatefulWidget {
  final ListConfig<T> listConfig;
  final NotificationListenerCallback<ScrollNotification>? onScrollNotification;
  const LoadingMoreList(this.listConfig, {Key? key, this.onScrollNotification})
      : super(key: key);

  @override
  State<LoadingMoreList<T>> createState() => _LoadingMoreListState();
}

class _LoadingMoreListState<T> extends State<LoadingMoreList<T>> {

  late final listConfig = widget.listConfig;
  late final onScrollNotification = widget.onScrollNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: GlowNotificationWidget(
        StreamBuilder<Iterable<T>>(
          builder: (
            BuildContext buildContext,
            AsyncSnapshot<Iterable<T>> s,
          ) {
            return listConfig.buildContent(
              buildContext,
              s.data,
            );
          },
          stream: listConfig.sourceList.rebuild,
          initialData: listConfig.sourceList.wrapData(listConfig.sourceList),
        ),
        showGlowLeading: listConfig.showGlowLeading,
        showGlowTrailing: listConfig.showGlowTrailing,
      ),
    );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (onScrollNotification != null) {
      onScrollNotification!(notification);
    }

    if (notification.depth != 0) {
      return false;
    }

    //reach the pixels to loading more
    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent) {
      if (listConfig.hasMore && !listConfig.hasError && !listConfig.isLoading) {
        if (listConfig.sourceList.isEmpty) {
          if (listConfig.autoRefresh) {
            listConfig.sourceList.refresh();
          }
        } else if (listConfig.autoLoadMore) {
          listConfig.sourceList.loadMore();
        }
      }
    }
    return false;
  }
}