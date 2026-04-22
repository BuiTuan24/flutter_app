import 'package:flutter/material.dart';
import 'package:flutter_application_1/Bloc_auth/auth_bloc.dart';
import 'package:flutter_application_1/Bloc_auth/auth_event.dart' show LogoutEvent;
import 'package:flutter_application_1/screens/change_password.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:flutter_application_1/screens/support_page.dart';
import 'package:http/http.dart' as http;
import 'ReminderScreen.dart';
import 'SafetyScreen.dart';
import 'ScheduleScreen.dart';
import 'SettingsScreen.dart';
import 'TrackingScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String userName = "Loading...";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<String> fetchUserName(String email) async {
    final res = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/auth/me?email=$email'),
    );

    if (res.statusCode == 200) {
      return res.body.replaceAll('"', '');
    } else {
      throw Exception("Lỗi lấy tên");
    }
  }
  Future<void> deleteAccount() async {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Xóa tài khoản"),
      content: Text("Hành động này không thể hoàn tác!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Hủy"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            // demo trước
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Đã xóa tài khoản (demo)")),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => false,
            );
          },
          child: Text("Xóa"),
        ),
      ],
    ),
  );
}
  void loadUser() async {
    String email = "tuan@gmail.com"; // 🔥 sau này thay bằng email từ login

    try {
      final name = await fetchUserName(email);
      setState(() {
        userName = name;
      });
    } catch (e) {
      setState(() {
        userName = "User";
      });
    }
  }

  Widget buildButton(BuildContext context, String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
        child: Text(title, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  void showMenu() {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Đổi mật khẩu"),
            onTap: () {
              Navigator.pop(context); // đóng sheet
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordPage()),
              );
            },
          ),
          ListTile(title: Text("Version 13.10.2.0.2")),
          ListTile(
            title: Text("Xóa tài khoản"),
            onTap: () async {
              Navigator.pop(context);
              await deleteAccount();
            },
          ),
          ListTile(
            title: Text("Trợ giúp & hỗ trợ"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SupportPage()),
              );
            },
          ),
          ListTile(
            title: Text("Đăng xuất"),
            onTap: () {
              Navigator.pop(context);

              // TODO: sau này clear token ở đây

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginPage()),
                (route) => false,
              );
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhắc thuốc"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: showMenu,
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 👇 lời chào
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Xin chào, $userName 👋",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            buildButton(context, "Quản lý lịch trình uống thuốc", const ScheduleScreen()),
            buildButton(context, "Thông báo & nhắc nhở", const ReminderScreen()),
            buildButton(context, "Theo dõi & báo cáo", const TrackingScreen()),
            buildButton(context, "Kết nối & an toàn", const SafetyScreen()),
            buildButton(context, "Cá nhân hóa & trải nghiệm", const SettingsScreen()),
          ],
        ),
      ),
    );
  }
}