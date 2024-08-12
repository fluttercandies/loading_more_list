import 'package:loading_more_list_library/loading_more_list_library.dart';

mixin ConfigBase<T> {
  Future<bool> refresh([bool notifyStateChanged = false]);

  Future<bool> loadMore();

  bool get hasMore;

  bool get hasError;

  bool get isLoading;

  bool get isEmpty;

  IndicatorStatus get indicatorStatus;

  Future<bool> errorRefresh();

  int get length;
}
