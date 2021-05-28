import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;

  MessageDisplay(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
