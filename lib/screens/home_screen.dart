import 'package:agex_client/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url = "http://localhost:8000/api/query";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agex"),
        elevation: 3,
        leading: IconButton(
            onPressed: () async {
              final urlController = TextEditingController(text: url);
              String? newUrl = await showDialog<String>(
                context: context,
                builder: (context) => Dialog(
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
                ),
              );
              if (newUrl != null) {
                setState(() {
                  url = newUrl;
                  print(url);
                });
              }
            },
            icon: Icon(Icons.settings)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatScreen(
                  url: url,
                ),
              ));
            },
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: Text("New Chat"),
          ),
          SizedBox(
            width: 16,
          )
        ],
      ),
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
            ChatHistoryItem("What's the meaning of world", url),
            ChatHistoryItem("What's the meaning of world", url),
            ChatHistoryItem("What's the meaning of world", url)
          ],
        ),
      ),
    );
  }
}

class ChatHistoryItem extends StatelessWidget {
  const ChatHistoryItem(this.title, this.url, {super.key});

  final String title;
  final String url;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        child: ListTile(
          title: Text(title),
          tileColor: Colors.black26,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  title: title,
                  url: url,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
