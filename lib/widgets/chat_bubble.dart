import 'package:chat_app/models/model.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final Profile? profile;

  const ChatBubble({super.key, required this.message, required this.profile});

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (!message.isMine)
        CircleAvatar(
          child: profile == null
              ? preloader
              : Text(
                  profile!.username.substring(0, 2),
                ),
        ),
      const SizedBox(
        width: 12,
      ),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          decoration: BoxDecoration(
            color: message.isMine
                ? Theme.of(context).primaryColor
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content),
        ),
      ),
      const SizedBox(
        width: 12,
      ),
      Text(format(message.createdAt, locale: "es_short")),
      const SizedBox(
        width: 60,
      ),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
