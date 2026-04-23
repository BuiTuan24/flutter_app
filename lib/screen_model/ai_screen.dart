import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class AIChatScreen extends StatefulWidget {
  @override
  _AIChatScreenState createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  List<Message> messages = [];
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  Future<String> callAI(String message) async {
    try {
      final res = await http.post(
        Uri.parse("http://10.0.2.2:8080/api/chat"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"message": message}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["reply"] ?? "Không có phản hồi";
      } else {
        return "Lỗi server: ${res.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }

  void sendMessage() async {
    String text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add(Message(text, true));
      isLoading = true;
    });

    controller.clear();

    String reply = await callAI(text);

    setState(() {
      messages.add(Message(reply, false));
      isLoading = false;
    });

    // 👉 auto scroll xuống
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildMessage(Message m) {
    return Align(
      alignment:
      m.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: m.isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          m.text,
          style: TextStyle(
            color: m.isUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI hỗ trợ uống thuốc")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              reverse: true,
              children: messages.reversed
                  .map((m) => buildMessage(m))
                  .toList(),
            ),
          ),

          if (isLoading)
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("AI đang suy nghĩ..."),
            ),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => sendMessage(),
                  decoration: InputDecoration(
                    hintText: "Nhập câu hỏi...",
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}