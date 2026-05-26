import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Message {
  final String text;
  final bool isUser;

  Message(this.text, this.isUser);
}

class AIChatScreen extends StatefulWidget {
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  List<Message> messages = [];

  TextEditingController controller = TextEditingController();

  ScrollController scrollController = ScrollController();

  bool isLoading = false;

  // ================= AI CALL =================

  Future<String> callAI(String message) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      int? userId = prefs.getInt("userId");
      final res = await http.post(
        Uri.parse("http://10.0.2.2:8080/api/chat"),
        headers: {
          "Content-Type": "application/json",
        },
          body: jsonEncode({
            "message": message,
            "userId": userId,
          }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        print(data);

        if (data["reply"] != null) {
          return "✅ Đã tạo lịch uống thuốc thành công";
        } else {
          return "AI không phản hồi";
        }
      } else {
        return "❌ Lỗi server: ${res.statusCode}";
      }
    } catch (e) {
      return "❌ Lỗi kết nối: $e";
    }
  }

  // ================= SEND MESSAGE =================

  void sendMessage() async {
    String text = controller.text.trim();

    if (text.isEmpty) return;

    // thêm tin nhắn user
    setState(() {
      messages.add(Message(text, true));
      isLoading = true;
    });

    controller.clear();

    // gọi AI
    String reply = await callAI(text);

    // thêm phản hồi AI
    setState(() {
      messages.add(Message(reply, false));
      isLoading = false;
    });
    if (reply.contains("thành công")) {

      Navigator.pop(context, true);

    }
    // snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Đã tạo lịch bằng AI"),
      ),
    );

    // auto scroll
    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });

    // TODO:
    // gọi reload list thuốc ở đây sau này
    // await fetchMedications();
  }

  // ================= MESSAGE UI =================

  Widget buildMessage(Message m) {
    return Align(
      alignment:
      m.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(14),
        margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        constraints: BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: m.isUser
              ? Colors.blue
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          m.text,
          style: TextStyle(
            fontSize: 15,
            color:
            m.isUser ? Colors.white : Colors.black87,
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

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text("AI hỗ trợ tạo lịch uống thuốc"),
        centerTitle: true,
      ),

      body: Column(
        children: [

          // ===== CHAT =====

          Expanded(
            child: ListView(
              controller: scrollController,
              reverse: true,
              padding: EdgeInsets.only(top: 10),
              children: messages.reversed
                  .map((m) => buildMessage(m))
                  .toList(),
            ),
          ),

          // ===== LOADING =====

          if (isLoading)
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text("AI đang tạo lịch thuốc..."),
                ],
              ),
            ),

          // ===== INPUT =====

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black12,
                )
              ],
            ),
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText:
                      "Ví dụ: Uống vitamin C, mỗi ngày, liều lượng 2 lúc 7h sáng",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10),

                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}