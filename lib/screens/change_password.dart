import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confirmPass = TextEditingController();

  bool isLoading = false;

  Future<void> changePassword() async {
    setState(() => isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt("userId");

      if (userId == null) {
        throw Exception("Không tìm thấy user");
      }

      final res = await http.put(
        Uri.parse("http://10.0.2.2:8080/api/auth/users/change-password/$userId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "oldPassword": oldPass.text,
          "newPassword": newPass.text,
        }),
      );

      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Đổi mật khẩu thành công")),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${res.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối server")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Đổi mật khẩu")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: oldPass,
              decoration: InputDecoration(labelText: "Mật khẩu cũ"),
              obscureText: true,
            ),
            TextField(
              controller: newPass,
              decoration: InputDecoration(labelText: "Mật khẩu mới"),
              obscureText: true,
            ),
            TextField(
              controller: confirmPass,
              decoration: InputDecoration(labelText: "Nhập lại mật khẩu"),
              obscureText: true,
            ),
            SizedBox(height: 20),

            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                if (oldPass.text.isEmpty ||
                    newPass.text.isEmpty ||
                    confirmPass.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Vui lòng nhập đầy đủ")),
                  );
                  return;
                }

                if (newPass.text != confirmPass.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Mật khẩu không khớp")),
                  );
                  return;
                }

                if (newPass.text.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text("Mật khẩu phải >= 6 ký tự")),
                  );
                  return;
                }

                // 🔥 CALL API
                changePassword();
              },
              child: Text("Xác nhận"),
            )
          ],
        ),
      ),
    );
  }
}