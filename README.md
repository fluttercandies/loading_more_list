# loading_more_list

A loading more list which supports ListView,GridView,WaterfallFlow and Slivers.

[![pub package](https://img.shields.io/pub/v/loading_more_list.svg)](https://pub.dartlang.org/packages/loading_more_list) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/network)  [![GitHub license](https://img.shields.io/github/license/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

Language: English | [中文简体](README-ZH.md)

[Web demo for LoadingMoreList](https://fluttercandies.github.io/loading_more_list/)

- [loading_more_list](#loading_more_list)
  - [Use](#use)
  - [Prepare Data Collection](#prepare-data-collection)
  - [Argument](#argument)
  - [Widget](#widget)
  - [ListView](#listview)
  - [GridView](#gridview)
  - [WaterfallFlow](#waterfallflow)
  - [Sliver/CustomScrollView](#slivercustomscrollview)
  - [IndicatorStatus](#indicatorstatus)
  - [CollectGarbage](#collectgarbage)
  - [ViewportBuilder](#viewportbuilder)
  - [LastChildLayoutType](#lastchildlayouttype)
  - [CloseToTrailing](#closetotrailing)

## Use

* add library to your pubspec.yaml

```yaml

dependencies:
  loading_more_list: any

```
* import library in dart file

```dart

  import 'package:loading_more_list/loading_more_list.dart';

```

## Prepare Data Collection

LoadingMoreBase<T> is data collection for loading more. override loadData method to load your data. set hasMore to false when it has no more data.

```dart
class TuChongRepository extends LoadingMoreBase<TuChongItem> {
  int pageindex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  @override
  bool get hasMore => (_hasMore && length < 30) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageindex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    String url = "";
    if (this.length == 0) {
      url = "https://api.tuchong.com/feed-app";
    } else {
      int lastPostId = this[this.length - 1].postId;
      url =
          "https://api.tuchong.com/feed-app?post_id=$lastPostId&page=$pageindex&type=loadmore";
    }
    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      await Future.delayed(Duration(milliseconds: 500));

      var result = await HttpClientHelper.get(url);

      var source = TuChongSource.fromJson(json.decode(result.body));
      if (pageindex == 1) {
        this.clear();
      }
      for (var item in source.feedList) {
        if (item.hasImage && !this.contains(item) && hasMore) this.add(item);
      }

      _hasMore = source.feedList.length != 0;
      pageindex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}

```

## Argument

almost of arguments are the same as official.

following arguments are made for loading more.

ListConfig<T> and SliverListConfig<T>

| argument             | description                                                                    | default                  |
| -------------------- | ------------------------------------------------------------------------------ | ------------------------ |
| itemBuilder          | The item builder of list.                                                      | required                 |
| sourceList           | The source list of data which extends LoadingMoreBase<T>.                      | required                 |
| showGlowLeading      | Whether to show the overscroll glow on the side with negative scroll offsets.  | 0.0                      |
| showGlowTrailing     | Whether to show the overscroll glow on the side with positive scroll offsets.  | -                        |
| lastChildLayoutType  | Layout type of last child(loadmore/no more item).                              | LastChildLayoutType.foot |
| extendedListDelegate | The delegate for WaterfallFlow or ExtendedList.                                | -                        |
| gridDelegate         | The delegate for GridView.                                                     | -                        |
| indicatorBuilder     | widget builder for different loading state.                                    | IndicatorWidget          |
| padding              | The amount of space by which to inset the child sliver for SliverListConfig<T> | -                        |
| childCountBuilder    | The builder to get child count, the input is sourceList.length                                                 | -                        |

## Widget

LoadingMoreList<T>

| argument             | description                                                                                    | default  |
| -------------------- | ---------------------------------------------------------------------------------------------- | -------- |
| listConfig           | ListConfig<T>                                                                                  | required |
| onScrollNotification | Called when a ScrollNotification of the appropriate type arrives at this location in the tree. | -        |

LoadingMoreSliverList<T>

| argument         | description         | default  |
| ---------------- | ------------------- | -------- |
| sliverListConfig | SliverListConfig<T> | required |

LoadingMoreCustomScrollView

| argument                | description                                                                                    | default |
| ----------------------- | ---------------------------------------------------------------------------------------------- | ------- |
| onScrollNotification    | Called when a ScrollNotification of the appropriate type arrives at this location in the tree. | -       |


## ListView

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/listview.gif)

```dart
            LoadingMoreList(
              ListConfig<TuChongItem>(
                itemBuilder: ItemBuilder.itemBuilder,
                sourceList: listSourceRepository,
                padding: EdgeInsets.all(0.0),
              ),
            ),
```

## GridView

define GridView with gridDelegate argument.

```dart
            LoadingMoreList(
              ListConfig<TuChongItem>(
                itemBuilder: ItemBuilder.itemBuilder,
                sourceList: listSourceRepository,
                padding: EdgeInsets.all(0.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3.0,
                  mainAxisSpacing: 3.0,
                ),
              ),
            ),
```

## WaterfallFlow

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/waterfall_flow/known_sized.gif)

define WaterfallFlow with waterfallFlowDelegate argument.

```dart
            LoadingMoreList(
              ListConfig<TuChongItem>(
                extendedListDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                ),
                itemBuilder: _buildItem,
                sourceList: listSourceRepository,
                padding: EdgeInsets.all(5.0),
              ),
            ),
```

## Sliver/CustomScrollView

| ![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/multiple_sliver.gif) | ![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/nested_scrollView.gif) |
| ----------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- |

following codes are show how to build loading more list within CustomScrollView.

```dart
      LoadingMoreCustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Text("MultipleSliverDemo"),
          ),
          ///SliverList
          LoadingMoreSliverList(SliverListConfig<TuChongItem>(
            itemBuilder: ItemBuilder.itemBuilder,
            sourceList: listSourceRepository,
          )),
          SliverToBoxAdapter(
            child: Container(
              alignment: Alignment.center,
              child: Text("Next list"),
              color: Colors.blue,
              height: 100.0,
            ),
          ),
          ///SliverGrid
          LoadingMoreSliverList(
            SliverListConfig<TuChongItem>(
              itemBuilder: ItemBuilder.itemBuilder,
              sourceList: listSourceRepository1,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0,
              ),
            ),
          ),
          SliverPersistentHeader(
            delegate: CommonExtentSliverPersistentHeaderDelegate(
                Container(
                  alignment: Alignment.center,
                  child: Text("Pinned Content"),
                  color: Colors.red,
                ),
                100.0),
            pinned: true,
          ),
          ///SliverWaterfallFlow
          LoadingMoreSliverList(
            SliverListConfig<TuChongItem>(
              itemBuilder: buildWaterfallFlowItem,
              sourceList: listSourceRepository2,
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              extendedListDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ],
      ),
```

## IndicatorStatus

| ![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/error.gif) | ![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/custom_indicator.gif) |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |

define loading status with indicatorBuilder argument.

``` dart
        enum IndicatorStatus {
          None,
          LoadingMoreBusying,
          FullScreenBusying,
          Error,
          FullScreenError,
          NoMoreLoad,
          Empty
        }
```
``` dart
      LoadingMoreList(
        ListConfig<TuChongItem>(
          itemBuilder: ItemBuilder.itemBuilder,
          sourceList: listSourceRepository,
          indicatorBuilder: _buildIndicator,
          padding: EdgeInsets.all(0.0),
        ),
      ),

  //you can use IndicatorWidget or build yourself widget
  //in this demo, we define all status.
  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    //if your list is sliver list ,you should build sliver indicator for it
    //isSliver=true, when use it in sliver list
    bool isSliver = false;

    Widget widget;
    switch (status) {
      case IndicatorStatus.None:
        widget = Container(height: 0.0);
        break;
      case IndicatorStatus.LoadingMoreBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 5.0),
              height: 15.0,
              width: 15.0,
              child: getIndicator(context),
            ),
            Text("正在加载...不要着急")
          ],
        );
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.FullScreenBusying:
        widget = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 0.0),
              height: 30.0,
              width: 30.0,
              child: getIndicator(context),
            ),
            Text("正在加载...不要着急")
          ],
        );
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.Error:
        widget = Text(
          "好像出现了问题呢？",
        );
        widget = _setbackground(false, widget, 35.0);

        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.FullScreenError:
        widget = Text(
          "好像出现了问题呢？",
        );
        widget = _setbackground(true, widget, double.infinity);
        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );
        if (isSliver) {
          widget = SliverFillRemaining(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
      case IndicatorStatus.NoMoreLoad:
        widget = Text("没有更多的了。。不要拖了");
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.Empty:
        widget = EmptyWidget(
          "这里是空气！",
        );
        widget = _setbackground(true, widget, double.infinity);
        if (isSliver) {
          widget = SliverToBoxAdapter(
            child: widget,
          );
        } else {
          widget = CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                child: widget,
              )
            ],
          );
        }
        break;
    }
    return widget;
  }

```

## CollectGarbage

track the indexes are collect, you can collect garbage at that monment(for example Image cache)

[more detail](https://github.com/fluttercandies/extended_image/blob/e1577bc4d0b57c725110a9d886703b98a72772b5/example/lib/pages/photo_view_demo.dart#L91)

```dart
        LoadingMoreList(
          ListConfig<TuChongItem>(
            extendedListDelegate: ExtendedListDelegate(
              collectGarbage: (List<int> indexes) {
                ///collectGarbage
              },
            ),
          ),
        ),
```

## ViewportBuilder

track the indexes go into the viewport, it's not include cache extent.

```dart
        LoadingMoreList(
          ListConfig<TuChongItem>(
            extendedListDelegate: ExtendedListDelegate(
              viewportBuilder: (int firstIndex, int lastIndex) {
                print('viewport : [$firstIndex,$lastIndex]');
              },
            ),
          ),
        ),
```
## LastChildLayoutType

build lastChild as special child in the case that it is loadmore/no more item.

```dart
        enum LastChildLayoutType {
        /// as default child
        none,

        /// follow max child trailing layout offset and layout with full cross axis extent
        /// last child as loadmore item/no more item in [ExtendedGridView] and [WaterfallFlow]
        /// with full cross axis extend
        fullCrossAxisExtent,

        /// as foot at trailing and layout with full cross axis extend
        /// show no more item at trailing when children are not full of viewport
        /// if children is full of viewport, it's the same as fullCrossAxisExtent
        foot,
        }
```


## CloseToTrailing

when reverse property of List is true, layout is as following.
it likes chat list, and new session will insert to zero index.
but it's not right when items are not full of viewport.

```
     trailing
-----------------
|               |
|               |
|     item2     |
|     item1     |
|     item0     |
-----------------
     leading
```

to solve it, you could set closeToTrailing to true, layout is as following.
support [ExtendedGridView],[ExtendedList],[WaterfallFlow].
and it also works when reverse is flase, layout will close to trailing.

```
     trailing
-----------------
|     item2     |
|     item1     |
|     item0     |
|               |
|               |
-----------------
     leading
```

```dart
      LoadingMoreList(
        ListConfig<TuChongItem>(
          extendedListDelegate: ExtendedListDelegate(
            closeToTrailing: true
          ),
        ),
      ),
```
