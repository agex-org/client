import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String? title;
  final String url;

  const ChatScreen({required this.url, this.title, super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _promptTextController = TextEditingController();

  bool isLoading = false;
  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : Text("New Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  child: Text(messages[index]),
                ),
                itemCount: messages.length,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    controller: _promptTextController,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    var resp = await query(_promptTextController.text);
                    setState(() {
                      isLoading = false;
                      if (resp != null) {
                        messages.add(resp);
                      }
                    });
                    print(resp);
                  },
                  icon: Icon(Icons.send),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String?> query(String prompt) async {
    String? response;

    try {
      var resp = await http.post(
        Uri.parse(widget.url),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{"query": prompt}),
      );

      var json = jsonDecode(resp.body) as Map<String, dynamic>;

      response = json["response"];
    } catch (e) {
      print(e);
    }

    return response;
  }
}
