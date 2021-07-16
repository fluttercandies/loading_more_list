import 'package:flutter/material.dart';

/// This is the behavior typically seen on iOS.
/// drag loadmore item, overscroll will increase viewport pixels and maxScrollExtent at that moment
/// and jump into new pixels which is much bigger
/// we should correct pixels in [BouncingScrollPhysics.adjustPositionForNewDimensions]
///
/// old rule
/// if (oldPosition.pixels > oldPosition.maxScrollExtent) {
///   final double oldDelta =
///       oldPosition.pixels - oldPosition.maxScrollExtent;
///   return newPosition.maxScrollExtent + oldDelta;
/// }
///
/// new rule
/// if (oldPosition.pixels > oldPosition.maxScrollExtent) {
///   final double oldDelta =
///       oldPosition.pixels - oldPosition.maxScrollExtent;
///   return newPosition.pixels + oldDelta;
/// }
///
///
/// see [RangeMaintainingScrollPhysics.adjustPositionForNewDimensions]
class FixedOverscrollBouncingScrollPhysics extends BouncingScrollPhysics {
  const FixedOverscrollBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);
  @override
  FixedOverscrollBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FixedOverscrollBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions(
      {required ScrollMetrics oldPosition,
      required ScrollMetrics newPosition,
      required bool isScrolling,
      required double velocity}) {
    bool maintainOverscroll = true;
    bool enforceBoundary = true;
    if (velocity != 0.0) {
      // Don't try to adjust an animating position, the jumping around
      // would be distracting.
      maintainOverscroll = false;
      enforceBoundary = false;
    }
    if ((oldPosition.minScrollExtent == newPosition.minScrollExtent) &&
        (oldPosition.maxScrollExtent == newPosition.maxScrollExtent)) {
      // If the extents haven't changed then ignore overscroll.
      maintainOverscroll = false;
    }
    if (oldPosition.pixels != newPosition.pixels) {
      // If the position has been changed already, then it might have
      // been adjusted to expect new overscroll, so don't try to
      // maintain the relative overscroll.
      maintainOverscroll = false;
      if (oldPosition.minScrollExtent.isFinite &&
          oldPosition.maxScrollExtent.isFinite &&
          newPosition.minScrollExtent.isFinite &&
          newPosition.maxScrollExtent.isFinite) {
        // In addition, if the position changed then we only enforce
        // the new boundary if the previous boundary was not entirely
        // finite. A common case where the position changes while one
        // of the extents is infinite is a lazily-loaded list. (If the
        // boundaries were finite, and the position changed, then we
        // assume it was intentional.)
        enforceBoundary = false;
      }
    }
    if ((oldPosition.pixels < oldPosition.minScrollExtent) ||
        (oldPosition.pixels > oldPosition.maxScrollExtent)) {
      // If the old position was out of range, then we should
      // not try to keep the new position in range.
      enforceBoundary = false;
    }
    if (maintainOverscroll) {
      // Force the new position to be no more out of range
      // than it was before, if it was overscrolled.
      if (oldPosition.pixels < oldPosition.minScrollExtent) {
        final double oldDelta =
            oldPosition.minScrollExtent - oldPosition.pixels;
        return newPosition.minScrollExtent - oldDelta;
      }

      // old rule
      // if (oldPosition.pixels > oldPosition.maxScrollExtent) {
      //   final double oldDelta =
      //       oldPosition.pixels - oldPosition.maxScrollExtent;
      //   return newPosition.maxScrollExtent + oldDelta;
      // }

      // new rule
      if (oldPosition.pixels > oldPosition.maxScrollExtent) {
        final double oldDelta =
            oldPosition.pixels - oldPosition.maxScrollExtent;
        return newPosition.pixels + oldDelta;
      }
    }
    // If we're not forcing the overscroll, defer to other physics.
    double result = super.adjustPositionForNewDimensions(
        oldPosition: oldPosition,
        newPosition: newPosition,
        isScrolling: isScrolling,
        velocity: velocity);
    if (enforceBoundary) {
      // ...but if they put us out of range then reinforce the boundary.
      result = result.clamp(
          newPosition.minScrollExtent, newPosition.maxScrollExtent);
    }
    return result;
  }
}
