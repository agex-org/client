import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Message {
  const Message(this.query, this.response);
  final String query;
  final String response;
}

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
  final _scrollController = ScrollController();

  bool isLoading = false;
  List<Message> messages = [];

  @override
  void initState() {
    Future(() async {
      var resp = await getHistory();
      setState(() {
        messages.clear();
        messages.addAll(Iterable.castFrom(resp));
        print("Added history");
      });

      scrollToEnd();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title!) : Text("New Chat"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) => Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(31, 82, 82, 82),
                        ),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(messages[index].query),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(31, 82, 82, 82),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(messages[index].response),
                        ),
                      ),
                    ],
                  ),
                ),
                itemCount: messages.length,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              alignment: Alignment.center,
              height: 70,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Write your query here",
                              hintStyle: TextStyle(color: Colors.blueGrey),
                              border: OutlineInputBorder(),
                            ),
                            controller: _promptTextController,
                            onFieldSubmitted: (_) {
                              setState(() {
                                onFormSubmitted("");
                              });
                              scrollToEnd();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              onFormSubmitted("");
                            });
                            scrollToEnd();
                          },
                          icon: Icon(Icons.send),
                        )
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  void scrollToEnd() {
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }

  void onFormSubmitted(String? _) async {
    setState(() {
      isLoading = true;
    });
    var resp = await query(_promptTextController.text);
    setState(() {
      isLoading = false;
      if (resp != null) {
        messages.add(resp);
        _promptTextController.clear();
      }

      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      });
    });
    print(resp);
  }

  Future<Message?> query(String prompt) async {
    Message? response;
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
      // responses.add(prompt);
      // responses.add(json["response"]);

      response = Message(prompt, json["response"]);
      print(response);
    } catch (e) {
      print(e);
    }

    return response;
  }

  Future<List<Message?>> getHistory() async {
    List<Message> responses = [];
    var endpoint = Uri.parse("${widget.url}/history/${widget.sessionId}");
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

      print(history);
      for (var item in history) {
        responses.add(Message(item["query"], item["response"]));
      }
      // responses.add(json["response"]);
      print(responses);
    } catch (e) {
      print(e);
    }

    return responses;
  }
}
