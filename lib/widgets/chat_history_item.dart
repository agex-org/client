import 'package:flutter/material.dart';

class ChatHistoryItem extends StatelessWidget {
  const ChatHistoryItem(this.title, this.url, this.sessionId, this.onTap,
      {super.key});

  final String title;
  final String url;
  final String sessionId;
  final GestureTapCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          tileColor: Colors.black26,
          onTap: onTap,
        ),
      ),
    );
  }
}
