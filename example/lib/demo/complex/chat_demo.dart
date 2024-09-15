import 'dart:math';

import 'package:example/assets.dart';
import 'package:example/data/tu_chong_repository.dart';
import 'package:example/data/tu_chong_source.dart';
import 'package:example/special_text/emoji_text.dart';
import 'package:example/special_text/my_special_text_span_builder.dart';
import 'package:example/widget/toggle_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:extended_keyboard/extended_keyboard.dart';

import 'package:extended_text/extended_text.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:loading_more_list/loading_more_list.dart';

enum KeyboardPanelType {
  emoji,
  image,
}

@FFRoute(
  name: 'fluttercandies://ChatDemo',
  routeName: 'ChatDemo',
  description: 'Show how to build custom keyboard with KeyboardBuilder quickly',
  exts: <String, dynamic>{
    'order': 2,
    'group': 'Complex',
  },
)
class ChatDemo extends StatefulWidget {
  const ChatDemo({Key? key}) : super(key: key);

  @override
  State<ChatDemo> createState() => _ChatDemoState();
}

class _ChatDemoState extends State<ChatDemo> {
  KeyboardPanelType _keyboardPanelType = KeyboardPanelType.emoji;
  final GlobalKey<ExtendedTextFieldState> _key =
      GlobalKey<ExtendedTextFieldState>();
  final TextEditingController _textEditingController = TextEditingController();
  final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();
  late TuChongRepository imageList = TuChongRepository(maxLength: 100);
  final ScrollController _controller = ScrollController();

  late ChatMessageHistory _chatMessageHistory;

  final List<Message> _chatMessages = <Message>[];
  final Key _centerKey = const ValueKey<String>('center-sliver');
  final CustomKeyboardController _customKeyboardController =
      CustomKeyboardController(KeyboardType.system);

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final DateTime dateTimeNow = DateTime.now();
    for (final String element in <String>[
      '[44] @Dota2 CN dota best dota',
      'yes, you are right [36].',
      '大家好，我是拉面，很萌很新 [12].',
      '\$Flutter\$. CN dev best dev',
      '\$Dota2 Ti9\$. Shanghai,I\'m coming.',
      'error 0 [45] warning 0',
    ]) {
      _chatMessages.add(Message(
        content: element,
        dateTime: dateTimeNow.add(
          const Duration(seconds: 2),
        ),
        showTime: false,
      ));
    }

    _chatMessageHistory = ChatMessageHistory(_chatMessages.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('ChatDemo')),
      body: SafeArea(
        bottom: true,
        child: KeyboardBuilder(
          resizeToAvoidBottomInset: true,
          controller: _customKeyboardController,
          builder: (BuildContext context, double? systemKeyboardHeight) {
            return _buildCustomKeyboard(context, systemKeyboardHeight);
          },
          bodyBuilder: (bool readOnly) => Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _customKeyboardController.unfocus();
                  },
                  child: LoadingMoreCustomScrollView(
                    showGlowLeading: false,
                    controller: _controller,
                    center: _centerKey,
                    slivers: <Widget>[
                      LoadingMoreSliverList<Message>(
                        SliverListConfig<Message>(
                          itemBuilder: _itemBuilder,
                          sourceList: _chatMessageHistory,
                          indicatorBuilder:
                              (BuildContext context, IndicatorStatus status) {
                            if (status == IndicatorStatus.fullScreenBusying) {
                              return const SliverToBoxAdapter(
                                child: IndicatorWidget(
                                  IndicatorStatus.loadingMoreBusying,
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                      SliverList(
                        key: _centerKey,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          return _itemBuilder(
                              context, _chatMessages[index], index);
                        }, childCount: _chatMessages.length),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey,
                    ),
                    bottom: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ExtendedTextField(
                        key: _key,
                        readOnly: readOnly,
                        showCursor: true,
                        focusNode: _focusNode,
                        specialTextSpanBuilder: _mySpecialTextSpanBuilder,
                        controller: _textEditingController,
                        textInputAction: TextInputAction.done,
                        strutStyle: const StrutStyle(),
                        decoration: InputDecoration(
                          hintText: 'Input something',
                          border: InputBorder.none,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                sendMessage(_textEditingController.text);
                                _textEditingController.clear();
                              });
                            },
                            child: const Icon(Icons.send),
                          ),
                          contentPadding: const EdgeInsets.all(
                            12.0,
                          ),
                        ),
                        maxLines: 2,
                        onTap: () {
                          _customKeyboardController.showSystemKeyboard();
                        },
                      ),
                    ),
                    KeyboardTypeBuilder(
                      builder: (
                        BuildContext context,
                        CustomKeyboardController controller,
                      ) =>
                          Row(
                        children: <Widget>[
                          createButton(
                            Icons.sentiment_very_satisfied,
                            KeyboardPanelType.emoji,
                            controller,
                          ),
                          createButton(
                            Icons.image,
                            KeyboardPanelType.image,
                            controller,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createButton(
    IconData icon,
    KeyboardPanelType keyboardPanelType,
    CustomKeyboardController controller,
  ) {
    return ToggleButton(
      builder: (bool active) => Icon(
        icon,
        color: active ? Colors.orange : null,
      ),
      activeChanged: (bool active) {
        _keyboardPanelType = keyboardPanelType;
        if (active) {
          controller.showCustomKeyboard();
          if (!_focusNode.hasFocus) {
            SchedulerBinding.instance
                .addPostFrameCallback((Duration timeStamp) {
              _focusNode.requestFocus();
            });
          }
        } else {
          controller.showSystemKeyboard();
        }
      },
      active: controller.isCustom && _keyboardPanelType == keyboardPanelType,
    );
  }

  Widget _buildCustomKeyboard(
    BuildContext context,
    double? systemKeyboardHeight,
  ) {
    systemKeyboardHeight ??= 346;

    switch (_keyboardPanelType) {
      case KeyboardPanelType.emoji:
        return Material(
          child: SizedBox(
            height: systemKeyboardHeight,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    insertText('[${index + 1}]');
                  },
                  child: Image.asset(
                      EmojiUitl.instance.emojiMap['[${index + 1}]']!),
                );
              },
              itemCount: EmojiUitl.instance.emojiMap.length,
              padding: const EdgeInsets.all(5.0),
            ),
          ),
        );
      case KeyboardPanelType.image:
        return Material(
          child: SizedBox(
            height: systemKeyboardHeight,
            child: LoadingMoreList<TuChongItem>(
              ListConfig<TuChongItem>(
                sourceList: imageList,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder:
                    (BuildContext context, TuChongItem item, int index) {
                  final String url = item.imageUrl;
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // <img src="http://pic2016.5442.com:82/2016/0513/12/3.jpg!960.jpg"/>
                      setState(() {
                        sendMessage(
                            "<img src='$url'  width='${item.imageSize.width}' height='${item.imageSize.height}'/>");
                      });
                    },
                    child: ExtendedImage.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                padding: const EdgeInsets.all(5.0),
              ),
            ),
          ),
        );
      default:
    }
    return Container();
  }

  void insertText(String text) {
    _textEditingController.insertText(text);

    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _key.currentState?.bringIntoView(_textEditingController.selection.base);
    });
  }

