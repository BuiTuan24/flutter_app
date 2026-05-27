import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hỗ trợ"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Stack(
        children: [

          // 🌄 ẢNH NỀN
          Positioned.fill(
            child: Opacity(
              opacity: isDark ? 1 : 0.18,
              child: Image.asset(
                "assets/images/image6.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 🌫 OVERLAY
          Positioned.fill(
            child: Container(
              color: isDark
                  ? Colors.black.withOpacity(0.45)
                  : Colors.white.withOpacity(0.25),
            ),
          ),

          // 📋 CONTENT
          ListView(
            padding: const EdgeInsets.all(16),
            children: [

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.72),

                  borderRadius: BorderRadius.circular(24),

                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.white.withOpacity(0.5),
                  ),

                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.08),
                    )
                  ],
                ),

                child: Column(
                  children: [

                    Icon(
                      Icons.support_agent,
                      size: 60,
                      color: Colors.blue.shade400,
                    ),

                    const SizedBox(height: 14),

                    Text(
                      "Trung tâm hỗ trợ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Liên hệ nhân viên hỗ trợ khi gặp vấn đề với ứng dụng hoặc lịch uống thuốc.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: isDark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        icon: const Icon(Icons.chat_bubble_outline),

                        label: const Text(
                          "Chat với nhân viên",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const SupportChatScreen(),
                            ),
                          );
                        },
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

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});

  @override
  State<SupportChatScreen> createState() =>
      _SupportChatScreenState();
}

class _SupportChatScreenState
    extends State<SupportChatScreen> {

  final List<Map<String, String>> messages = [];

  void addBotMessage(String text) {
    setState(() {
      messages.add({
        "sender": "bot",
        "text": text,
      });
    });
  }

  @override
  void initState() {
    super.initState();

    addBotMessage(
      "Xin chào quý khách 👋\n"
          "Vui lòng chọn chức năng hỗ trợ bên dưới.",
    );
  }

  Future<void> confirmExit() async {
    bool? result = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Thoát hỗ trợ"),
          content: const Text(
            "Nếu đồng ý, lịch sử trò chuyện sẽ không được lưu và sẽ biến mất.",
          ),
          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Không"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Đồng ý"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      Navigator.pop(context);
    }
  }

  Widget buildMessage(Map<String, String> msg) {
    bool isBot = msg["sender"] == "bot";

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment:
      isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot
              ? (isDark
              ? Colors.grey.shade800
              : Colors.grey.shade300)
              : (isDark
              ? Colors.blue.shade700
              : Colors.blue.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          msg["text"] ?? "",
          style: TextStyle(
            color: isDark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(

      onWillPop: () async {
        await confirmExit();
        return false;
      },

      child: Scaffold(

        appBar: AppBar(
          title: const Text("Hỗ trợ trực tuyến"),
        ),

        body: Column(
          children: [

            Expanded(
              child: ListView(
                children:
                messages.map(buildMessage).toList(),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(12),

              child: Column(
                children: [

                  // 📞 Hotline
                  ElevatedButton.icon(
                    onPressed: () {
                      addBotMessage(
                        "📞 Hotline CSKH: 1900 1234\n"
                            "Thời gian hỗ trợ: 8:00 - 22:00",
                      );
                    },

                    icon: const Icon(Icons.phone),

                    label: const Text("CSKH Hotline"),
                  ),

                  const SizedBox(height: 10),

                  // ❓ FAQ
                  ElevatedButton.icon(

                    onPressed: () {

                      showModalBottomSheet(

                        context: context,

                        backgroundColor:
                        Theme.of(context)
                            .scaffoldBackgroundColor,

                        builder: (_) {

                          return Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [

                              ListTile(
                                title: const Text(
                                  "1. Làm sao nếu tôi quên mật khẩu?",
                                ),

                                onTap: () {

                                  Navigator.pop(context);

                                  addBotMessage(
                                    "🔐 Hiện tại phần mềm chưa hỗ trợ lấy lại mật khẩu "
                                        "do vấn đề bảo mật. Quý khách vui lòng ghi nhớ mật khẩu "
                                        "để tránh mất tài khoản.",
                                  );
                                },
                              ),

                              ListTile(
                                title: const Text(
                                  "2. Làm sao sử dụng AI tạo lịch thuốc?",
                                ),

                                onTap: () {

                                  Navigator.pop(context);

                                  addBotMessage(
                                    "🤖 Hiện tại AI chỉ hỗ trợ tạo lịch theo cú pháp "
                                        "hướng dẫn và không hỗ trợ chức năng khác ngoài "
                                        "tạo lịch uống thuốc.",
                                  );
                                },
                              ),

                              ListTile(
                                title: const Text(
                                  "3. Tôi có thể đổi mật khẩu ở đâu?",
                                ),

                                onTap: () {

                                  Navigator.pop(context);

                                  addBotMessage(
                                    "⚙️ Quý khách có thể đổi mật khẩu "
                                        "trong phần cài đặt hồ sơ.",
                                  );
                                },
                              ),

                              ListTile(
                                title: const Text(
                                  "4. Dark Mode có ảnh hưởng sức khỏe không?",
                                ),

                                onTap: () {

                                  Navigator.pop(context);

                                  addBotMessage(
                                    "🌙 Dark Mode có thể giúp giảm chói mắt "
                                        "khi dùng trong tối. Trong môi trường sáng "
                                        "quý khách có thể tắt tùy nhu cầu sử dụng.",
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },

                    icon: const Icon(Icons.help),

                    label: const Text(
                      "Những câu hỏi hay gặp",
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ⚠️ Chưa hỗ trợ
                  ElevatedButton.icon(

                    onPressed: () {

                      addBotMessage(
                        "⚠️ Hiện tại hệ thống chưa hỗ trợ chuyên sâu "
                            "cho chức năng này.",
                      );
                    },

                    icon: const Icon(Icons.warning),

                    label: const Text(
                      "Chưa hỗ trợ chuyên sâu",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}