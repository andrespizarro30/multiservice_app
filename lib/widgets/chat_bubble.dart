import 'package:flutter/material.dart';
import 'package:multiservice_app/utils/colors.dart';

class ChatBubble extends StatelessWidget {

  String message;
  Color bubbleColor;

  ChatBubble({
    super.key,
    required this.message,
    required this.bubbleColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: bubbleColor
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 16
        ),
      ),
    );
  }
}
