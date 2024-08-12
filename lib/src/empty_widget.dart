import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget(this.msg, {this.emptyWidget});
  final String msg;
  final Widget? emptyWidget;
  @override
  Widget build(BuildContext context) {
    if (emptyWidget != null) {
      return emptyWidget!;
    }
    return Container(
      color: Colors.grey[200],
      margin: const EdgeInsets.only(top: 30.0, bottom: 30.0),
      child: Center(
        child: Text(
          msg,
          style: const TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
