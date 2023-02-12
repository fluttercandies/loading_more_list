import 'package:flutter/material.dart';

import 'package:loading_more_list/src/glow_notification_widget.dart';
import 'package:loading_more_list/src/list_config/list_config.dart';
import 'package:loading_more_list_library/loading_more_list_library.dart';

//loading more for listview and gridview
class LoadingMoreList<T> extends StatelessWidget {
  const LoadingMoreList(this.listConfig, {Key? key, this.onScrollNotification})
      : super(key: key);
  final ListConfig<T> listConfig;

  /// Called when a ScrollNotification of the appropriate type arrives at this
  /// location in the tree.
  final NotificationListenerCallback<ScrollNotification>? onScrollNotification;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: GlowNotificationWidget(
        StreamBuilder<LoadingMoreBase<T>>(
          builder: (
            BuildContext buildContext,
            AsyncSnapshot<LoadingMoreBase<T>> s,
          ) {
            return listConfig.buildContent(
              buildContext,
              listConfig.sourceList,
            );
          },
          stream: listConfig.sourceList.rebuild,
          initialData: listConfig.sourceList,
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
