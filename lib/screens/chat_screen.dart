import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String? title;
  final String url;
  final String sessionId;

  const ChatScreen(
      {required this.url, required this.sessionId, this.title, super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _promptTextController = TextEditingController();

  bool isLoading = false;
  List<String> messages = [];

  @override
  void initState() {
    Future(() async {
      var resp = await getHistory();
      setState(() {
        messages.clear();
        messages.addAll(Iterable.castFrom(resp));
        print("Added history");
      });
    });
    super.initState();
  }

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
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(31, 82, 82, 82)),
                    child: Text(messages[index]),
                  ),
                ),
                itemCount: messages.length,
              ),
            ),
            isLoading
                ? CircularProgressIndicator()
                : Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
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
                            if (resp.isNotEmpty) {
                              messages.addAll(Iterable.castFrom(resp));
                              _promptTextController.clear();
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

  Future<List<String?>> query(String prompt) async {
    List<String?> responses = [];
    var endpoint = Uri.parse("${widget.url}/${widget.sessionId}/query");
    try {
      var resp = await http.post(
        endpoint,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{"query": prompt}),
      );
      print("sent request to $endpoint");

      var json = jsonDecode(resp.body) as Map<String, dynamic>;

      // var history = json["history"];
      // for (var item in history) {
      //   responses.add(item["response"]);
      // }
      responses.add(json["response"]);
      print(responses);
    } catch (e) {
      print(e);
    }

    return responses;
  }

  Future<List<String?>> getHistory() async {
    List<String?> responses = [];
    var endpoint = Uri.parse("${widget.url}/${widget.sessionId}");
    try {
      var resp = await http.get(
        endpoint,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );
      print("sent request to $endpoint");

      var json = jsonDecode(resp.body) as Map<String, dynamic>;

      var history = json["history"];
      for (var item in history) {
        responses.add(item["response"]);
      }
      // responses.add(json["response"]);
      print(responses);
    } catch (e) {
      print(e);
    }

    return responses;
  }
}
