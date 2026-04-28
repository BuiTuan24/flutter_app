import 'package:flutter/material.dart';
import 'package:flutter_application_1/screen_model/theme_provider.dart';
import 'package:flutter_application_1/screens/change_password.dart';
import 'package:flutter_application_1/screens/support_page.dart';
import 'package:flutter_application_1/screens/login_page.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const CircleAvatar(
          radius: 40,
          child: Icon(Icons.person, size: 40),
        ),
        const SizedBox(height: 10),
        const Center(child: Text("Tài khoản")),

        const SizedBox(height: 20),

        ListTile(
          title: const Text("Đổi mật khẩu"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChangePasswordPage()),
            );
          },
        ),
        ListTile(
          title: const Text("Trợ giúp & hỗ trợ"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SupportPage()),
            );
          },
        ),
        ListTile(
          title: const Text("Đăng xuất"),
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
            );
          },
        ),

        SwitchListTile(
          title: const Text("Dark Mode"),
          value: Provider.of<ThemeProvider>(context).isDark,
          onChanged: (_) {
            Provider.of<ThemeProvider>(context, listen: false)
                .toggleTheme();
          },
        ),
      ],
    );
  }
}