  void sendMessage(String text) {
    if (text.isEmpty) {
      return;
    }
    setState(() {
      final DateTime dateTime = DateTime.now();
      if (_chatMessages.isNotEmpty) {
        Message lastMessage = _chatMessages.removeLast();
        if (dateTime.difference(lastMessage.dateTime).inSeconds >
            Message.showTimeDuration) {
          lastMessage = lastMessage.copyWith(showTime: true);
        }
        _chatMessages.add(lastMessage);
      }

      _chatMessages.add(Message(
        content: text,
        dateTime: dateTime,
        showTime: false,
      ));
    });
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget _itemBuilder(BuildContext context, Message message, int index) {
    List<Widget> children = <Widget>[
      ExtendedImage.asset(
        Assets.assets_avatar_jpg,
        width: 20,
        height: 20,
      ),
      const SizedBox(width: 5),
      Flexible(
        child: ExtendedText(
          message.content,
          specialTextSpanBuilder: _mySpecialTextSpanBuilder,
          maxLines: 10,
        ),
      ),
    ];
    if (message.isMe) {
      children = children.reversed.toList();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: children,
          ),
          if (message.showTime)
            Center(
              child: Text(
                DateFormat(isSameDay(message.dateTime, DateTime.now())
                        ? 'HH:mm'
                        : 'yyyy-MM-dd HH:mm')
                    .format(message.dateTime),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class Message {
  Message({
    required this.content,
    required this.dateTime,
    required this.showTime,
    bool? isMe,
  }) : isMe = isMe ?? Random().nextBool();

  final bool isMe;
  final String content;
  final DateTime dateTime;
  final bool showTime;

  Message copyWith({
    bool? isMe,
    String? content,
    DateTime? dateTime,
    bool? showTime,
  }) {
    return Message(
      content: content ?? this.content,
      dateTime: dateTime ?? this.dateTime,
      showTime: showTime ?? this.showTime,
      isMe: isMe ?? this.isMe,
    );
  }

  static const int showTimeDuration = 1800;
}

class ChatMessageHistory extends LoadingMoreBase<Message> {
  ChatMessageHistory(this.lastOne);
  Message lastOne;
  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    await Future<void>.delayed(
      const Duration(seconds: 2),
    );
    final int index = length;

    int duration = 0;

    for (int i = index; i < index + 10; i++) {
      final DateTime time = lastOne.dateTime.add(
        Duration(seconds: index == length ? Random().nextInt(2800) : duration),
      );
      final Message message = Message(
        content: 'message $i',
        dateTime: time,
        showTime: time.difference(lastOne.dateTime).inSeconds >
            Message.showTimeDuration,
      );
      add(message);
      duration += Random().nextInt(2000);
      lastOne = message;
    }
    return true;
  }
}
