import 'dart:convert';

import 'package:agex_client/models/chat_history.dart';
import 'package:agex_client/screens/chat_screen.dart';
import 'package:agex_client/screens/landing.dart';
import 'package:agex_client/widgets/chat_history_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "http://localhost:8000/api";

  bool isLoading = false;

  List<ChatHistory> chatHistoryList = [];

  @override
  void initState() {
    getChatHistory().then((val) {
      setState(() {
        chatHistoryList = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
        onSettingsPressed: () async {
          String? newUrl = await showDialog<String>(
            context: context,
            builder: (context) => CustomDialog(
              currentUrl: url,
            ),
          );
          if (newUrl != null) {
            setState(() {
              url = newUrl;
              print(url);
            });
          }
        },
        onNewChatPresses: () async {
          var sessionId = await createSession("New Chat");
          if (sessionId != null && mounted) {
            print("sessionid: $sessionId");
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ChatScreen(
                url: url,
                sessionId: sessionId,
              ),
            ));
          }
        },
        onLandingPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AgexLanding(),
            ),
          );
        },
        onFlushHistory: () async {
          http.post(
            Uri.parse("$url/flush"),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
          );
        },
      ) as PreferredSizeWidget?,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Chat History",
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Card(
                      child: ChatHistoryItem(
                        chatHistoryList[index].title ?? "Untitled",
                        url,
                        chatHistoryList[index].sessionId,
                        () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              url: url,
                              sessionId: chatHistoryList[index].sessionId,
                            ),
                          ));
                        },
                      ),
                    ),
                  );
                },
                itemCount: chatHistoryList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<ChatHistory>> getChatHistory() async {
    List<ChatHistory> chatHistoryList = [];
    try {
      var resp = await http.get(
        Uri.parse("$url/list"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      var json = jsonDecode(resp.body) as Map<String, dynamic>;

      var items = json["chat_history_list"];
      if (items != null) {
        for (var item in items) {
          chatHistoryList.add(
              ChatHistory(sessionId: item["session_id"], title: item["title"]));
        }
        return chatHistoryList;
      }
      throw Exception("Failed to fetch chat history");
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String?> createSession(String title) async {
    String? sessionId;
    try {
      var resp = await http.post(
        Uri.parse("$url/create"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{"title": title}),
      );

      var json = jsonDecode(resp.body) as Map<String, dynamic>;

      sessionId = json["session_id"];
    } catch (e) {
      return null;
    }

    return sessionId;
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar(
      {required this.onSettingsPressed,
      required this.onNewChatPresses,
      super.key});

  final VoidCallback onSettingsPressed;
  final VoidCallback onNewChatPresses;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text("Agex"),
      elevation: 3,
      leading: IconButton(
        onPressed: onSettingsPressed,
        icon: Icon(Icons.settings),
      ),
      actions: [
        ElevatedButton(
          onPressed: onNewChatPresses,
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.white),
          ),
          child: Text("New Chat"),
        ),
        SizedBox(
          width: 16,
        )
      ],
    );
  }
}

PreferredSizeWidget getAppBar({
  required VoidCallback onSettingsPressed,
  required VoidCallback onNewChatPresses,
  required VoidCallback onLandingPressed,
  required VoidCallback onFlushHistory,
}) {
  return AppBar(
    title: Row(
      children: [
        ClipOval(
          child: Image.asset(
            "assets/images/logo.png",
            width: 35,
          ),
        ),
        SizedBox(width: 10),
        Text("Agex"),
      ],
    ),
    elevation: 3,
    leading: IconButton(
      onPressed: onSettingsPressed,
      icon: Icon(Icons.settings),
    ),
    actions: [
      ElevatedButton(
        onPressed: onNewChatPresses,
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        child: Text("New Chat"),
      ),
      ElevatedButton(
        onPressed: onLandingPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        child: Text("Landing"),
      ),
      ElevatedButton(
        onPressed: onFlushHistory,
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(Colors.white),
        ),
        child: Text("Flush History"),
      ),
      SizedBox(
        width: 16,
      )
    ],
  );
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({required this.currentUrl, super.key});
  final String currentUrl;
  @override
  Widget build(BuildContext context) {
    final urlController = TextEditingController(text: currentUrl);
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("API URL:"),
          TextFormField(
            controller: urlController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(urlController.text);
              },
              child: Text("Save"))
        ],
      ),
    );
  }
}
