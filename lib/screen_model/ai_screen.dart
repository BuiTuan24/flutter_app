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

  TextEditingController controller =
  TextEditingController();

  ScrollController scrollController =
  ScrollController();

  bool isLoading = false;

  // ================= AI CALL =================

  Future<String> callAI(String message) async {

    try {

      final prefs =
      await SharedPreferences.getInstance();

      int? userId =
      prefs.getInt("userId");

      final res = await http.post(

        Uri.parse(
          "http://10.0.2.2:8080/api/chat",
        ),

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

  // ================= SEND =================

  void sendMessage() async {

    String text =
    controller.text.trim();

    if (text.isEmpty) return;

    setState(() {

      messages.add(
        Message(text, true),
      );

      isLoading = true;
    });

    controller.clear();

    String reply =
    await callAI(text);

    setState(() {

      messages.add(
        Message(reply, false),
      );

      isLoading = false;
    });

    if (reply.contains("thành công")) {

      Navigator.pop(context, true);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Đã tạo lịch bằng AI"),
      ),
    );

    Future.delayed(
      const Duration(milliseconds: 100),
          () {

        scrollController.animateTo(
          0,

          duration: const Duration(
            milliseconds: 300,
          ),

          curve: Curves.easeOut,
        );
      },
    );
  }

  // ================= CHAT BUBBLE =================

  Widget buildMessage(Message m) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Align(

      alignment:
      m.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(

        padding: const EdgeInsets.all(14),

        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),

        constraints:
        const BoxConstraints(maxWidth: 300),

        decoration: BoxDecoration(

          color: m.isUser
              ? Colors.blue
              : isDark
              ? Colors.grey.shade800
              : Colors.white,

          borderRadius:
          BorderRadius.circular(18),

          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black12,
            ),
          ],
        ),

        child: Text(

          m.text,

          style: TextStyle(

            fontSize: 15,

            color: m.isUser
                ? Colors.white
                : Theme.of(context)
                .textTheme
                .bodyLarge
                ?.color,
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

      appBar: AppBar(

        title: const Text(

          "AI Medication Assistant",

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: Stack(

        children: [

          // 🌄 Background

          Positioned.fill(

            child: Opacity(

              opacity: 0.9,

              child: Image.asset(

                "assets/images/image5.png",

                fit: BoxFit.cover,
              ),
            ),
          ),

          // overlay

          Positioned.fill(

            child: Container(

              color: Theme.of(context)
                  .scaffoldBackgroundColor
                  .withOpacity(0.45),
            ),
          ),

          Column(

            children: [

              // ===== CHAT =====

              Expanded(

                child: ListView(

                  controller: scrollController,

                  reverse: true,

                  padding:
                  const EdgeInsets.only(top: 10),

                  children: [

                    // 🤖 GỢI Ý

                    if (messages.isEmpty)

                      Padding(

                        padding:
                        const EdgeInsets.all(20),

                        child: Card(

                          elevation: 6,

                          color: Theme.of(context)
                              .cardColor
                              .withOpacity(0.85),

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(20),
                          ),

                          child: const Padding(

                            padding:
                            EdgeInsets.all(18),

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,

                              children: [

                                Text(

                                  "🤖 Gợi ý cho AI",

                                  style: TextStyle(

                                    fontSize: 18,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: 14),

                                Text(
                                  "• Uống vitamin C mỗi ngày lúc 7h sáng",
                                ),

                                SizedBox(height: 10),

                                Text(
                                  "• Thuốc đau đầu cách ngày lúc 20h",
                                ),

                                SizedBox(height: 10),

                                Text(
                                  "• Kháng sinh uống T2 T4 T6 lúc 9h",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ...messages.reversed
                        .map((m) => buildMessage(m))
                        .toList(),
                  ],
                ),
              ),

              // ===== LOADING =====

              if (isLoading)

                Padding(

                  padding: const EdgeInsets.all(10),

                  child: Row(

                    children: [

                      const SizedBox(

                        width: 18,
                        height: 18,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(

                        "AI đang tạo lịch thuốc...",

                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color,
                        ),
                      ),
                    ],
                  ),
                ),

              // ===== INPUT =====

              Container(

                margin: const EdgeInsets.all(10),

                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),

                decoration: BoxDecoration(

                  color: Theme.of(context)
                      .cardColor
                      .withOpacity(0.88),

                  borderRadius:
                  BorderRadius.circular(22),

                  boxShadow: [

                    BoxShadow(
                      blurRadius: 10,
                      color: Colors.black12,
                    ),
                  ],
                ),

                child: Row(

                  children: [

                    Expanded(

                      child: TextField(

                        controller: controller,

                        onSubmitted: (_) =>
                            sendMessage(),

                        style: TextStyle(

                          color: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color,
                        ),

                        decoration: InputDecoration(

                          hintText:
                          "Nhập lịch uống thuốc...",

                          hintStyle: TextStyle(

                            color: Theme.of(context)
                                .hintColor,
                          ),

                          border: OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(14),
                          ),

                          contentPadding:
                          const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    CircleAvatar(

                      radius: 25,

                      backgroundColor: Colors.blue,

                      child: IconButton(

                        icon: const Icon(
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
        ],
      ),
    );
  }
}