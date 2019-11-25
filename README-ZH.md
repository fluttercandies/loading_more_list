# loading_more_list

加载更多列表支持ListView,GridView以及瀑布流。

[![pub package](https://img.shields.io/pub/v/loading_more_list.svg)](https://pub.dartlang.org/packages/loading_more_list) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/network)  [![GitHub license](https://img.shields.io/github/license/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/loading_more_list)](https://github.com/fluttercandies/loading_more_list/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

[掘金社区文章](https://juejin.im/post/5bfb9cb7e51d45592b766769)

语言: [English](README.md) | 中文简体


- [loading_more_list](#loadingmorelist)
  - [使用](#%e4%bd%bf%e7%94%a8)
  - [准备数据源](#%e5%87%86%e5%a4%87%e6%95%b0%e6%8d%ae%e6%ba%90)
  - [参数](#%e5%8f%82%e6%95%b0)
  - [Widget](#widget)
  - [ListView](#listview)
  - [GridView](#gridview)
  - [瀑布流](#%e7%80%91%e5%b8%83%e6%b5%81)
  - [Sliver/CustomScrollView](#slivercustomscrollview)
  - [状态效果](#%e7%8a%b6%e6%80%81%e6%95%88%e6%9e%9c)
  - [内存回收](#%e5%86%85%e5%ad%98%e5%9b%9e%e6%94%b6)
  - [可视区域追踪](#%e5%8f%af%e8%a7%86%e5%8c%ba%e5%9f%9f%e8%bf%bd%e8%b8%aa)
  - [LastChildLayoutType](#lastchildlayouttype)
  - [CloseToTrailing](#closetotrailing)

## 使用

* 添加库到 pubspec.yaml
  
```yaml

dependencies:
  loading_more_list: any

```  
* 导入库
  
```dart

  import 'package:loading_more_list/loading_more_list.dart';
  
```

## 准备数据源

你需要继承LoadingMoreBase<T>来实现加载更多的数据源. 通过重写loadData方法来加载数据. 当没有数据的时候记得把hasMore设置为flase.

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

## 参数

大部分参数都跟官方列表一样.

下面的参数是为加载更多而设计的.

ListConfig<T> 和 SliverListConfig<T>

| 参数                  | 描述                                          | 默认                     |
| --------------------- | --------------------------------------------- | ------------------------ |
| itemBuilder           | 列表元素构建器.                               | 必填                     |
| sourceList            | 数据源继承于LoadingMoreBase<T>.               | 必填                     |
| showGlowLeading       | 是否显示过度拖拽上部波纹.                     | 0.0                      |
| showGlowTrailing      | 是否显示过度拖拽下部波纹.                     | -                        |
| lastChildLayoutType   | 最后一个元素的布局样式(loadmore/no more元素). | LastChildLayoutType.foot |
| viewportBuilder       | 可视区域中元素indexes变化时的回调.            | -                        |
| closeToTrailing       | 可否让布局紧贴trailing.                       | false                    |
| collectGarbage        | 元素回收时候的回调.                           | -                        |
| gridDelegate          | GridView定义委托.                             | -                        |
| waterfallFlowDelegate | 瀑布流定义委托.                               | -                        |
| indicatorBuilder      | 状态指示构建器.                               | IndicatorWidget          |
| padding               | 边距，SliverListConfig<T>的参数               | -                        |


WaterfallFlowDelegate

| 参数             | 描述                 | 默认 |
| ---------------- | -------------------- | ---- |
| crossAxisCount   | 横轴的等长度元素数量 | 必填 |
| mainAxisSpacing  | 主轴元素之间的距离   | 0.0  |
| crossAxisSpacing | 横轴元素之间的距离   | 0.0  |


## Widget

LoadingMoreList<T>

| 参数                 | 描述                   | 默认     |
| -------------------- | ---------------------- | -------- |
| listConfig           | ListConfig<T> 构建参数 | required |
| onScrollNotification | 获取滚动冒泡通知.      | -        |

LoadingMoreSliverList<T> 

| 参数             | 描述                         | 默认     |
| ---------------- | ---------------------------- | -------- |
| sliverListConfig | SliverListConfig<T> 构建参数 | required |

LoadingMoreCustomScrollView

| 参数                    | 描述                                                                      | 默认  |
| ----------------------- | ------------------------------------------------------------------------- | ----- |
| onScrollNotification    | 获取滚动冒泡通知.                                                         | -     |
| rebuildCustomScrollView | 在NestedScrollView中, 需要重建CustomScrollView, 这样可视区域才会重新计算. | false |


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

通过gridDelegate定义GridView

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

## 瀑布流

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/waterfall_flow/known_sized.gif)

通过waterfallFlowDelegate定义瀑布流

```dart
            LoadingMoreList(
              ListConfig<TuChongItem>(
                waterfallFlowDelegate: WaterfallFlowDelegate(
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

下面的代码展示怎么在CustomScrollView中构建加载更多列表

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
              waterfallFlowDelegate: WaterfallFlowDelegate(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
            ),
          ),
        ],
      ),
```

## 状态效果

| ![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/error.gif) | ![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/loading_moe_list/custom_indicator.gif) |
| ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |

为各种状态定义展示效果.

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

## 内存回收

追踪列表元素回收，你可以在这个时刻回收一些内存，比如图片的内存缓存。

```dart
        LoadingMoreList(
          ListConfig<TuChongItem>(
            collectGarbage: (List<int> garbages) {
              print("collect garbage : $garbages");
            },
          ),
        ),
```

## 可视区域追踪

追踪进入Viewport的列表元素的index（即你看到的可视区域，并不包括缓存距离）

```dart
        LoadingMoreList(
          ListConfig<TuChongItem>(
            viewportBuilder: (int firstIndex, int lastIndex) {
              print("viewport : [$firstIndex,$lastIndex]");
            },
            closeToTrailing: true
          ),
        ),
```
## LastChildLayoutType

为最后一个元素创建特殊布局，这主要是用在将最后一个元素作为loadmore/no more的时候。

```dart
        enum LastChildLayoutType {
        /// 普通的
        none,

        /// 将最后一个元素绘制在最大主轴Item之后，并且使用横轴大小最为layout size
        /// 主要使用在[ExtendedGridView] and [WaterfallFlow]中，最后一个元素作为loadmore/no more元素的时候。
        fullCrossAxisExtend,

        /// 将最后一个child绘制在trailing of viewport，并且使用横轴大小最为layout size
        /// 这种常用于最后一个元素作为loadmore/no more元素，并且列表元素没有充满整个viewport的时候
        /// 如果列表元素充满viewport，那么效果跟fullCrossAxisExtend一样
        foot,
        }
```

## CloseToTrailing


当reverse设置为true的时候，布局会变成如下。常用于聊天列表，新的会话会被插入0的位置，但是当会话没有充满viewport的时候，下面的布局不是我们想要的。

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

为了解决这个问题，你可以设置 closeToTrailing 为true, 布局将变成如下
该属性同时支持[ExtendedGridView],[ExtendedList],[WaterfallFlow]。
当然如果reverse如果不为ture，你设置这个属性依然会生效，没满viewport的时候布局会紧靠trailing

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
          closeToTrailing: true
        ),
      ),
```
