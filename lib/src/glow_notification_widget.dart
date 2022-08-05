import 'package:flutter/material.dart';

class GlowNotificationWidget extends StatelessWidget {
  const GlowNotificationWidget(this.child,
      {this.showGlowLeading = false, this.showGlowTrailing = false});

  /// Whether to show the overscroll glow on the side with negative scroll
  /// offsets.
  final bool showGlowLeading;

  /// Whether to show the overscroll glow on the side with positive scroll
  /// offsets.
  final bool showGlowTrailing;

  //scrollable child
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleGlowNotification, child: child);
  }

  bool _handleGlowNotification(OverscrollIndicatorNotification notification) {
    if ((notification.leading && !showGlowLeading) ||
        (!notification.leading && !showGlowTrailing)) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }
}
